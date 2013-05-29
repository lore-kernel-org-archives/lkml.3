Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935264Ab3E2VqF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 17:46:05 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:56509 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935180Ab3E2Vps (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 17:45:48 -0400
X-Greylist: delayed 488 seconds by postgrey-1.27 at vger.kernel.org; Wed, 29 May 2013 17:45:48 EDT
From: Rohit Vaswani <rvaswani@codeaurora.org>
To: David Brown <davidb@codeaurora.org>, Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>
Cc: Rohit Vaswani <rvaswani@codeaurora.org>, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] msm: iomap: Remove unused bases and mappings
Date: Wed, 29 May 2013 14:37:29 -0700
Message-Id: <1369863449-25059-2-git-send-email-rvaswani@codeaurora.org>
X-Mailer: git-send-email 1.7.8.3
In-Reply-To: <1369863449-25059-1-git-send-email-rvaswani@codeaurora.org>
References: <1369863449-25059-1-git-send-email-rvaswani@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

QGIC_DIST and QGIC_CPU bases are now unused as they are
obtained from device tree. Remove the static iomappings.

Signed-off-by: Rohit Vaswani <rvaswani@codeaurora.org>
---
 arch/arm/mach-msm/include/mach/msm_iomap-8960.h |    7 -------
 arch/arm/mach-msm/include/mach/msm_iomap-8x60.h |    6 ------
 arch/arm/mach-msm/include/mach/msm_iomap.h      |    2 --
 arch/arm/mach-msm/io.c                          |    4 ----
 4 files changed, 0 insertions(+), 19 deletions(-)

diff --git a/arch/arm/mach-msm/include/mach/msm_iomap-8960.h b/arch/arm/mach-msm/include/mach/msm_iomap-8960.h
index 9819a55..7bca8d7 100644
--- a/arch/arm/mach-msm/include/mach/msm_iomap-8960.h
+++ b/arch/arm/mach-msm/include/mach/msm_iomap-8960.h
@@ -32,13 +32,6 @@
  *
  */
 
-
-#define MSM8960_QGIC_DIST_PHYS	0x02000000
-#define MSM8960_QGIC_DIST_SIZE	SZ_4K
-
-#define MSM8960_QGIC_CPU_PHYS	0x02002000
-#define MSM8960_QGIC_CPU_SIZE	SZ_4K
-
 #define MSM8960_TMR_PHYS	0x0200A000
 #define MSM8960_TMR_SIZE	SZ_4K
 
diff --git a/arch/arm/mach-msm/include/mach/msm_iomap-8x60.h b/arch/arm/mach-msm/include/mach/msm_iomap-8x60.h
index 199372e..75a7b62 100644
--- a/arch/arm/mach-msm/include/mach/msm_iomap-8x60.h
+++ b/arch/arm/mach-msm/include/mach/msm_iomap-8x60.h
@@ -35,12 +35,6 @@
  *
  */
 
-#define MSM8X60_QGIC_DIST_PHYS	0x02080000
-#define MSM8X60_QGIC_DIST_SIZE	SZ_4K
-
-#define MSM8X60_QGIC_CPU_PHYS	0x02081000
-#define MSM8X60_QGIC_CPU_SIZE	SZ_4K
-
 #define MSM_TLMM_BASE		IOMEM(0xF0004000)
 #define MSM_TLMM_PHYS		0x00800000
 #define MSM_TLMM_SIZE		SZ_16K
diff --git a/arch/arm/mach-msm/include/mach/msm_iomap.h b/arch/arm/mach-msm/include/mach/msm_iomap.h
index 2ab7cf0..c56e81f 100644
--- a/arch/arm/mach-msm/include/mach/msm_iomap.h
+++ b/arch/arm/mach-msm/include/mach/msm_iomap.h
@@ -62,8 +62,6 @@
 
 /* Virtual addresses shared across all MSM targets. */
 #define MSM_CSR_BASE		IOMEM(0xE0001000)
-#define MSM_QGIC_DIST_BASE	IOMEM(0xF0000000)
-#define MSM_QGIC_CPU_BASE	IOMEM(0xF0001000)
 #define MSM_TMR_BASE		IOMEM(0xF0200000)
 #define MSM_TMR0_BASE		IOMEM(0xF0201000)
 #define MSM_GPIO1_BASE		IOMEM(0xE0003000)
diff --git a/arch/arm/mach-msm/io.c b/arch/arm/mach-msm/io.c
index 123ef9c..efa113e 100644
--- a/arch/arm/mach-msm/io.c
+++ b/arch/arm/mach-msm/io.c
@@ -107,8 +107,6 @@ void __init msm_map_qsd8x50_io(void)
 
 #ifdef CONFIG_ARCH_MSM8X60
 static struct map_desc msm8x60_io_desc[] __initdata = {
-	MSM_CHIP_DEVICE(QGIC_DIST, MSM8X60),
-	MSM_CHIP_DEVICE(QGIC_CPU, MSM8X60),
 	MSM_CHIP_DEVICE(TMR, MSM8X60),
 	MSM_CHIP_DEVICE(TMR0, MSM8X60),
 #ifdef CONFIG_DEBUG_MSM8660_UART
@@ -124,8 +122,6 @@ void __init msm_map_msm8x60_io(void)
 
 #ifdef CONFIG_ARCH_MSM8960
 static struct map_desc msm8960_io_desc[] __initdata = {
-	MSM_CHIP_DEVICE(QGIC_DIST, MSM8960),
-	MSM_CHIP_DEVICE(QGIC_CPU, MSM8960),
 	MSM_CHIP_DEVICE(TMR, MSM8960),
 	MSM_CHIP_DEVICE(TMR0, MSM8960),
 #ifdef CONFIG_DEBUG_MSM8960_UART
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

