Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752935Ab3JZOin (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Oct 2013 10:38:43 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:32809 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751615Ab3JZOim (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Oct 2013 10:38:42 -0400
From: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
To: lee.jones@linaro.org
Cc: sameo@linux.intel.com, patches@opensource.wolfsonmicro.com,
        linux-kernel@vger.kernel.org,
        Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
Subject: [PATCH] mfd: wm5110: Enable micd clamp functionality
Date: Sat, 26 Oct 2013 15:27:04 +0100
Message-Id: <1382797624-20301-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add missing registers and interrupts required for the microphone
detection clamping.

Signed-off-by: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
---
 drivers/mfd/wm5110-tables.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/drivers/mfd/wm5110-tables.c b/drivers/mfd/wm5110-tables.c
index c5c116a..bf8b3b5 100644
--- a/drivers/mfd/wm5110-tables.c
+++ b/drivers/mfd/wm5110-tables.c
@@ -243,6 +243,12 @@ int wm5110_patch(struct arizona *arizona)
 EXPORT_SYMBOL_GPL(wm5110_patch);
 
 static const struct regmap_irq wm5110_aod_irqs[ARIZONA_NUM_IRQ] = {
+	[ARIZONA_IRQ_MICD_CLAMP_FALL] = {
+		.mask = ARIZONA_MICD_CLAMP_FALL_EINT1
+	},
+	[ARIZONA_IRQ_MICD_CLAMP_RISE] = {
+		.mask = ARIZONA_MICD_CLAMP_RISE_EINT1
+	},
 	[ARIZONA_IRQ_GP5_FALL] = { .mask = ARIZONA_GP5_FALL_EINT1 },
 	[ARIZONA_IRQ_GP5_RISE] = { .mask = ARIZONA_GP5_RISE_EINT1 },
 	[ARIZONA_IRQ_JD_FALL] = { .mask = ARIZONA_JD1_FALL_EINT1 },
@@ -505,6 +511,7 @@ static const struct reg_default wm5110_reg_default[] = {
 	{ 0x00000293, 0x0000 },    /* R659   - Accessory Detect Mode 1 */
 	{ 0x0000029B, 0x0020 },    /* R667   - Headphone Detect 1 */
 	{ 0x0000029C, 0x0000 },    /* R668   - Headphone Detect 2 */
+	{ 0x000002A2, 0x0000 },    /* R674   - Micd clamp control */
 	{ 0x000002A3, 0x1102 },    /* R675   - Mic Detect 1 */
 	{ 0x000002A4, 0x009F },    /* R676   - Mic Detect 2 */
 	{ 0x000002A5, 0x0000 },    /* R677   - Mic Detect 3 */
@@ -1439,6 +1446,7 @@ static bool wm5110_readable_register(struct device *dev, unsigned int reg)
 	case ARIZONA_ACCESSORY_DETECT_MODE_1:
 	case ARIZONA_HEADPHONE_DETECT_1:
 	case ARIZONA_HEADPHONE_DETECT_2:
+	case ARIZONA_MICD_CLAMP_CONTROL:
 	case ARIZONA_MIC_DETECT_1:
 	case ARIZONA_MIC_DETECT_2:
 	case ARIZONA_MIC_DETECT_3:
-- 
1.7.2.5

