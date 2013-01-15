Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757238Ab3AOM7R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 07:59:17 -0500
Received: from mail-wi0-f181.google.com ([209.85.212.181]:41590 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756859Ab3AOM4y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 07:56:54 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com, sameo@linux.intel.com,
        Philippe Langlais <philippe.langlais@stericsson.com>,
        Lee Jones <lee.jones@linaro.org>,
        <thirupathi.chippakurthy@stericsson.com>
Subject: [PATCH 16/26] mfd: ab8500-debugfs: Set the USB charging current to 300mA for ABV3
Date: Tue, 15 Jan 2013 12:55:56 +0000
Message-Id: <1358254566-12419-17-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1358254566-12419-1-git-send-email-lee.jones@linaro.org>
References: <1358254566-12419-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Philippe Langlais <philippe.langlais@stericsson.com>

In case of AB-V3, the eye diagram related issues are resolved.
So, set the device charging current to 300mA when connected to
standard host. Also, add the USB PHY tuning values to improve
the USB eye diagram

Signed-off-by: Lee Jones <lee.jones@linaro.org>
Signed-off-by: <thirupathi.chippakurthy@stericsson.com>
---
 drivers/mfd/ab8500-debugfs.c |   26 ++++++++++++++++++++++++--
 1 file changed, 24 insertions(+), 2 deletions(-)

diff --git a/drivers/mfd/ab8500-debugfs.c b/drivers/mfd/ab8500-debugfs.c
index aedbcb0..a231faf 100644
--- a/drivers/mfd/ab8500-debugfs.c
+++ b/drivers/mfd/ab8500-debugfs.c
@@ -144,7 +144,7 @@ static struct hwreg_cfg hwreg_cfg = {
 
 #define AB8500_NAME_STRING "ab8500"
 #define AB8500_ADC_NAME_STRING "gpadc"
-#define AB8500_NUM_BANKS 22
+#define AB8500_NUM_BANKS 24
 
 #define AB8500_REV_REG 0x80
 
@@ -316,7 +316,7 @@ static struct ab8500_prcmu_ranges debug_ranges[AB8500_NUM_BANKS] = {
 		},
 	},
 	[AB8500_CHARGER] = {
-		.num_ranges = 8,
+		.num_ranges = 9,
 		.range = (struct ab8500_reg_range[]) {
 			{
 				.first = 0x00,
@@ -350,6 +350,10 @@ static struct ab8500_prcmu_ranges debug_ranges[AB8500_NUM_BANKS] = {
 				.first = 0xC0,
 				.last = 0xC2,
 			},
+			{
+				.first = 0xf5,
+				.last =	0xf6,
+			},
 		},
 	},
 	[AB8500_GAS_GAUGE] = {
@@ -369,6 +373,24 @@ static struct ab8500_prcmu_ranges debug_ranges[AB8500_NUM_BANKS] = {
 			},
 		},
 	},
+	[AB8500_DEVELOPMENT] = {
+		.num_ranges = 1,
+		.range = (struct ab8500_reg_range[]) {
+			{
+				.first = 0x00,
+				.last = 0x00,
+			},
+		},
+	},
+	[AB8500_DEBUG] = {
+		.num_ranges = 1,
+		.range = (struct ab8500_reg_range[]) {
+			{
+				.first = 0x05,
+				.last = 0x07,
+			},
+		},
+	},
 	[AB8500_AUDIO] = {
 		.num_ranges = 1,
 		.range = (struct ab8500_reg_range[]) {
-- 
1.7.9.5

