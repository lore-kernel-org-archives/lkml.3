Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756488AbaDQMWS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 08:22:18 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:33906 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751942AbaDQMWR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 08:22:17 -0400
From: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
To: lee.jones@linaro.org
Cc: sameo@linux.intel.com, patches@opensource.wolfsonmicro.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH] mfd: wm5110: Add missing isolation control register
Date: Thu, 17 Apr 2014 13:14:15 +0100
Message-Id: <1397736855-28021-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The isolation control register is required when DCVDD is externally
supplied add this in as a readable register.

Signed-off-by: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
---
 drivers/mfd/wm5110-tables.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/mfd/wm5110-tables.c b/drivers/mfd/wm5110-tables.c
index ca99685..d47fc2d 100644
--- a/drivers/mfd/wm5110-tables.c
+++ b/drivers/mfd/wm5110-tables.c
@@ -549,6 +549,7 @@ static const struct reg_default wm5110_reg_default[] = {
 	{ 0x000002A8, 0x1422 },    /* R680   - Mic Detect Level 3 */
 	{ 0x000002A9, 0x300A },    /* R681   - Mic Detect Level 4 */
 	{ 0x000002C3, 0x0000 },    /* R707   - Mic noise mix control 1 */
+	{ 0x000002CB, 0x0000 },    /* R715   - Isolation control */
 	{ 0x000002D3, 0x0000 },    /* R723   - Jack detect analogue */
 	{ 0x00000300, 0x0000 },    /* R768   - Input Enables */
 	{ 0x00000308, 0x0000 },    /* R776   - Input Rate */
@@ -1580,6 +1581,7 @@ static bool wm5110_readable_register(struct device *dev, unsigned int reg)
 	case ARIZONA_MIC_DETECT_LEVEL_3:
 	case ARIZONA_MIC_DETECT_LEVEL_4:
 	case ARIZONA_MIC_NOISE_MIX_CONTROL_1:
+	case ARIZONA_ISOLATION_CONTROL:
 	case ARIZONA_JACK_DETECT_ANALOGUE:
 	case ARIZONA_INPUT_ENABLES:
 	case ARIZONA_INPUT_ENABLES_STATUS:
-- 
1.7.2.5

