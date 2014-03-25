Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755965AbaCYRmV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2014 13:42:21 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:55862 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754963AbaCYRV0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2014 13:21:26 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Chen Gang <gang.chen.5i5j@gmail.com>, Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 32/81] avr32: Makefile: add '-D__linux__' flag for gcc-4.4.7 use
Date: Tue, 25 Mar 2014 10:15:45 -0700
Message-Id: <1395767794-5012-33-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1395767794-5012-1-git-send-email-kamal@canonical.com>
References: <1395767794-5012-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.20 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chen Gang <gang.chen.5i5j@gmail.com>

commit 8d80390cfc9434d5aa4fb9e5f9768a66b30cb8a6 upstream.

For avr32 cross compiler, do not define '__linux__' internally, so it
will cause issue with allmodconfig.

The related error:

    CC [M]  fs/coda/psdev.o
  In file included from include/linux/coda.h:64,
                   from fs/coda/psdev.c:45:
  include/uapi/linux/coda.h:221: error: expected specifier-qualifier-list before 'u_quad_t'

The related toolchain version (which only download, not re-compile):

  [root@gchen linux-next]# /upstream/toolchain/download/avr32-gnu-toolchain-linux_x86/bin/avr32-gcc -v
  Using built-in specs.
  Target: avr32
  Configured with: /data2/home/toolsbuild/jenkins-knuth/workspace/avr32-gnu-toolchain/src/gcc/configure --target=avr32 --host=i686-pc-linux-gnu --build=x86_64-pc-linux-gnu --prefix=/home/toolsbuild/jenkins-knuth/workspace/avr32-gnu-toolchain/avr32-gnu-toolchain-linux_x86 --enable-languages=c,c++ --disable-nls --disable-libssp --disable-libstdcxx-pch --with-dwarf2 --enable-version-specific-runtime-libs --disable-shared --enable-doc --with-mpfr-lib=/home/toolsbuild/jenkins-knuth/workspace/avr32-gnu-toolchain/avr32-gnu-toolchain-linux_x86/lib --with-mpfr-include=/home/toolsbuild/jenkins-knuth/workspace/avr32-gnu-toolchain/avr32-gnu-toolchain-linux_x86/include --with-gmp=/home/toolsbuild/jenkins-knuth/workspace/avr32-gnu-toolchain/avr32-gnu-toolchain-linux_x86 --with-mpc=/home/toolsbuild/jenkins-knuth/workspace/avr32-gnu-toolchain/avr32-gnu-toolchain-linux_x86 --enable-__cxa_atexit --disable-shared --with-newlib --with-pkgversion=AVR_32_bit_GNU_Toolchain_3.4.2_435 --with-bugurl=http://www
.atmel.com/avr
  Thread model: single
  gcc version 4.4.7 (AVR_32_bit_GNU_Toolchain_3.4.2_435)

Signed-off-by: Chen Gang <gang.chen.5i5j@gmail.com>
Acked-by: Hans-Christian Egtvedt <hegtvedt@cisco.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 arch/avr32/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/avr32/Makefile b/arch/avr32/Makefile
index 22fb665..dba48a5 100644
--- a/arch/avr32/Makefile
+++ b/arch/avr32/Makefile
@@ -11,7 +11,7 @@ all: uImage vmlinux.elf
 
 KBUILD_DEFCONFIG	:= atstk1002_defconfig
 
-KBUILD_CFLAGS	+= -pipe -fno-builtin -mno-pic
+KBUILD_CFLAGS	+= -pipe -fno-builtin -mno-pic -D__linux__
 KBUILD_AFLAGS	+= -mrelax -mno-pic
 KBUILD_CFLAGS_MODULE += -mno-relax
 LDFLAGS_vmlinux	+= --relax
-- 
1.8.3.2

