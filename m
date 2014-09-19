Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752089AbaISEKh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 00:10:37 -0400
Received: from smtp.mei.co.jp ([133.183.100.20]:60619 "EHLO smtp.mei.co.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750718AbaISEKf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 00:10:35 -0400
Date: Fri, 19 Sep 2014 13:10:21 +0900
From: Masahiro Yamada <yamada.m@jp.panasonic.com>
To: linux-kbuild@vger.kernel.org, llvmlinux@lists.linuxfoundation.org
Subject: How to build the kernel with Clang?
Cc: Vinicius Tinti <viniciustinti@gmail.com>,
        Behan Webster <behanw@converseincode.com>,
        linux-kernel@vger.kernel.org
X-BkSecure-Plugin: BkSecure.dll Ver 1, 2, 7, 0
Message-Id: <20140919131021.EE3E.AA925319@jp.panasonic.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.64.06 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Clang folks,


I'd like to know the status of Clang support
in the Linux mainline.


I can see some "clang" specific parts in makefiles,
so I guess Clang is already supported to a certain extent.


I just tried to build with "HOSTCC=clang CC=clang"
but it would not work.

Is there any tips I am missing here?



$ git describe 
v3.17-rc5-25-g8ba4caf
$ clang --version
Ubuntu clang version 3.5-1ubuntu1 (trunk) (based on LLVM 3.5)
Target: x86_64-pc-linux-gnu
Thread model: posix
$ make HOSTCC=clang defconfig
  HOSTCC  scripts/basic/fixdep
clang: error: unknown argument: '-fno-delete-null-pointer-checks'
make[1]: *** [scripts/basic/fixdep] Error 1
make: *** [scripts_basic] Error 2

 [ edit the top Makefile and comment out -fno-delete-null-pointer-checks]
 
$ make HOSTCC=clang defconfig
  HOSTCC  scripts/basic/fixdep
  HOSTCC  scripts/kconfig/conf.o
  SHIPPED scripts/kconfig/zconf.tab.c
  SHIPPED scripts/kconfig/zconf.lex.c
  SHIPPED scripts/kconfig/zconf.hash.c
  HOSTCC  scripts/kconfig/zconf.tab.o
  HOSTLD  scripts/kconfig/conf
*** Default configuration is based on 'x86_64_defconfig'
#
# configuration written to .config
#
$ make HOSTCC=clang CC=clang
scripts/kconfig/conf --silentoldconfig Kconfig
  SYSTBL  arch/x86/syscalls/../include/generated/asm/syscalls_32.h
  SYSHDR  arch/x86/syscalls/../include/generated/asm/unistd_32_ia32.h
  SYSHDR  arch/x86/syscalls/../include/generated/asm/unistd_64_x32.h
  SYSTBL  arch/x86/syscalls/../include/generated/asm/syscalls_64.h
  SYSHDR  arch/x86/syscalls/../include/generated/uapi/asm/unistd_32.h
  SYSHDR  arch/x86/syscalls/../include/generated/uapi/asm/unistd_64.h
  SYSHDR  arch/x86/syscalls/../include/generated/uapi/asm/unistd_x32.h
  HOSTCC  arch/x86/tools/relocs_32.o
  HOSTCC  arch/x86/tools/relocs_64.o
In file included from arch/x86/tools/relocs_64.c:17:
arch/x86/tools/relocs.c:969:6: warning: variable 'do_reloc' is used uninitialized whenever 'if' condition is false
      [-Wsometimes-uninitialized]
        if (!use_real_mode)
            ^~~~~~~~~~~~~~
arch/x86/tools/relocs.c:981:14: note: uninitialized use occurs here
        walk_relocs(do_reloc);
                    ^~~~~~~~
arch/x86/tools/relocs.c:969:2: note: remove the 'if' if its condition is always true
        if (!use_real_mode)
        ^~~~~~~~~~~~~~~~~~~
arch/x86/tools/relocs.c:966:24: note: initialize the variable 'do_reloc' to silence this warning
                        const char *symname);
                                            ^
                                             = NULL
1 warning generated.
  HOSTCC  arch/x86/tools/relocs_common.o
  HOSTLD  arch/x86/tools/relocs
  CHK     include/config/kernel.release
  UPD     include/config/kernel.release
  WRAP    arch/x86/include/generated/asm/clkdev.h
  WRAP    arch/x86/include/generated/asm/cputime.h
  WRAP    arch/x86/include/generated/asm/early_ioremap.h
  WRAP    arch/x86/include/generated/asm/mcs_spinlock.h
  WRAP    arch/x86/include/generated/asm/scatterlist.h
  CHK     include/generated/uapi/linux/version.h
  UPD     include/generated/uapi/linux/version.h
  CHK     include/generated/utsrelease.h
  UPD     include/generated/utsrelease.h
  CC      kernel/bounds.s
clang: warning: argument '-fcatch-undefined-behavior' is deprecated, use '-fsanitize=undefined-trap -fsanitize-undefined-trap-on-error' instead
kernel/bounds.c:18:2: error: unexpected token at start of statement
        DEFINE(NR_PAGEFLAGS, __NR_PAGEFLAGS);
        ^
include/linux/kbuild.h:5:25: note: expanded from macro 'DEFINE'
        asm volatile("\n->" #sym " %0 " #val : : "i" (val))
                        ^
<inline asm>:2:1: note: instantiated into assembly here
->NR_PAGEFLAGS $23 __NR_PAGEFLAGS
^
kernel/bounds.c:19:2: error: unexpected token at start of statement
        DEFINE(MAX_NR_ZONES, __MAX_NR_ZONES);
        ^
include/linux/kbuild.h:5:25: note: expanded from macro 'DEFINE'
        asm volatile("\n->" #sym " %0 " #val : : "i" (val))
                        ^
<inline asm>:2:1: note: instantiated into assembly here
->MAX_NR_ZONES $4 __MAX_NR_ZONES
^
kernel/bounds.c:21:2: error: unexpected token at start of statement
        DEFINE(NR_CPUS_BITS, ilog2(CONFIG_NR_CPUS));
        ^
include/linux/kbuild.h:5:25: note: expanded from macro 'DEFINE'
        asm volatile("\n->" #sym " %0 " #val : : "i" (val))
                        ^
<inline asm>:2:1: note: instantiated into assembly here
->NR_CPUS_BITS $6 ilog2(CONFIG_NR_CPUS)
^
kernel/bounds.c:23:2: error: unexpected token at start of statement
        DEFINE(SPINLOCK_SIZE, sizeof(spinlock_t));
        ^
include/linux/kbuild.h:5:25: note: expanded from macro 'DEFINE'
        asm volatile("\n->" #sym " %0 " #val : : "i" (val))
                        ^
<inline asm>:2:1: note: instantiated into assembly here
->SPINLOCK_SIZE $2 sizeof(spinlock_t)
^
4 errors generated.
make[1]: *** [kernel/bounds.s] Error 1
make: *** [prepare0] Error 2




Is "DEFINE()" macro working?


Do we need a patch like follows?
http://patchwork.ozlabs.org/patch/375026/


Best Regards
Masahiro Yamada

