Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753453AbaAIMCR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 07:02:17 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:59696 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750702AbaAIMCF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 07:02:05 -0500
From: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
To: lee.jones@linaro.org
Cc: sameo@linux.intel.com, patches@opensource.wolfsonmicro.com,
        linux-kernel@vger.kernel.org
Subject: [RESEND PATCH] mfd: wm5110: Add register patch for rev D chip
Date: Thu,  9 Jan 2014 11:53:54 +0000
Message-Id: <1389268434-20334-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Evaluation of revision D of WM5110 suggests updates to the register
patch for optimal performance. For the sake of clarity rev C of the chip
does not require a register patch.

Signed-off-by: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
---
 drivers/mfd/wm5110-tables.c |   30 +++++++++++++++++++++++++++++-
 1 files changed, 29 insertions(+), 1 deletions(-)

diff --git a/drivers/mfd/wm5110-tables.c b/drivers/mfd/wm5110-tables.c
index 8dc49ec..24ec464 100644
--- a/drivers/mfd/wm5110-tables.c
+++ b/drivers/mfd/wm5110-tables.c
@@ -224,6 +224,31 @@ static const struct reg_default wm5110_revb_patch[] = {
 	{ 0x80, 0x0 },
 };
 
+static const struct reg_default wm5110_revd_patch[] = {
+	{ 0x80, 0x3 },
+	{ 0x80, 0x3 },
+	{ 0x393, 0x27 },
+	{ 0x394, 0x27 },
+	{ 0x395, 0x27 },
+	{ 0x396, 0x27 },
+	{ 0x397, 0x27 },
+	{ 0x398, 0x26 },
+	{ 0x221, 0x90 },
+	{ 0x211, 0x8 },
+	{ 0x36c, 0x1fb },
+	{ 0x26e, 0x64 },
+	{ 0x26f, 0xea },
+	{ 0x270, 0x1f16 },
+	{ 0x51b, 0x1 },
+	{ 0x55b, 0x1 },
+	{ 0x59b, 0x1 },
+	{ 0x4f0, 0x633 },
+	{ 0x441, 0xc059 },
+	{ 0x209, 0x27 },
+	{ 0x80, 0x0 },
+	{ 0x80, 0x0 },
+};
+
 /* We use a function so we can use ARRAY_SIZE() */
 int wm5110_patch(struct arizona *arizona)
 {
@@ -236,7 +261,10 @@ int wm5110_patch(struct arizona *arizona)
 		return regmap_register_patch(arizona->regmap,
 					     wm5110_revb_patch,
 					     ARRAY_SIZE(wm5110_revb_patch));
-
+	case 3:
+		return regmap_register_patch(arizona->regmap,
+					     wm5110_revd_patch,
+					     ARRAY_SIZE(wm5110_revd_patch));
 	default:
 		return 0;
 	}
-- 
1.7.2.5

