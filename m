Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751472AbaEXHFg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 May 2014 03:05:36 -0400
Received: from mail-ig0-f176.google.com ([209.85.213.176]:41880 "EHLO
	mail-ig0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751382AbaEXHCY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 May 2014 03:02:24 -0400
From: Andrew Pinski <apinski@cavium.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: Andrew Pinski <apinski@cavium.com>
Subject: [PATCH 15/24] ARM64:ILP32: Use the non compat HWCAP for ILP32.
Date: Sat, 24 May 2014 00:02:10 -0700
Message-Id: <1400914939-9708-16-git-send-email-apinski@cavium.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1400914939-9708-1-git-send-email-apinski@cavium.com>
References: <1400914939-9708-1-git-send-email-apinski@cavium.com>
To: linux-arm-kernel@lists.infradead.org
To: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Andrew Pinski <apinski@cavium.com>
---
 arch/arm64/include/asm/hwcap.h |   12 ++++++++++--
 1 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/include/asm/hwcap.h b/arch/arm64/include/asm/hwcap.h
index 024c461..cb87f91 100644
--- a/arch/arm64/include/asm/hwcap.h
+++ b/arch/arm64/include/asm/hwcap.h
@@ -46,9 +46,17 @@
 #define ELF_HWCAP		(elf_hwcap)
 
 #ifdef CONFIG_COMPAT
-#define COMPAT_ELF_HWCAP	(compat_elf_hwcap)
-#define COMPAT_ELF_HWCAP2	(compat_elf_hwcap2)
 extern unsigned int compat_elf_hwcap, compat_elf_hwcap2;
+#define COMPAT_ELF_HWCAP	\
+	(is_a32_compat_task()	\
+	  ? compat_elf_hwcap	\
+	  : elf_hwcap)
+
+#define COMPAT_ELF_HWCAP2	\
+	(is_a32_compat_task()	\
+	  ? compat_elf_hwcap2	\
+	  : 0)
+
 #endif
 
 extern unsigned long elf_hwcap;
-- 
1.7.2.5

