Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161949Ab3BONAF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 08:00:05 -0500
Received: from mail-wi0-f179.google.com ([209.85.212.179]:56651 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161706Ab3BOM6Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 07:58:24 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        sameo@linux.intel.com
Cc: arnd@arndb.de, linus.walleij@stericsson.com,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 31/35] mfd: ab8500-debug: Add register map for ab8540.
Date: Fri, 15 Feb 2013 12:57:02 +0000
Message-Id: <1360933026-30325-32-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1360933026-30325-1-git-send-email-lee.jones@linaro.org>
References: <1360933026-30325-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Required to read out correct debug information from the AB chip.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/mfd/ab8500-debugfs.c      |  422 ++++++++++++++++++++++++++++++++++++-
 include/linux/mfd/abx500/ab8500.h |    1 +
 2 files changed, 420 insertions(+), 3 deletions(-)

diff --git a/drivers/mfd/ab8500-debugfs.c b/drivers/mfd/ab8500-debugfs.c
index 148cbd2..b5af8be 100644
--- a/drivers/mfd/ab8500-debugfs.c
+++ b/drivers/mfd/ab8500-debugfs.c
@@ -845,6 +845,422 @@ struct ab8500_prcmu_ranges ab8505_debug_ranges[AB8500_NUM_BANKS] = {
 	},
 };
 
