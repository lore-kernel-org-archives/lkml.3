Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933410AbaFLRAA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 13:00:00 -0400
Received: from mail-ig0-f170.google.com ([209.85.213.170]:52378 "EHLO
	mail-ig0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753116AbaFLQ76 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 12:59:58 -0400
MIME-Version: 1.0
Date: Thu, 12 Jun 2014 09:59:57 -0700
Message-ID: <CAKx2Y1kBy-mrxm+1u88XVL2Z7gYKQe5U-EG2SBTzNCRAs_UVVw@mail.gmail.com>
Subject: Segmentation fault on all golang executables
From: Kui Zhang <kuizhang@gmail.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        luto@amacapital.net
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

This commit seem to cause Segmentation fault on any of my golang executables.

commit 6f121e548f83674ab4920a4e60afb58d4f61b829
Author: Andy Lutomirski <luto@amacapital.net>
Date:   Mon May 5 12:19:34 2014 -0700

x86, vdso: Reimplement vdso.so preparation in build-time C

golang-go                             2:1.2.1-2ubuntu1
     amd64
golang-go-linux-amd64                 2:1.2.1-2ubuntu1
     amd64


/tmp]> go
Segmentation fault

go_seg]> cat a.go
package main

func main(){
        println("test")

}

################

(gdb) run
Starting program: go_seg/a

Program received signal SIGSEGV, Segmentation fault.
vdso_parse_symbols (vdso_info=<error reading variable: Attempt to
dereference a generic pointer.>,
    version=<error reading variable: Attempt to dereference a generic pointer.>)
    at /usr/lib/go/src/pkg/runtime/vdso_linux_amd64.c:279
279                     if(ELF64_ST_TYPE(sym->st_info) != STT_FUNC)
(gdb) bt
#0  vdso_parse_symbols (vdso_info=<error reading variable: Attempt to
dereference a generic pointer.>,
    version=<error reading variable: Attempt to dereference a generic pointer.>)
    at /usr/lib/go/src/pkg/runtime/vdso_linux_amd64.c:279
#1  0x0000000000417228 in runtime.linux_setup_vdso (
    argc=<error reading variable: Attempt to dereference a generic pointer.>,
    argv=<error reading variable: Attempt to dereference a generic pointer.>)
    at /usr/lib/go/src/pkg/runtime/vdso_linux_amd64.c:326
#2  0x000000000041358c in runtime.args (c=<error reading variable:
Attempt to dereference a generic pointer.>,
    v=<error reading variable: Attempt to dereference a generic
pointer.>) at /usr/lib/go/src/pkg/runtime/runtime.c:86
#3  0x000000000041a01b in _rt0_go () at
/usr/lib/go/src/pkg/runtime/asm_amd64.s:85
#4  0x0000000000000001 in ?? ()
#5  0x00007fffffffe7b8 in ?? ()
#6  0x0000000000000001 in ?? ()
#7  0x00007fffffffe7b8 in ?? ()
#8  0x0000000000000000 in ?? ()

###########################################

Starting program: /usr/bin/go
[Thread debugging using libthread_db enabled]
Using host libthread_db library "/lib/x86_64-linux-gnu/libthread_db.so.1".

Program received signal SIGSEGV, Segmentation fault.
vdso_parse_symbols (vdso_info=<error reading variable: Attempt to
dereference a generic pointer.>,
    version=<error reading variable: Attempt to dereference a generic pointer.>)
    at /usr/lib/go/src/pkg/runtime/vdso_linux_amd64.c:279
279                     if(ELF64_ST_TYPE(sym->st_info) != STT_FUNC)
(gdb) bt
#0  vdso_parse_symbols (vdso_info=<error reading variable: Attempt to
dereference a generic pointer.>,
    version=<error reading variable: Attempt to dereference a generic pointer.>)
    at /usr/lib/go/src/pkg/runtime/vdso_linux_amd64.c:279
#1  0x0000000000470288 in runtime.linux_setup_vdso (
    argc=<error reading variable: Attempt to dereference a generic pointer.>,
    argv=<error reading variable: Attempt to dereference a generic pointer.>)
    at /usr/lib/go/src/pkg/runtime/vdso_linux_amd64.c:326
#2  0x000000000046bf6c in runtime.args (c=<error reading variable:
Attempt to dereference a generic pointer.>,
    v=<error reading variable: Attempt to dereference a generic
pointer.>) at /usr/lib/go/src/pkg/runtime/runtime.c:86
#3  0x000000000047558b in _rt0_go () at
/usr/lib/go/src/pkg/runtime/asm_amd64.s:85
#4  0x0000000000000001 in ?? ()
#5  0x00007fffffffe7d8 in ?? ()
#6  0x0000000000000001 in ?? ()
#7  0x00007fffffffe7d8 in ?? ()
#8  0x0000000000000000 in ?? ()



thanks
Kui.Z
