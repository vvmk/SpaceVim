"=============================================================================
" layers.vim --- Develop script for update layer index
" Copyright (c) 2016-2017 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg at 163.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

scriptencoding utf-8

function! SpaceVim#dev#layers#update() abort

  let [start, end] = s:find_position()
  if start != 0 && end != 0
    if end - start > 1
      exe (start + 1) . ',' . (end - 1) . 'delete'
    endif
    call append(start, s:generate_content())
    silent! Neoformat
  endif

endfunction

function! SpaceVim#dev#layers#updateCn() abort

  let [start, end] = s:find_position_cn()
  if start != 0 && end != 0
    if end - start > 1
      exe (start + 1) . ',' . (end - 1) . 'delete'
    endif
    call append(start, s:generate_content_cn())
    silent! Neoformat
  endif

endfunction

function! s:find_position() abort
  let start = search('^<!-- SpaceVim layer list start -->$','bwnc')
  let end = search('^<!-- SpaceVim layer list end -->$','bnwc')
  return sort([start, end], 'n')
endfunction

function! s:find_position_cn() abort
  let start = search('^<!-- SpaceVim layer cn list start -->$','bwnc')
  let end = search('^<!-- SpaceVim layer cn list end -->$','bnwc')
  return sort([start, end], 'n')
endfunction

function! s:generate_content() abort
  let content = ['', '## Available layers', '']
  let content += s:layer_list()
  return content
endfunction

function! s:generate_content_cn() abort
  let content = ['', '## 可用模块', '']
  let content += s:layer_list_cn()
  return content
endfunction

function! s:layer_list() abort
  let layers = SpaceVim#util#globpath('~/.SpaceVim/', 'docs/layers/**/*.md')
  let list = [
        \ '| Name | Description |',
        \ '| ---------- | ------------ |'
        \ ]
  call remove(layers, index(layers, '/home/wsdjeg/.SpaceVim/docs/layers/index.md'))
  for layer in layers
    let name = split(layer, '/docs/layers/')[1][:-4] . '/'
    let url = name
    if name ==# 'language-server-protocol/'
      let name = 'lsp'
    endif
    let content = readfile(layer)
    if len(content) > 3
      let line = '| [' . join(split(name, '/'), '#') . '](' . url . ')    |   ' . content[2][14:-2] . ' | '
    else
      let line = '| [' . join(split(name, '/'), '#') . '](' . url . ')    |   can not find Description |'
    endif
    call add(list, line)
  endfor
  return list
endfunction

function! s:layer_list_cn() abort
  let layers = SpaceVim#util#globpath('~/.SpaceVim/', 'docs/cn/layers/**/*.md')
  let list = [
        \ '| 名称 | 描述 |',
        \ '| ---------- | ------------ |'
        \ ]
  call remove(layers, index(layers, '/home/wsdjeg/.SpaceVim/docs/cn/layers/index.md'))
  for layer in layers
    let name = split(layer, '/docs/cn/layers/')[1][:-4] . '/'
    let url = name
    let content = readfile(layer)
    if len(content) > 3
      let line = '| [' . join(split(name, '/'), '#') . '](' . url . ')    |   ' . content[2][14:-2] . ' | '
    else
      let line = '| [' . join(split(name, '/'), '#') . '](' . url . ')    |   can not find Description |'
    endif
    call add(list, line)
  endfor
  return list
endfunction
