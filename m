Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753539Ab3F2Dhg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 23:37:36 -0400
Received: from mail-pb0-f43.google.com ([209.85.160.43]:63874 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753428Ab3F2Dhf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 23:37:35 -0400
Message-ID: <1372477049.9121.0.camel@phoenix>
Subject: [PATCH] regulator: max77693: Fix trivial typo
From: Axel Lin <axel.lin@ingics.com>
To: Mark Brown <broonie@kernel.org>
Cc: Jonghwa Lee <jonghwa3.lee@samsung.com>,
        Myungjoo Ham <myungjoo.ham@samsung.com>,
        Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org
Date: Sat, 29 Jun 2013 11:37:29 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix trivial typo in the equation to check upper bound of current setting.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/regulator/max77693.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/regulator/max77693.c b/drivers/regulator/max77693.c
index 674ece7..d45a4dd 100644
--- a/drivers/regulator/max77693.c
+++ b/drivers/regulator/max77693.c
@@ -97,7 +97,7 @@ static int max77693_chg_set_current_limit(struct regulator_dev *rdev,
 	while (chg_min_uA + CHGIN_ILIM_STEP_20mA * sel < min_uA)
 		sel++;
 
-	if (chg_min_uA * CHGIN_ILIM_STEP_20mA * sel > max_uA)
+	if (chg_min_uA + CHGIN_ILIM_STEP_20mA * sel > max_uA)
 		return -EINVAL;
 
 	/* the first four codes for charger current are all 60mA */
-- 
1.8.1.2



