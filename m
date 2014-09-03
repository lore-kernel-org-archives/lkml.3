Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756628AbaICVTb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 17:19:31 -0400
Received: from mail-ig0-f179.google.com ([209.85.213.179]:32861 "EHLO
	mail-ig0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756504AbaICVT2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 17:19:28 -0400
From: Andrew Pinski <apinski@cavium.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        pinskia@gmail.com
Cc: Andrew Pinski <apinski@cavium.com>
Subject: [PATCH 01/24] ARM64: Force LP64 to compile the kernel
Date: Wed,  3 Sep 2014 14:18:55 -0700
Message-Id: <1409779158-30963-2-git-send-email-apinski@cavium.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1409779158-30963-1-git-send-email-apinski@cavium.com>
References: <1409779158-30963-1-git-send-email-apinski@cavium.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sometimes the compiler is set to default to ILP32 ABI so we want to make sure the kernel can compile in that case.

Signed-off-by: Andrew Pinski <apinski@cavium.com>
---
 arch/arm64/Makefile |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/arch/arm64/Makefile b/arch/arm64/Makefile
index 2df5e5d..b05340b 100644
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

