Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752042AbaFVOx6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2014 10:53:58 -0400
Received: from mail.active-venture.com ([67.228.131.205]:50089 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751883AbaFVOxy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2014 10:53:54 -0400
X-Originating-IP: 108.223.40.66
Message-ID: <53A6EDF6.2030203@roeck-us.net>
Date: Sun, 22 Jun 2014 07:53:42 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Chen Gang <gang.chen.5i5j@gmail.com>, Liqin Chen <liqin.linux@gmail.com>,
        Lennox Wu <lennox.wu@gmail.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] arch/score/include/uapi/asm/ptrace.h: Add prefix 'SCORE_'
 for related macros
References: <53A66000.4010208@gmail.com> <53A6669B.1010701@roeck-us.net> <53A66A92.9040106@gmail.com>
In-Reply-To: <53A66A92.9040106@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/21/2014 10:33 PM, Chen Gang wrote:

[ ... ]

>> Any idea where to find a cross-compile toolchain for this architecture ?
>>
>
> I use latest source code of gcc and binutils with git.
>
>    related source code:
>
>      git://sourceware.org/git/binutils-gdb.git
>      git://gcc.gnu.org/git/gcc.git
>
> Issues:
>
>    For binutils, have to use the latest one (I have fixed one segment
>    fault issue of gas for score, and integrated into gas main line by
>    maintainer in Jun 13, 2014).
>
>    For gcc (after binutils has installed), when building glibc, may need
>    modify the absolute path for score-elf-gas, score-elf-ld ... in
>    related auto-generated file.
>
>    Under ubuntu (but under fedora, it is OK), may need export
>    LD_LIBRARY_PATH=/usr/local/lib for searching libmpfr.so.
>
> My current binary informations:
>
>    root@gchen:/upstream/toolchain/binutils-gdb# /usr/local/bin/score-elf-ld -v
>    GNU ld (GNU Binutils) 2.24.51.20140609
>    root@gchen:/upstream/toolchain/binutils-gdb# /usr/local/bin/score-elf-as -v
>    GNU assembler version 2.24.51 (score-elf) using BFD version (GNU Binutils) 2.24.51.20140609
>    root@gchen:/upstream/toolchain/binutils-gdb# /usr/local/bin/score-elf-gcc -v
>    Using built-in specs.
>    COLLECT_GCC=/usr/local/bin/score-elf-gcc
>    COLLECT_LTO_WRAPPER=/usr/local/libexec/gcc/score-elf/4.10.0/lto-wrapper
>    Target: score-elf
>    Configured with: ../gcc/configure --without-header --disable-nls --enable-language=c --disable-threads --disable-shared --enable-werror=no target_configargs=enable_vtable_verify=yes --target=score-elf --enable-obsolete
>    Thread model: single
>    gcc version 4.10.0 20140530 (experimental) (GCC)
>

I did that, and managed to build gcc.

However, when trying to compile score defconfig, I get internal compiler errors in cc1
when compiling drivers/tty/tty_mutex.o and block/elevator.o.

  CC      block/elevator.o
score-elf-gcc: internal compiler error: Segmentation fault (program cc1)
0x40c073 execute
	../../gcc/gcc/gcc.c:2848
Please submit a full bug report,
with preprocessed source if appropriate.
Please include the complete backtrace with any bug report.
See <http://gcc.gnu.org/bugs.html> for instructions.
make[1]: *** [block/elevator.o] Error 4
make: *** [block/elevator.o] Error 2

Do you see that as well ?

This is with

GNU assembler version 2.24.51 (score-elf) using BFD version (GNU Binutils) 2.24.51.20140622

and gcc configured with:

Configured with: ../gcc/configure --prefix=/opt/kernel/score --program-prefix=score-elf- \
--target=score-elf --without-header --disable-nls --enable-languages=c --disable-threads \
--disable-shared --enable-werror=no target_configargs=enable_vtable_verify=yes \
--enable-obsolete --disable-libssp --disable-libquadmath

Tip of gcc source is commit d8686b0aa945a, tip of binutils source is commit d17c74c1d41.
Your assembler fix is included in this version of binutils.

Thanks,
Guenter