+struct ab8500_prcmu_ranges ab8540_debug_ranges[AB8500_NUM_BANKS] = {
+	[AB8500_M_FSM_RANK] = {
+		.num_ranges = 1,
+		.range = (struct ab8500_reg_range[]) {
+			{
+				.first = 0x00,
+				.last = 0x0B,
+			},
+		},
+	},
+	[AB8500_SYS_CTRL1_BLOCK] = {
+		.num_ranges = 6,
+		.range = (struct ab8500_reg_range[]) {
+			{
+				.first = 0x00,
+				.last = 0x04,
+			},
+			{
+				.first = 0x42,
+				.last = 0x42,
+			},
+			{
+				.first = 0x50,
+				.last = 0x54,
+			},
+			{
+				.first = 0x57,
+				.last = 0x57,
+			},
+			{
+				.first = 0x80,
+				.last = 0x83,
+			},
+			{
+				.first = 0x90,
+				.last = 0x90,
+			},
+		},
+	},
+	[AB8500_SYS_CTRL2_BLOCK] = {
+		.num_ranges = 5,
+		.range = (struct ab8500_reg_range[]) {
+			{
+				.first = 0x00,
+				.last = 0x0D,
+			},
+			{
+				.first = 0x0F,
+				.last = 0x10,
+			},
+			{
+				.first = 0x20,
+				.last = 0x21,
+			},
+			{
+				.first = 0x32,
+				.last = 0x3C,
+			},
+			{
+				.first = 0x40,
+				.last = 0x42,
+			},
+		},
+	},
+	[AB8500_REGU_CTRL1] = {
+		.num_ranges = 4,
+		.range = (struct ab8500_reg_range[]) {
+			{
+				.first = 0x03,
+				.last = 0x15,
+			},
+			{
+				.first = 0x20,
+				.last = 0x20,
+			},
+			{
+				.first = 0x80,
+				.last = 0x85,
+			},
+			{
+				.first = 0x87,
+				.last = 0x88,
+			},
+		},
+	},
+	[AB8500_REGU_CTRL2] = {
+		.num_ranges = 8,
+		.range = (struct ab8500_reg_range[]) {
+			{
+				.first = 0x00,
+				.last = 0x06,
+			},
+			{
+				.first = 0x08,
+				.last = 0x15,
+			},
+			{
+				.first = 0x17,
+				.last = 0x19,
+			},
+			{
+				.first = 0x1B,
+				.last = 0x1D,
+			},
+			{
+				.first = 0x1F,
+				.last = 0x2F,
+			},
+			{
+				.first = 0x31,
+				.last = 0x3A,
+			},
+			{
+				.first = 0x43,
+				.last = 0x44,
+			},
+			{
+				.first = 0x48,
+				.last = 0x49,
+			},
+		},
+	},
+	[AB8500_USB] = {
+		.num_ranges = 3,
+		.range = (struct ab8500_reg_range[]) {
+			{
+				.first = 0x80,
+				.last = 0x83,
+			},
+			{
+				.first = 0x87,
+				.last = 0x8A,
+			},
+			{
+				.first = 0x91,
+				.last = 0x94,
+			},
+		},
+	},
+	[AB8500_TVOUT] = {
+		.num_ranges = 0,
+		.range = NULL
+	},
+	[AB8500_DBI] = {
+		.num_ranges = 4,
+		.range = (struct ab8500_reg_range[]) {
+			{
+				.first = 0x00,
+				.last = 0x07,
+			},
+			{
+				.first = 0x10,
+				.last = 0x11,
+			},
+			{
+				.first = 0x20,
+				.last = 0x21,
+			},
+			{
+				.first = 0x30,
+				.last = 0x43,
+			},
+		},
+	},
+	[AB8500_ECI_AV_ACC] = {
+		.num_ranges = 2,
+		.range = (struct ab8500_reg_range[]) {
+			{
+				.first = 0x00,
+				.last = 0x03,
+			},
+			{
+				.first = 0x80,
+				.last = 0x82,
+			},
+		},
+	},
+	[AB8500_RESERVED] = {
+		.num_ranges = 0,
+		.range = NULL,
+	},
+	[AB8500_GPADC] = {
+		.num_ranges = 4,
+		.range = (struct ab8500_reg_range[]) {
+			{
+				.first = 0x00,
+				.last = 0x01,
+			},
+			{
+				.first = 0x04,
+				.last = 0x06,
+			},
+			{
+				.first = 0x09,
+				.last = 0x0A,
+			},
+			{
+				.first = 0x10,
+				.last = 0x14,
+			},
+		},
+	},
+	[AB8500_CHARGER] = {
+		.num_ranges = 10,
+		.range = (struct ab8500_reg_range[]) {
+			{
+				.first = 0x00,
+				.last = 0x00,
+			},
+			{
+				.first = 0x02,
+				.last = 0x05,
+			},
+			{
+				.first = 0x40,
+				.last = 0x44,
+			},
+			{
+				.first = 0x50,
+				.last = 0x57,
+			},
+			{
+				.first = 0x60,
+				.last = 0x60,
+			},
+			{
+				.first = 0x70,
+				.last = 0x70,
+			},
+			{
+				.first = 0xA0,
+				.last = 0xA9,
+			},
+			{
+				.first = 0xAF,
+				.last = 0xB2,
+			},
+			{
+				.first = 0xC0,
+				.last = 0xC6,
+			},
+			{
+				.first = 0xF5,
+				.last = 0xF5,
+			},
+		},
+	},
+	[AB8500_GAS_GAUGE] = {
+		.num_ranges = 3,
+		.range = (struct ab8500_reg_range[]) {
+			{
+				.first = 0x00,
+				.last = 0x00,
+			},
+			{
+				.first = 0x07,
+				.last = 0x0A,
+			},
+			{
+				.first = 0x10,
+				.last = 0x14,
+			},
+		},
+	},
+	[AB8500_AUDIO] = {
+		.num_ranges = 1,
+		.range = (struct ab8500_reg_range[]) {
+			{
+				.first = 0x00,
+				.last = 0x9f,
+			},
+		},
+	},
+	[AB8500_INTERRUPT] = {
+		.num_ranges = 6,
+		.range = (struct ab8500_reg_range[]) {
+			{
+				.first = 0x00,
+				.last = 0x05,
+			},
+			{
+				.first = 0x0B,
+				.last = 0x0D,
+			},
+			{
+				.first = 0x12,
+				.last = 0x20,
+			},
+			/* Latch registers should not be read here */
+			{
+				.first = 0x40,
+				.last = 0x45,
+			},
+			{
+				.first = 0x4B,
+				.last = 0x4D,
+			},
+			{
+				.first = 0x52,
+				.last = 0x60,
+			},
+			/* LatchHier registers should not be read here */
+		},
+	},
+	[AB8500_RTC] = {
+		.num_ranges = 3,
+		.range = (struct ab8500_reg_range[]) {
+			{
+				.first = 0x00,
+				.last = 0x07,
+			},
+			{
+				.first = 0x0B,
+				.last = 0x18,
+			},
+			{
+				.first = 0x20,
+				.last = 0x25,
+			},
+		},
+	},
+	[AB8500_MISC] = {
+		.num_ranges = 9,
+		.range = (struct ab8500_reg_range[]) {
+			{
+				.first = 0x00,
+				.last = 0x06,
+			},
+			{
+				.first = 0x10,
+				.last = 0x16,
+			},
+			{
+				.first = 0x20,
+				.last = 0x26,
+			},
+			{
+				.first = 0x30,
+				.last = 0x36,
+			},
+			{
+				.first = 0x40,
+				.last = 0x49,
+			},
+			{
+				.first = 0x50,
+				.last = 0x50,
+			},
+			{
+				.first = 0x60,
+				.last = 0x6B,
+			},
+			{
+				.first = 0x70,
+				.last = 0x74,
+			},
+			{
+				.first = 0x80,
+				.last = 0x82,
+			},
+		},
+	},
+	[AB8500_DEVELOPMENT] = {
+		.num_ranges = 3,
+		.range = (struct ab8500_reg_range[]) {
+			{
+				.first = 0x00,
+				.last = 0x01,
+			},
+			{
+				.first = 0x06,
+				.last = 0x06,
+			},
+			{
+				.first = 0x10,
+				.last = 0x21,
+			},
+		},
+	},
+	[AB8500_DEBUG] = {
+		.num_ranges = 3,
+		.range = (struct ab8500_reg_range[]) {
+			{
+				.first = 0x01,
+				.last = 0x0C,
+			},
+			{
+				.first = 0x0E,
+				.last = 0x11,
+			},
+			{
+				.first = 0x80,
+				.last = 0x81,
+			},
+		},
+	},
+	[AB8500_PROD_TEST] = {
+		.num_ranges = 0,
+		.range = NULL,
+	},
+	[AB8500_STE_TEST] = {
+		.num_ranges = 0,
+		.range = NULL,
+	},
+	[AB8500_OTP_EMUL] = {
+		.num_ranges = 1,
+		.range = (struct ab8500_reg_range[]) {
+			{
+				.first = 0x00,
+				.last = 0x3F,
+			},
+		},
+	},
+};
+
+
 static irqreturn_t ab8500_debug_handler(int irq, void *data)
 {
 	char buf[16];
@@ -936,7 +1352,7 @@ static int ab8500_print_all_banks(struct seq_file *s, void *p)
 
 	seq_printf(s, AB8500_NAME_STRING " register values:\n");
 
-	for (i = 1; i < AB8500_NUM_BANKS; i++) {
+	for (i = 0; i < AB8500_NUM_BANKS; i++) {
 		err = seq_printf(s, " bank 0x%02X:\n", i);
 
 		ab8500_registers_print(dev, i, s);
@@ -978,7 +1394,7 @@ void ab8500_dump_all_banks_to_mem(void)
 	pr_info("Saving all ABB registers at \"ab8500_complete_register_dump\" "
 		"for crash analyze.\n");
 
-	for (bank = 1; bank < AB8500_NUM_BANKS; bank++) {
+	for (bank = 0; bank < AB8500_NUM_BANKS; bank++) {
 		for (i = 0; i < debug_ranges[bank].num_ranges; i++) {
 			u8 reg;
 
@@ -2652,7 +3068,7 @@ static int ab8500_debug_probe(struct platform_device *plf)
 		debug_ranges = ab8505_debug_ranges;
 		num_interrupt_lines = AB9540_NR_IRQS;
 	} else if (is_ab8540(ab8500)) {
-		debug_ranges = ab8505_debug_ranges;
+		debug_ranges = ab8540_debug_ranges;
 		num_interrupt_lines = AB8540_NR_IRQS;
 	}
 
diff --git a/include/linux/mfd/abx500/ab8500.h b/include/linux/mfd/abx500/ab8500.h
index 46418f3..2b7ac84 100644
--- a/include/linux/mfd/abx500/ab8500.h
+++ b/include/linux/mfd/abx500/ab8500.h
@@ -40,6 +40,7 @@ enum ab8500_version {
 /*
  * AB8500 bank addresses
  */
+#define AB8500_M_FSM_RANK	0x0
 #define AB8500_SYS_CTRL1_BLOCK	0x1
 #define AB8500_SYS_CTRL2_BLOCK	0x2
 #define AB8500_REGU_CTRL1	0x3
-- 
1.7.10.4

