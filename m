Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752493Ab3KSPhW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 10:37:22 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:38498 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751379Ab3KSPhV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 10:37:21 -0500
From: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
To: lee.jones@linaro.org
Cc: sameo@linux.intel.com, patches@opensource.wolfsonmicro.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2] mfd: wm5110: Add register patch for rev D chip
Date: Tue, 19 Nov 2013 15:36:06 +0000
Message-Id: <1384875366-2527-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Evaluation of revision D of WM5110 suggests updates to the register
patch for optimal performance. For the sake of clarity rev C of the chip
does not require a register patch.

Signed-off-by: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
---

Updated the commit message to give a little more info on
what the register patch is for.

As regards add #defines for the silicon revisions I am not
sure it adds a significant amount of extra clarity, is "case
A: case B:" really a lot clearer than "case 0: case 1:"
but that said I am happy to do a patch for this if we feel
strongly about it? Although I would suggest it should be
seperate from this patch.

Thanks,
Charles

 drivers/mfd/wm5110-tables.c |   30 +++++++++++++++++++++++++++++-
 1 files changed, 29 insertions(+), 1 deletions(-)

diff --git a/drivers/mfd/wm5110-tables.c b/drivers/mfd/wm5110-tables.c
index daf2fe8..bd9c3c9 100644
--- a/drivers/mfd/wm5110-tables.c
+++ b/drivers/mfd/wm5110-tables.c
@@ -223,6 +223,31 @@ static const struct reg_default wm5110_revb_patch[] = {
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
@@ -235,7 +260,10 @@ int wm5110_patch(struct arizona *arizona)
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

