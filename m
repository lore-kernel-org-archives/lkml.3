Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752675Ab3F2QeA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Jun 2013 12:34:00 -0400
Received: from mail-pa0-f53.google.com ([209.85.220.53]:47887 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751527Ab3F2Qd7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Jun 2013 12:33:59 -0400
Message-ID: <1372523632.5891.5.camel@phoenix>
Subject: [PATCH] regulator: max77693: Remove NULL test for
 rmatch[i].init_data
From: Axel Lin <axel.lin@ingics.com>
To: Mark Brown <broonie@kernel.org>
Cc: Jonghwa Lee <jonghwa3.lee@samsung.com>,
        Myungjoo Ham <myungjoo.ham@samsung.com>,
        Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org
Date: Sun, 30 Jun 2013 00:33:52 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The implementation in of_regulator_match() already ensures match->init_data is
not NULL for all matched cases if the return value of of_regulator_match() > 0.

Thus remove NULL test for rmatch[i].init_data.

This patch also fixes the condition for loop iteration.
The for loop should iterate "matched" times rather than ARRAY_SIZE(regulators)
because we only allocate "matched" number of entries for rdata.
Though in most cases, "matched" == ARRAY_SIZE(regulators).

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/regulator/max77693.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/regulator/max77693.c b/drivers/regulator/max77693.c
index d45a4dd..ce4b96c 100644
--- a/drivers/regulator/max77693.c
+++ b/drivers/regulator/max77693.c
@@ -190,9 +190,7 @@ static int max77693_pmic_dt_parse_rdata(struct device *dev,
 
 	tmp = *rdata;
 
-	for (i = 0; i < ARRAY_SIZE(regulators); i++) {
-		if (!rmatch[i].init_data)
-			continue;
+	for (i = 0; i < matched; i++) {
 		tmp->initdata = rmatch[i].init_data;
 		tmp->of_node = rmatch[i].of_node;
 		tmp->id = regulators[i].id;
-- 
1.8.1.2



