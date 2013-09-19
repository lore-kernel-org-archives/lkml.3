Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753611Ab3ISMSp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Sep 2013 08:18:45 -0400
Received: from hqemgate16.nvidia.com ([216.228.121.65]:17749 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752033Ab3ISMSo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Sep 2013 08:18:44 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Thu, 19 Sep 2013 05:15:20 -0700
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <broonie@kernel.org>
CC: <lgirdwood@gmail.com>, <linux-kernel@vger.kernel.org>,
        <patches@opensource.wolfsonmicro.com>,
        Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH] regulator: wm8350: correct the max_uV of LDO
Date: Thu, 19 Sep 2013 18:09:55 +0530
Message-ID: <1379594395-3602-1-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As per datasheet, voltage range for LDOs are as follows:

	0000 = 0.9V
		...(50mV steps)
	01111 = 1.65V
	10000 = 1.8V
		... (100mV stepns)
	11111 = 3.3V

So, there is no  selector for 1.65V to 1.8V.
Correcting the range for max_uV for selector between 0 to 15.

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
---
When trying to understand the usage of linear_range, found the above issue
in code. I do not have hardware to validate but though that let's send this
for review. Probably this is real bug.

 drivers/regulator/wm8350-regulator.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/regulator/wm8350-regulator.c b/drivers/regulator/wm8350-regulator.c
index a438e93..017e869 100644
--- a/drivers/regulator/wm8350-regulator.c
+++ b/drivers/regulator/wm8350-regulator.c
@@ -543,7 +543,7 @@ static int wm8350_dcdc_set_suspend_mode(struct regulator_dev *rdev,
 }
 
 static const struct regulator_linear_range wm8350_ldo_ranges[] = {
-	{ .min_uV =  900000, .max_uV = 1750000, .min_sel =  0, .max_sel = 15,
+	{ .min_uV =  900000, .max_uV = 1650000, .min_sel =  0, .max_sel = 15,
 	  .uV_step =  50000 },
 	{ .min_uV = 1800000, .max_uV = 3300000, .min_sel = 16, .max_sel = 31,
 	  .uV_step = 100000 },
-- 
1.7.1.1

