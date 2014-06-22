Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751093AbaFVFdX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2014 01:33:23 -0400
Received: from mail-pd0-f182.google.com ([209.85.192.182]:54954 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750782AbaFVFdW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2014 01:33:22 -0400
Message-ID: <53A66A92.9040106@gmail.com>
Date: Sun, 22 Jun 2014 13:33:06 +0800
From: Chen Gang <gang.chen.5i5j@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Guenter Roeck <linux@roeck-us.net>, Liqin Chen <liqin.linux@gmail.com>,
        Lennox Wu <lennox.wu@gmail.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] arch/score/include/uapi/asm/ptrace.h: Add prefix 'SCORE_'
 for related macros
References: <53A66000.4010208@gmail.com> <53A6669B.1010701@roeck-us.net>
In-Reply-To: <53A6669B.1010701@roeck-us.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/22/2014 01:16 PM, Guenter Roeck wrote:
> On 06/21/2014 09:48 PM, Chen Gang wrote:
>> 'COUNTER' and other same kind macros are too common to use, and easy to
>> get conflict with other modules. So add prefix for them.
>>
>> The related warning (allmodconfig with score):
>>
>>      CC [M]  drivers/md/raid1.o
>>    In file included from drivers/md/raid1.c:42:0:
>>    drivers/md/bitmap.h:93:0: warning: "COUNTER" redefined
>>     #define COUNTER(x) (((bitmap_counter_t) x) & COUNTER_MAX)
>>     ^
>>    In file included from ./arch/score/include/asm/ptrace.h:4:0,
>>                     from include/linux/sched.h:31,
>>                     from include/linux/blkdev.h:4,
>>                     from drivers/md/raid1.c:36:
>>    ./arch/score/include/uapi/asm/ptrace.h:13:0: note: this is the
>> location of the previous definition
>>     #define COUNTER  38
>>
>>
>> Signed-off-by: Chen Gang <gang.chen.5i5j@gmail.com>
> 
> Any idea where to find a cross-compile toolchain for this architecture ?
> 

I use latest source code of gcc and binutils with git.

  related source code:

    git://sourceware.org/git/binutils-gdb.git
    git://gcc.gnu.org/git/gcc.git

Issues:

  For binutils, have to use the latest one (I have fixed one segment
  fault issue of gas for score, and integrated into gas main line by
  maintainer in Jun 13, 2014).

  For gcc (after binutils has installed), when building glibc, may need
  modify the absolute path for score-elf-gas, score-elf-ld ... in
  related auto-generated file.

  Under ubuntu (but under fedora, it is OK), may need export
  LD_LIBRARY_PATH=/usr/local/lib for searching libmpfr.so.

My current binary informations:

  root@gchen:/upstream/toolchain/binutils-gdb# /usr/local/bin/score-elf-ld -v
  GNU ld (GNU Binutils) 2.24.51.20140609
  root@gchen:/upstream/toolchain/binutils-gdb# /usr/local/bin/score-elf-as -v
  GNU assembler version 2.24.51 (score-elf) using BFD version (GNU Binutils) 2.24.51.20140609
  root@gchen:/upstream/toolchain/binutils-gdb# /usr/local/bin/score-elf-gcc -v
  Using built-in specs.
  COLLECT_GCC=/usr/local/bin/score-elf-gcc
  COLLECT_LTO_WRAPPER=/usr/local/libexec/gcc/score-elf/4.10.0/lto-wrapper
  Target: score-elf
  Configured with: ../gcc/configure --without-header --disable-nls --enable-language=c --disable-threads --disable-shared --enable-werror=no target_configargs=enable_vtable_verify=yes --target=score-elf --enable-obsolete
  Thread model: single
  gcc version 4.10.0 20140530 (experimental) (GCC) 


Thanks.
-- 
Chen Gang

Open, share, and attitude like air, water, and life which God blessed
