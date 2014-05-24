Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751473AbaEXHC3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 May 2014 03:02:29 -0400
Received: from mail-ig0-f169.google.com ([209.85.213.169]:39712 "EHLO
	mail-ig0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751228AbaEXHCX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 May 2014 03:02:23 -0400
From: Andrew Pinski <apinski@cavium.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: Andrew Pinski <apinski@cavium.com>
Subject: [PATCH 01/24] ARM64: Force LP64 to compile the kernel.
Date: Sat, 24 May 2014 00:01:56 -0700
Message-Id: <1400914939-9708-2-git-send-email-apinski@cavium.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1400914939-9708-1-git-send-email-apinski@cavium.com>
References: <1400914939-9708-1-git-send-email-apinski@cavium.com>
To: linux-arm-kernel@lists.infradead.org
To: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sometimes the compiler is set to default to ILP32 ABI so we want to make sure the kernel can compile in that case.

Thanks,
Andrew Pinski

Signed-off-by: Andrew Pinski <apinski@cavium.com>
---
 arch/arm64/Makefile |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/arch/arm64/Makefile b/arch/arm64/Makefile
index 2fceb71..e9dbd20 100644
--- a/arch/arm64/Makefile
+++ b/arch/arm64/Makefile
@@ -20,14 +20,18 @@ LIBGCC 		:= $(shell $(CC) $(KBUILD_CFLAGS) -print-libgcc-file-name)
 KBUILD_DEFCONFIG := defconfig
 
 KBUILD_CFLAGS	+= -mgeneral-regs-only
+KBUILD_CFLAGS	+= $(call cc-option,-mabi=lp64)
+KBUILD_AFLAGS	+= $(call cc-option,-mabi=lp64)
 ifeq ($(CONFIG_CPU_BIG_ENDIAN), y)
 KBUILD_CPPFLAGS	+= -mbig-endian
 AS		+= -EB
 LD		+= -EB
+LDFLAGS		+= -maarch64linuxb
 else
 KBUILD_CPPFLAGS	+= -mlittle-endian
 AS		+= -EL
 LD		+= -EL
+LDFLAGS		+= -maarch64linux
 endif
 
 comma = ,
-- 
1.7.2.5

