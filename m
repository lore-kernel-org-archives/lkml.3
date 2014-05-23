Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752573AbaEWKb4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 06:31:56 -0400
Received: from mail-wg0-f49.google.com ([74.125.82.49]:48712 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752511AbaEWKbw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 06:31:52 -0400
From: Daniel Lezcano <daniel.lezcano@linaro.org>
To: tglx@linutronix.de, mingo@kernel.org
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH 12/71] clocksource: sh_cmt: Replace hardcoded register values with macros
Date: Fri, 23 May 2014 12:30:52 +0200
Message-Id: <1400841111-6683-12-git-send-email-daniel.lezcano@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1400841111-6683-1-git-send-email-daniel.lezcano@linaro.org>
References: <537F214C.8000700@linaro.org>
 <1400841111-6683-1-git-send-email-daniel.lezcano@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>

Define symbolic macros for all used registers bits.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---
 drivers/clocksource/sh_cmt.c |   56 +++++++++++++++++++++++++++++++++---------
 1 file changed, 44 insertions(+), 12 deletions(-)

diff --git a/drivers/clocksource/sh_cmt.c b/drivers/clocksource/sh_cmt.c
index 879b8c2..ce00baa 100644
--- a/drivers/clocksource/sh_cmt.c
+++ b/drivers/clocksource/sh_cmt.c
@@ -114,6 +114,34 @@ struct sh_cmt_device {
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
@@ -140,8 +168,8 @@ static const struct sh_cmt_info sh_cmt_info[] = {
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
@@ -150,8 +178,8 @@ static const struct sh_cmt_info sh_cmt_info[] = {
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
@@ -160,8 +188,8 @@ static const struct sh_cmt_info sh_cmt_info[] = {
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
@@ -170,8 +198,8 @@ static const struct sh_cmt_info sh_cmt_info[] = {
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
@@ -180,8 +208,8 @@ static const struct sh_cmt_info sh_cmt_info[] = {
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
@@ -295,10 +323,14 @@ static int sh_cmt_enable(struct sh_cmt_channel *ch, unsigned long *rate)
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
1.7.9.5

