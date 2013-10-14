Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752857Ab3JNISS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 04:18:18 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:45351 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751102Ab3JNISR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 04:18:17 -0400
From: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
To: lee.jones@linaro.org
Cc: sameo@linux.intel.com, patches@opensource.wolfsonmicro.com,
        linux-kernel@vger.kernel.org,
        Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
Subject: [PATCH] mfd: arizona: Mark missing AOD registers as volatile
Date: Mon, 14 Oct 2013 09:09:00 +0100
Message-Id: <1381738140-14007-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This registers ARIZONA_AOD_WKUP_AND_TRIG and ARIZONA_AOD_IRQ_RAW_STATUS
contain interrupt status bits and thus should be volatile. They are
correctly marked on wm5102 but not on wm5110, this patch changes this.
Furthermore volatile registers don't need defaults so remove those.

Signed-off-by: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
---
 drivers/mfd/wm5102-tables.c |    1 -
 drivers/mfd/wm5110-tables.c |    3 ++-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/mfd/wm5102-tables.c b/drivers/mfd/wm5102-tables.c
index 802dd3c..1e9a4b2 100644
--- a/drivers/mfd/wm5102-tables.c
+++ b/drivers/mfd/wm5102-tables.c
@@ -903,7 +903,6 @@ static const struct reg_default wm5102_reg_default[] = {
 	{ 0x00000D1B, 0xFFFF },   /* R3355  - IRQ2 Status 4 Mask */ 
 	{ 0x00000D1C, 0xFFFF },   /* R3356  - IRQ2 Status 5 Mask */ 
 	{ 0x00000D1F, 0x0000 },   /* R3359  - IRQ2 Control */ 
-	{ 0x00000D50, 0x0000 },   /* R3408  - AOD wkup and trig */
 	{ 0x00000D53, 0xFFFF },   /* R3411  - AOD IRQ Mask IRQ1 */ 
 	{ 0x00000D54, 0xFFFF },   /* R3412  - AOD IRQ Mask IRQ2 */ 
 	{ 0x00000D56, 0x0000 },   /* R3414  - Jack detect debounce */ 
diff --git a/drivers/mfd/wm5110-tables.c b/drivers/mfd/wm5110-tables.c
index f71bd9b..c5c116a 100644
--- a/drivers/mfd/wm5110-tables.c
+++ b/drivers/mfd/wm5110-tables.c
@@ -1204,7 +1204,6 @@ static const struct reg_default wm5110_reg_default[] = {
 	{ 0x00000D1B, 0xFFFF },    /* R3355  - IRQ2 Status 4 Mask */
 	{ 0x00000D1C, 0xFFFF },    /* R3356  - IRQ2 Status 5 Mask */
 	{ 0x00000D1F, 0x0000 },    /* R3359  - IRQ2 Control */
-	{ 0x00000D50, 0x0000 },    /* R3408  - AOD wkup and trig */
 	{ 0x00000D53, 0xFFFF },    /* R3411  - AOD IRQ Mask IRQ1 */
 	{ 0x00000D54, 0xFFFF },    /* R3412  - AOD IRQ Mask IRQ2 */
 	{ 0x00000D56, 0x0000 },    /* R3414  - Jack detect debounce */
@@ -2363,8 +2362,10 @@ static bool wm5110_volatile_register(struct device *dev, unsigned int reg)
 	case ARIZONA_INTERRUPT_RAW_STATUS_7:
 	case ARIZONA_INTERRUPT_RAW_STATUS_8:
 	case ARIZONA_IRQ_PIN_STATUS:
+	case ARIZONA_AOD_WKUP_AND_TRIG:
 	case ARIZONA_AOD_IRQ1:
 	case ARIZONA_AOD_IRQ2:
+	case ARIZONA_AOD_IRQ_RAW_STATUS:
 	case ARIZONA_FX_CTRL2:
 	case ARIZONA_ASRC_STATUS:
 	case ARIZONA_DSP_STATUS:
-- 
1.7.2.5

