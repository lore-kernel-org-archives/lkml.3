Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752943AbaEWOsR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 10:48:17 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:49894 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751849AbaEWOsO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 10:48:14 -0400
From: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
To: lee.jones@linaro.org
Cc: sameo@linux.intel.com, broonie@kernel.org, lgirdwood@gmail.com,
        patches@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org
Subject: [PATCH 1/5] mfd: wm5110: Remove non-existant interrupts
Date: Fri, 23 May 2014 15:40:30 +0100
Message-Id: <1400856034-4509-2-git-send-email-ckeepax@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1400856034-4509-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
References: <1400856034-4509-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The DCS_DAC_DONE and DCS_HP_DONE interrupts do not exist on the wm5110
version of the IP. This patch removes them from the regmap IRQ
structure.

Signed-off-by: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
---
 drivers/mfd/wm5110-tables.c |    6 ------
 1 files changed, 0 insertions(+), 6 deletions(-)

diff --git a/drivers/mfd/wm5110-tables.c b/drivers/mfd/wm5110-tables.c
index d47fc2d..157a193 100644
--- a/drivers/mfd/wm5110-tables.c
+++ b/drivers/mfd/wm5110-tables.c
@@ -420,12 +420,6 @@ static const struct regmap_irq wm5110_irqs[ARIZONA_NUM_IRQ] = {
 	[ARIZONA_IRQ_BOOT_DONE] = {
 		.reg_offset = 4, .mask = ARIZONA_BOOT_DONE_EINT1
 	},
-	[ARIZONA_IRQ_DCS_DAC_DONE] = {
-		.reg_offset = 4, .mask = ARIZONA_DCS_DAC_DONE_EINT1
-	},
-	[ARIZONA_IRQ_DCS_HP_DONE] = {
-		.reg_offset = 4, .mask = ARIZONA_DCS_HP_DONE_EINT1
-	},
 	[ARIZONA_IRQ_FLL2_CLOCK_OK] = {
 		.reg_offset = 4, .mask = ARIZONA_FLL2_CLOCK_OK_EINT1
 	},
-- 
1.7.2.5

