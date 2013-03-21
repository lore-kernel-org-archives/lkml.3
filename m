Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933838Ab3CUQcA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 12:32:00 -0400
Received: from mail-pd0-f178.google.com ([209.85.192.178]:53138 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932121Ab3CUQb4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 12:31:56 -0400
From: Jiang Liu <liuj97@gmail.com>
Cc: Jiang Liu <jiang.liu@huawei.com>,
        Yoshinori Sato <ysato@users.sourceforge.jp>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] h8300: fix CROSS_COMPILE setting in arch/h8300/Makefile
Date: Fri, 22 Mar 2013 00:31:43 +0800
Message-Id: <1363883504-6140-1-git-send-email-jiang.liu@huawei.com>
X-Mailer: git-send-email 1.7.9.5
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Makefiles for h8300 architecture unconditionally sets CROSS_COMPILE
to a default value, which breaks following cross compilation command:
ARCH=h8300 CROSS_COMPILE=/ws/tool/h8300-elf/bin/h8300-elf- make arch/h8300/mm/init.o
make: h8300-elf-gcc: Command not found
make: h8300-elf-gcc: Command not found
  CHK     include/generated/uapi/linux/version.h
  CHK     include/generated/utsrelease.h
  CC      kernel/bounds.s
/bin/sh: 1: h8300-elf-gcc: not found
make[1]: *** [kernel/bounds.s] Error 127
make: *** [prepare0] Error 2

So only set CROSS_COMPILE to the default value if it's has been set yet.

Also fix a typo in arch/h8300/Makefile to change "CROSS-COMPILE" to
"CROSS_COMPILE".

Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: linux-kernel@vger.kernel.org
---
 arch/h8300/Makefile |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/h8300/Makefile b/arch/h8300/Makefile
index a556447..93d693d 100644
--- a/arch/h8300/Makefile
+++ b/arch/h8300/Makefile
@@ -38,8 +38,10 @@ KBUILD_CFLAGS += -DUTS_SYSNAME=\"uClinux\"
 KBUILD_AFLAGS += -DPLATFORM=$(PLATFORM) -DMODEL=$(MODEL) $(cflags-y)
 LDFLAGS += $(ldflags-y)
 
-CROSS_COMPILE = h8300-elf-
-LIBGCC := $(shell $(CROSS-COMPILE)$(CC) $(KBUILD_CFLAGS) -print-libgcc-file-name)
+ifeq ($(CROSS_COMPILE),)
+	CROSS_COMPILE := h8300-elf-
+endif
+LIBGCC := $(shell $(CC) $(KBUILD_CFLAGS) -print-libgcc-file-name)
 
 head-y := arch/$(ARCH)/platform/$(PLATFORM)/$(BOARD)/crt0_$(MODEL).o
 
-- 
1.7.9.5

