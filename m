Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754143AbaC3Xli (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Mar 2014 19:41:38 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:36430 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753068AbaC3XZC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Mar 2014 19:25:02 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Chen Gang" <gang.chen.5i5j@gmail.com>,
        "Hans-Christian Egtvedt" <hegtvedt@cisco.com>
Date: Mon, 31 Mar 2014 00:23:35 +0100
Message-ID: <lsq.1396221815.844830473@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 123/200] avr32: Makefile: add '-D__linux__' flag for
 gcc-4.4.7 use
In-Reply-To: <lsq.1396221814.369444335@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.56-rc1 review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/avr32/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/avr32/Makefile
+++ b/arch/avr32/Makefile
@@ -11,7 +11,7 @@ all: uImage vmlinux.elf
 
 KBUILD_DEFCONFIG	:= atstk1002_defconfig
 
-KBUILD_CFLAGS	+= -pipe -fno-builtin -mno-pic
+KBUILD_CFLAGS	+= -pipe -fno-builtin -mno-pic -D__linux__
 KBUILD_AFLAGS	+= -mrelax -mno-pic
 KBUILD_CFLAGS_MODULE += -mno-relax
 LDFLAGS_vmlinux	+= --relax

