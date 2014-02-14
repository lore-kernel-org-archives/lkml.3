Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752653AbaBNBAA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 20:00:00 -0500
Received: from perceval.ideasonboard.com ([95.142.166.194]:37462 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751917AbaBNA7L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 19:59:11 -0500
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-sh@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 10/27] clocksource: sh_cmt: Replace hardcoded register values with macros
Date: Fri, 14 Feb 2014 01:59:48 +0100
Message-Id: <1392339605-20691-11-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1392339605-20691-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
References: <1392339605-20691-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Define symbolic macros for all used registers bits.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---
 drivers/clocksource/sh_cmt.c | 56 ++++++++++++++++++++++++++++++++++----------
 1 file changed, 44 insertions(+), 12 deletions(-)

diff --git a/drivers/clocksource/sh_cmt.c b/drivers/clocksource/sh_cmt.c
index 3946c14..5280231 100644
--- a/drivers/clocksource/sh_cmt.c
+++ b/drivers/clocksource/sh_cmt.c
@@ -115,6 +115,34 @@ struct sh_cmt_device {
 	unsigned int num_channels;
 };
 
+#define SH_CMT16_CMCSR_CMF		(1 << 7)
+#define SH_CMT16_CMCSR_CMIE		(1 << 6)
+#define SH_CMT16_CMCSR_CKS8		(0 << 0)
+#define SH_CMT16_CMCSR_CKS32		(1 << 0)
+#define SH_CMT16_CMCSR_CKS128		(2 << 0)
+#define SH_CMT16_CMCSR_CKS512		(3 << 0)
+#define SH_CMT16_CMCSR_CKS_MASK		(3 << 0)
+
+#define SH_CMT32_CMCSR_CMF		(1 << 15)
+#define SH_CMT32_CMCSR_OVF		(1 << 14)
+#define SH_CMT32_CMCSR_WRFLG		(1 << 13)
+#define SH_CMT32_CMCSR_STTF		(1 << 12)
+#define SH_CMT32_CMCSR_STPF		(1 << 11)
+#define SH_CMT32_CMCSR_SSIE		(1 << 10)
+#define SH_CMT32_CMCSR_CMS		(1 << 9)
+#define SH_CMT32_CMCSR_CMM		(1 << 8)
+#define SH_CMT32_CMCSR_CMTOUT_IE	(1 << 7)
+#define SH_CMT32_CMCSR_CMR_NONE		(0 << 4)
+#define SH_CMT32_CMCSR_CMR_DMA		(1 << 4)
+#define SH_CMT32_CMCSR_CMR_IRQ		(2 << 4)
+#define SH_CMT32_CMCSR_CMR_MASK		(3 << 4)
+#define SH_CMT32_CMCSR_DBGIVD		(1 << 3)
+#define SH_CMT32_CMCSR_CKS_RCLK8	(4 << 0)
+#define SH_CMT32_CMCSR_CKS_RCLK32	(5 << 0)
+#define SH_CMT32_CMCSR_CKS_RCLK128	(6 << 0)
+#define SH_CMT32_CMCSR_CKS_RCLK1	(7 << 0)
+#define SH_CMT32_CMCSR_CKS_MASK		(7 << 0)
+
 static unsigned long sh_cmt_read16(void __iomem *base, unsigned long offs)
 {
 	return ioread16(base + (offs << 1));
@@ -141,8 +169,8 @@ static const struct sh_cmt_info sh_cmt_info[] = {
 	[SH_CMT_16BIT] = {
 		.model = SH_CMT_16BIT,
 		.width = 16,
-		.overflow_bit = 0x80,
-		.clear_bits = ~0x80,
+		.overflow_bit = SH_CMT16_CMCSR_CMF,
+		.clear_bits = ~SH_CMT16_CMCSR_CMF,
 		.read_control = sh_cmt_read16,
 		.write_control = sh_cmt_write16,
 		.read_count = sh_cmt_read16,
@@ -151,8 +179,8 @@ static const struct sh_cmt_info sh_cmt_info[] = {
 	[SH_CMT_32BIT] = {
 		.model = SH_CMT_32BIT,
 		.width = 32,
-		.overflow_bit = 0x8000,
-		.clear_bits = ~0xc000,
+		.overflow_bit = SH_CMT32_CMCSR_CMF,
+		.clear_bits = ~(SH_CMT32_CMCSR_CMF | SH_CMT32_CMCSR_OVF),
 		.read_control = sh_cmt_read16,
 		.write_control = sh_cmt_write16,
 		.read_count = sh_cmt_read32,
@@ -161,8 +189,8 @@ static const struct sh_cmt_info sh_cmt_info[] = {
 	[SH_CMT_32BIT_FAST] = {
 		.model = SH_CMT_32BIT_FAST,
 		.width = 32,
-		.overflow_bit = 0x8000,
-		.clear_bits = ~0xc000,
+		.overflow_bit = SH_CMT32_CMCSR_CMF,
+		.clear_bits = ~(SH_CMT32_CMCSR_CMF | SH_CMT32_CMCSR_OVF),
 		.read_control = sh_cmt_read16,
 		.write_control = sh_cmt_write16,
 		.read_count = sh_cmt_read32,
@@ -171,8 +199,8 @@ static const struct sh_cmt_info sh_cmt_info[] = {
 	[SH_CMT_48BIT] = {
 		.model = SH_CMT_48BIT,
 		.width = 32,
-		.overflow_bit = 0x8000,
-		.clear_bits = ~0xc000,
+		.overflow_bit = SH_CMT32_CMCSR_CMF,
+		.clear_bits = ~(SH_CMT32_CMCSR_CMF | SH_CMT32_CMCSR_OVF),
 		.read_control = sh_cmt_read32,
 		.write_control = sh_cmt_write32,
 		.read_count = sh_cmt_read32,
@@ -181,8 +209,8 @@ static const struct sh_cmt_info sh_cmt_info[] = {
 	[SH_CMT_48BIT_GEN2] = {
 		.model = SH_CMT_48BIT_GEN2,
 		.width = 32,
-		.overflow_bit = 0x8000,
-		.clear_bits = ~0xc000,
+		.overflow_bit = SH_CMT32_CMCSR_CMF,
+		.clear_bits = ~(SH_CMT32_CMCSR_CMF | SH_CMT32_CMCSR_OVF),
 		.read_control = sh_cmt_read32,
 		.write_control = sh_cmt_write32,
 		.read_count = sh_cmt_read32,
@@ -296,10 +324,14 @@ static int sh_cmt_enable(struct sh_cmt_channel *ch, unsigned long *rate)
 	/* configure channel, periodic mode and maximum timeout */
 	if (ch->cmt->info->width == 16) {
 		*rate = clk_get_rate(ch->cmt->clk) / 512;
-		sh_cmt_write_cmcsr(ch, 0x43);
+		sh_cmt_write_cmcsr(ch, SH_CMT16_CMCSR_CMIE |
+				   SH_CMT16_CMCSR_CKS512);
 	} else {
 		*rate = clk_get_rate(ch->cmt->clk) / 8;
-		sh_cmt_write_cmcsr(ch, 0x01a4);
+		sh_cmt_write_cmcsr(ch, SH_CMT32_CMCSR_CMM |
+				   SH_CMT32_CMCSR_CMTOUT_IE |
+				   SH_CMT32_CMCSR_CMR_IRQ |
+				   SH_CMT32_CMCSR_CKS_RCLK8);
 	}
 
 	sh_cmt_write_cmcor(ch, 0xffffffff);
-- 
1.8.3.2

