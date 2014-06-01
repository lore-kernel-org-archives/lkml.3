Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755711AbaFAIkU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2014 04:40:20 -0400
Received: from mail-we0-f169.google.com ([74.125.82.169]:38164 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751380AbaFAIkS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2014 04:40:18 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Richard Weinberger <richard@nod.at>
Cc: user-mode-linux-devel@lists.sourceforge.net, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH] um: Generate "generic-y" header files for $(HEADER_ARCH)
Date: Sun,  1 Jun 2014 10:40:09 +0200
Message-Id: <1401612009-9572-1-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

UM needs to perform header file generation for $(HEADER_ARCH), in addition
to the standard $(ARCH).

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
Prerequisite for "x86/uapi: Use Kbuild logic to include <asm-generic/types.h>"
https://lkml.org/lkml/2013/11/25/229

Else it fails with:

In file included from include/linux/types.h:5:0,
                 from include/linux/page-flags.h:8,
                 from kernel/bounds.c:9:
include/uapi/linux/types.h:4:23: fatal error: asm/types.h: No such file or directory

 arch/um/Makefile | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/um/Makefile b/arch/um/Makefile
index 36e658a4291c..4a6caa4bc633 100644
--- a/arch/um/Makefile
+++ b/arch/um/Makefile
@@ -113,6 +113,12 @@ KBUILD_KCONFIG := $(HOST_DIR)/um/Kconfig
 archheaders:
 	$(Q)$(MAKE) -C '$(srctree)' KBUILD_SRC= \
 		ARCH=$(HEADER_ARCH) O='$(objtree)' archheaders
+	$(Q)$(MAKE) -f $(srctree)/scripts/Makefile.asm-generic \
+		    SRCARCH=$(HEADER_ARCH) src=asm \
+		    obj=arch/$(HEADER_ARCH)/include/generated/asm
+	$(Q)$(MAKE) -f $(srctree)/scripts/Makefile.asm-generic \
+		    SRCARCH=$(HEADER_ARCH) src=uapi/asm \
+		    obj=arch/$(HEADER_ARCH)/include/generated/uapi/asm
 
 archprepare: include/generated/user_constants.h
 
-- 
1.9.1

