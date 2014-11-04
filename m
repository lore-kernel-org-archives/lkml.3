Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932114AbaKDPeJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 10:34:09 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:37638 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752203AbaKDPeF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 10:34:05 -0500
From: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
To: lee.jones@linaro.org
Cc: sameo@linux.intel.com, patches@opensource.wolfsonmicro.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH] mfd: wm8997: Mark INTERRUPT_STATUS_2_MASK as readable
Date: Tue,  4 Nov 2014 15:26:22 +0000
Message-Id: <1415114782-32691-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Technically this register is not used on wm8997 however the regmap core
requires a continuous block of IRQs. The simplest solution is just to
add the register.

Signed-off-by: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
---
 drivers/mfd/wm8997-tables.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/mfd/wm8997-tables.c b/drivers/mfd/wm8997-tables.c
index 06c3093..c0c25d7 100644
--- a/drivers/mfd/wm8997-tables.c
+++ b/drivers/mfd/wm8997-tables.c
@@ -670,6 +670,7 @@ static const struct reg_default wm8997_reg_default[] = {
 	{ 0x00000C23, 0x0000 },    /* R3107  - Misc Pad Ctrl 4 */
 	{ 0x00000C24, 0x0000 },    /* R3108  - Misc Pad Ctrl 5 */
 	{ 0x00000D08, 0xFFFF },    /* R3336  - Interrupt Status 1 Mask */
+	{ 0x00000D09, 0xFFFF },    /* R3337  - Interrupt Status 2 Mask */
 	{ 0x00000D0A, 0xFFFF },    /* R3338  - Interrupt Status 3 Mask */
 	{ 0x00000D0B, 0xFFFF },    /* R3339  - Interrupt Status 4 Mask */
 	{ 0x00000D0C, 0xFEFF },    /* R3340  - Interrupt Status 5 Mask */
@@ -1330,6 +1331,7 @@ static bool wm8997_readable_register(struct device *dev, unsigned int reg)
 	case ARIZONA_INTERRUPT_STATUS_4:
 	case ARIZONA_INTERRUPT_STATUS_5:
 	case ARIZONA_INTERRUPT_STATUS_1_MASK:
+	case ARIZONA_INTERRUPT_STATUS_2_MASK:
 	case ARIZONA_INTERRUPT_STATUS_3_MASK:
 	case ARIZONA_INTERRUPT_STATUS_4_MASK:
 	case ARIZONA_INTERRUPT_STATUS_5_MASK:
-- 
1.7.2.5

