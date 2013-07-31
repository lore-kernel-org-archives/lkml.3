Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759387Ab3GaJGK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 05:06:10 -0400
Received: from intranet.asianux.com ([58.214.24.6]:17756 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759209Ab3GaJGG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 05:06:06 -0400
X-Spam-Score: -100.8
Message-ID: <51F8D33A.3050406@asianux.com>
Date: Wed, 31 Jul 2013 17:04:58 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Daniel Lezcano <daniel.lezcano@linaro.org>
CC: Paul Mundt <lethal@linux-sh.org>, rafael.j.wysocki@intel.com,
        horms+renesas@verge.net.au, khilman@linaro.org,
        Linux-sh list <linux-sh@vger.kernel.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] scripts/recordmcount.pl: remove "-m32" for sh architecture
References: <51F8BB73.2070603@asianux.com> <51F8BE59.4030506@linaro.org> <51F8CCC0.1090302@asianux.com>
In-Reply-To: <51F8CCC0.1090302@asianux.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

'allmodconfig' will report error for "-m32", Now "-m32" is useless for
latest compiler and neither can find "-m32" in "arch/sh" directory, so
just remove it is OK.

The related error:

    CC      init/main.o
  sh3-gchen-linux-gnu-gcc: error: unrecognized command line option '-m32'
  sh3-gchen-linux-gnu-ld: cannot find init/.tmp_mc_main.o: No such file or directory
  sh3-gchen-linux-gnu-objcopy: 'init/.tmp_mx_main.o': No such file
  rm: cannot remove `init/.tmp_mx_main.o': No such file or directory
  rm: cannot remove `init/.tmp_mc_main.o': No such file or directory
    CHK     include/generated/compile.h
    CC      init/version.o
    CC      init/do_mounts.o
  sh3-gchen-linux-gnu-gcc: error: unrecognized command line option '-m32'
  sh3-gchen-linux-gnu-ld: cannot find init/.tmp_mc_do_mounts.o: No such file or directory
  mv: cannot stat `init/.tmp_mx_do_mounts.o': No such file or directory
  rm: cannot remove `init/.tmp_mc_do_mounts.o': No such file or directory
    CC      init/do_mounts_initrd.o
    LD      init/mounts.o
    CC      init/initramfs.o
    CC      init/init_task.o
    LD      init/built-in.o
  sh3-gchen-linux-gnu-ld: cannot find init/main.o: No such file or directory
  make[1]: *** [init/built-in.o] Error 1
  make: *** [init] Error 2

The related compiler information:

  [root@dhcp122 linux-next]# sh3-gchen-linux-gnu-gcc -v
  Using built-in specs.
  COLLECT_GCC=sh3-gchen-linux-gnu-gcc
  COLLECT_LTO_WRAPPER=/home/gchen/x-tools/sh3-gchen-linux-gnu/bin/../libexec/gcc/sh3-gchen-linux-gnu/4.8.0/lto-wrapper
  Target: sh3-gchen-linux-gnu
  Configured with: /root/src/toolchain_sh/crosstool-ng-2685dfa9de14/.build/src/gcc-4.8.0/configure --build=x86_64-build_unknown-linux-gnu --host=x86_64-build_unknown-linux-gnu --target=sh3-gchen-linux-gnu --prefix=/root/src/toolchain_sh/crosstool-ng-2685dfa9de14/.build/sh3-gchen-linux-gnu/buildtools --with-local-prefix=/home/gchen/x-tools/sh3-gchen-linux-gnu/sh3-gchen-linux-gnu/sysroot --disable-libmudflap --with-sysroot=/home/gchen/x-tools/sh3-gchen-linux-gnu/sh3-gchen-linux-gnu/sysroot --enable-shared --with-pkgversion='crosstool-NG hg+unknown-20130731.103227' --enable-__cxa_atexit --with-gmp=/root/src/toolchain_sh/crosstool-ng-2685dfa9de14/.build/sh3-gchen-linux-gnu/buildtools --with-mpfr=/root/src/toolchain_sh/crosstool-ng-2685dfa9de14/.build/sh3-gchen-linux-gnu/buildtools --with-mpc=/root/src/toolchain_sh/crosstool-ng-2685dfa9de14/.build/sh3-gchen-linux-gnu/buildtools --with-isl=/root/src/toolchain_sh/crosstool-ng-2685dfa9de14/.build/sh3-gchen-linux-gnu/buildtools --with
 -cloog=/r
oot/src/toolchain_sh/crosstool-ng-2685dfa9de14/.build/sh3-gchen-linux-gnu/buildtools --with-libelf=/root/src/toolchain_sh/crosstool-ng-2685dfa9de14/.build/sh3-gchen-linux-gnu/buildtools --enable-lto --enable-target-optspace --disable-libgomp --disable-libmudflap --disable-nls --disable-multilib --enable-languages=c
  Thread model: posix
  gcc version 4.8.0 (crosstool-NG hg+unknown-20130731.103227) 


Signed-off-by: Chen Gang <gang.chen@asianux.com>
---
 scripts/recordmcount.pl |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/scripts/recordmcount.pl b/scripts/recordmcount.pl
index 858966a..679218b 100755
--- a/scripts/recordmcount.pl
+++ b/scripts/recordmcount.pl
@@ -262,7 +262,6 @@ if ($arch eq "x86_64") {
     # force flags for this arch
     $ld .= " -m shlelf_linux";
     $objcopy .= " -O elf32-sh-linux";
-    $cc .= " -m32";
 
 } elsif ($arch eq "powerpc") {
     $local_regex = "^[0-9a-fA-F]+\\s+t\\s+(\\.?\\S+)";
-- 
1.7.7.6
