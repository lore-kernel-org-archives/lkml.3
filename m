Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752673AbaBISur (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Feb 2014 13:50:47 -0500
Received: from mail.sigma-star.at ([95.130.255.111]:62423 "EHLO
	mail.sigma-star.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752312AbaBISsl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Feb 2014 13:48:41 -0500
From: Richard Weinberger <richard@nod.at>
To: Paul Mundt <lethal@linux-sh.org>,
        linux-sh@vger.kernel.org (open list:SUPERH),
        linux-kernel@vger.kernel.org (open list)
Cc: Richard Weinberger <richard@nod.at>
Subject: [PATCH 21/28] Remove CPU_SUBTYPE_SH7764
Date: Sun,  9 Feb 2014 19:47:59 +0100
Message-Id: <1391971686-9517-22-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.8.4.2
In-Reply-To: <1391971686-9517-1-git-send-email-richard@nod.at>
References: <1391971686-9517-1-git-send-email-richard@nod.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The symbol is an orphan, get rid of it.

Signed-off-by: Richard Weinberger <richard@nod.at>
---
 arch/sh/drivers/dma/Kconfig                | 5 ++---
 arch/sh/include/cpu-sh4/cpu/dma-register.h | 1 -
 arch/sh/include/cpu-sh4a/cpu/dma.h         | 3 +--
 3 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/arch/sh/drivers/dma/Kconfig b/arch/sh/drivers/dma/Kconfig
index cfd5b90..e07afe8 100644
--- a/arch/sh/drivers/dma/Kconfig
+++ b/arch/sh/drivers/dma/Kconfig
@@ -12,9 +12,8 @@ config SH_DMA_IRQ_MULTI
 	default y if CPU_SUBTYPE_SH7750  || CPU_SUBTYPE_SH7751  || \
 		     CPU_SUBTYPE_SH7750S || CPU_SUBTYPE_SH7750R || \
 		     CPU_SUBTYPE_SH7751R || CPU_SUBTYPE_SH7091  || \
-		     CPU_SUBTYPE_SH7763  || CPU_SUBTYPE_SH7764  || \
-		     CPU_SUBTYPE_SH7780  || CPU_SUBTYPE_SH7785  || \
-		     CPU_SUBTYPE_SH7760
+		     CPU_SUBTYPE_SH7763  || CPU_SUBTYPE_SH7780  || \
+		     CPU_SUBTYPE_SH7785  CPU_SUBTYPE_SH7760
 
 config SH_DMA_API
 	depends on SH_DMA
diff --git a/arch/sh/include/cpu-sh4/cpu/dma-register.h b/arch/sh/include/cpu-sh4/cpu/dma-register.h
index 02788b6..9cd81e5 100644
--- a/arch/sh/include/cpu-sh4/cpu/dma-register.h
+++ b/arch/sh/include/cpu-sh4/cpu/dma-register.h
@@ -32,7 +32,6 @@
 #define CHCR_TS_HIGH_SHIFT	(20 - 2)	/* 2 bits for shifted low TS */
 #elif defined(CONFIG_CPU_SUBTYPE_SH7757) || \
 	defined(CONFIG_CPU_SUBTYPE_SH7763) || \
-	defined(CONFIG_CPU_SUBTYPE_SH7764) || \
 	defined(CONFIG_CPU_SUBTYPE_SH7780) || \
 	defined(CONFIG_CPU_SUBTYPE_SH7785)
 #define CHCR_TS_LOW_MASK	0x00000018
diff --git a/arch/sh/include/cpu-sh4a/cpu/dma.h b/arch/sh/include/cpu-sh4a/cpu/dma.h
index 89afb65..8ceccce 100644
--- a/arch/sh/include/cpu-sh4a/cpu/dma.h
+++ b/arch/sh/include/cpu-sh4a/cpu/dma.h
@@ -14,8 +14,7 @@
 #define DMTE4_IRQ	evt2irq(0xb80)
 #define DMAE0_IRQ	evt2irq(0xbc0)	/* DMA Error IRQ*/
 #define SH_DMAC_BASE0	0xFE008020
-#elif defined(CONFIG_CPU_SUBTYPE_SH7763) || \
-	defined(CONFIG_CPU_SUBTYPE_SH7764)
+#elif defined(CONFIG_CPU_SUBTYPE_SH7763)
 #define DMTE0_IRQ	evt2irq(0x640)
 #define DMTE4_IRQ	evt2irq(0x780)
 #define DMAE0_IRQ	evt2irq(0x6c0)
-- 
1.8.4.2

