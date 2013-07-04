Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756970Ab3GDVHO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jul 2013 17:07:14 -0400
Received: from mail-pd0-f180.google.com ([209.85.192.180]:37482 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752932Ab3GDVHM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jul 2013 17:07:12 -0400
From: Ramkumar Ramachandra <artagnon@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Richard Weinberger <richard@nod.at>,
        Jeff Dike <jdike@addtoit.com>
Subject: [PATCH 1/3] arch/um/Makefile: remove dead code
Date: Fri,  5 Jul 2013 02:33:15 +0530
Message-Id: <1372971797-23518-2-git-send-email-artagnon@gmail.com>
X-Mailer: git-send-email 1.8.3.1.643.gebeea52.dirty
In-Reply-To: <1372971797-23518-1-git-send-email-artagnon@gmail.com>
References: <1372971797-23518-1-git-send-email-artagnon@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

arch/um/Makefile is included in the toplevel Makefile:495.  Well before
that, it unconditionally sets $SUBARCH (in Makefile:168) as follows:

  SUBARCH := $(shell uname -m | sed -e s/i.86/x86/ -e s/x86_64/x86/ \
				    -e s/sun4u/sparc64/ \
				    -e s/arm.*/arm/ -e s/sa110/arm/ \
				    -e s/s390x/s390/ -e s/parisc64/parisc/ \
				    -e s/ppc.*/powerpc/ -e s/mips.*/mips/ \
				    -e s/sh[234].*/sh/ -e s/aarch64.*/arm64/ )

It is clearly impossible for $SUBARCH to be set as i386 or x86_64.
Therefore, any code that checks $SUBARCH against these values is dead
code.

Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Richard Weinberger <richard@nod.at>
Cc: Jeff Dike <jdike@addtoit.com>
Signed-off-by: Ramkumar Ramachandra <artagnon@gmail.com>
---
 arch/um/Makefile | 9 ---------
 1 file changed, 9 deletions(-)

diff --git a/arch/um/Makefile b/arch/um/Makefile
index 133f7de..cf09cbf 100644
--- a/arch/um/Makefile
+++ b/arch/um/Makefile
@@ -22,15 +22,6 @@ MODE_INCLUDE	+= -I$(srctree)/$(ARCH_DIR)/include/shared/skas
 
 HEADER_ARCH 	:= $(SUBARCH)
 
-# Additional ARCH settings for x86
-ifeq ($(SUBARCH),i386)
-        HEADER_ARCH := x86
-endif
-ifeq ($(SUBARCH),x86_64)
-        HEADER_ARCH := x86
-	KBUILD_CFLAGS += -mcmodel=large
-endif
-
 HOST_DIR := arch/$(HEADER_ARCH)
 
 include $(srctree)/$(ARCH_DIR)/Makefile-skas
-- 
1.8.3.1.643.gebeea52.dirty

