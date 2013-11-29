Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756523Ab3K2QRK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Nov 2013 11:17:10 -0500
Received: from b.ns.miles-group.at ([95.130.255.144]:1660 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751202Ab3K2QRG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Nov 2013 11:17:06 -0500
From: Richard Weinberger <richard@nod.at>
To: richard@nod.at
Cc: user-mode-linux-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        bharrosh@panasas.com
Subject: [PATCH] um: Build always with -mcmodel=large on 64bit
Date: Fri, 29 Nov 2013 17:16:57 +0100
Message-Id: <1385741817-27613-1-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.8.1.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On UML SUBARCH can be x86, x86_64 and i386 and if it is x86
we use uname -m to select a defconfig.
Therefore we can no longer use -mcmodel=large only if SUBARCH
is x86_64.

Reported-by: Boaz Harrosh <bharrosh@panasas.com>
Signed-off-by: Richard Weinberger <richard@nod.at>
---
 arch/um/Makefile | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/arch/um/Makefile b/arch/um/Makefile
index 48d92bb..36e658a 100644
--- a/arch/um/Makefile
+++ b/arch/um/Makefile
@@ -33,12 +33,11 @@ MODE_INCLUDE	+= -I$(srctree)/$(ARCH_DIR)/include/shared/skas
 
 HEADER_ARCH 	:= $(SUBARCH)
 
-# Additional ARCH settings for x86
-ifeq ($(SUBARCH),i386)
-        HEADER_ARCH := x86
+ifneq ($(filter $(SUBARCH),x86 x86_64 i386),)
+	HEADER_ARCH := x86
 endif
-ifeq ($(SUBARCH),x86_64)
-        HEADER_ARCH := x86
+
+ifdef CONFIG_64BIT
 	KBUILD_CFLAGS += -mcmodel=large
 endif
 
-- 
1.8.1.4

