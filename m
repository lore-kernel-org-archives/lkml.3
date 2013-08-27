Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752460Ab3H0FgV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 01:36:21 -0400
Received: from intranet.asianux.com ([58.214.24.6]:36711 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751620Ab3H0FgU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 01:36:20 -0400
X-Spam-Score: -101.0
Message-ID: <521C3A95.7020006@asianux.com>
Date: Tue, 27 Aug 2013 13:35:17 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Geert Uytterhoeven <geert@linux-m68k.org>,
        Yoshinori Sato <ysato@users.sourceforge.jp>,
        James Hogan <james.hogan@imgtec.com>,
        Rusty Russell <rusty@rustcorp.com.au>, Takashi Iwai <tiwai@suse.de>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH v2] h8300: Makefile: add "-no-warn-mismatch" to linker to
 avoid linking error.
References: <521B312B.2020806@asianux.com> <521B31F4.9090701@asianux.com> <521C0B86.3030402@asianux.com> <521C3820.9010102@asianux.com>
In-Reply-To: <521C3820.9010102@asianux.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Need add "-no-warn-mismatch" to avoid the linking error, or assembly
files which are outside of the "arch/h8300" can not pass compiling.

The related error (allmodconfig for h8300):

  /usr/local/bin/h8300-gchen-elf-ld: h8300 architecture of input file `usr/initramfs_data.o' is incompatible with h8300h output
  /usr/local/bin/h8300-gchen-elf-ld: h8300 architecture of input file `kernel/modsign_certificate.o' is incompatible with h8300h output

The cross-compiler's information:

  [root@dhcp122 linux-next]# /usr/local/bin/h8300-gchen-elf-ld -v
  GNU ld (GNU Binutils) 2.22
  [root@dhcp122 linux-next]# /usr/local/bin/h8300-gchen-elf-as -v
  GNU assembler version 2.22 (h8300-gchen-elf) using BFD version (GNU Binutils) 2.22

  [root@dhcp122 linux-next]# /usr/local/bin/h8300-gchen-elf-gcc -v
  Using built-in specs.
  COLLECT_GCC=/usr/local/bin/h8300-gchen-elf-gcc
  COLLECT_LTO_WRAPPER=/usr/local/libexec/gcc/h8300-gchen-elf/4.8.0/lto-wrapper
  Target: h8300-gchen-elf
  Configured with: ../gcc-4.8.0/configure --target=h8300-gchen-elf --without-header --disable-nls --enable-language=c --disable-threads --disable-shared --enable-werror=no
  Thread model: single
  gcc version 4.8.0 (GCC)


Signed-off-by: Chen Gang <gang.chen@asianux.com>
---
 arch/h8300/Makefile |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/h8300/Makefile b/arch/h8300/Makefile
index a556447..3ad1369 100644
--- a/arch/h8300/Makefile
+++ b/arch/h8300/Makefile
@@ -26,7 +26,7 @@ model-$(CONFIG_ROMKERNEL)	:= rom
 MODEL := $(model-y)
 
 cflags-$(CONFIG_CPU_H8300H)	:= -mh
-ldflags-$(CONFIG_CPU_H8300H)	:= -mh8300helf
+ldflags-$(CONFIG_CPU_H8300H)	:= -mh8300helf -no-warn-mismatch
 cflags-$(CONFIG_CPU_H8S)	:= -ms
 ldflags-$(CONFIG_CPU_H8S)	:= -mh8300self
 
-- 
1.7.7.6
