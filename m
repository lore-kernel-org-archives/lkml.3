Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754415Ab3IEDbc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 23:31:32 -0400
Received: from mail-pa0-f54.google.com ([209.85.220.54]:63539 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752496Ab3IEDbb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 23:31:31 -0400
Message-ID: <1378351885.16198.1.camel@phoenix>
Subject: [PATCH] regulator: palmas: Drop regulator_unregister while using
 devm_regulator_register
From: Axel Lin <axel.lin@ingics.com>
To: Mark Brown <broonie@kernel.org>
Cc: Sachin Kamat <sachin.kamat@linaro.org>,
        Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org
Date: Thu, 05 Sep 2013 11:31:25 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commmit af40a94aba "regulator: palmas: Use devm_regulator_register" missed
removing a regulator_unregister() call if palmas_extreg_init falis. Fix it.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/regulator/palmas-regulator.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/regulator/palmas-regulator.c b/drivers/regulator/palmas-regulator.c
index 37b1068..825f798 100644
--- a/drivers/regulator/palmas-regulator.c
+++ b/drivers/regulator/palmas-regulator.c
@@ -1019,10 +1019,8 @@ static int palmas_regulators_probe(struct platform_device *pdev)
 				else
 					ret = palmas_extreg_init(palmas,
 							id, reg_init);
-				if (ret) {
-					regulator_unregister(pmic->rdev[id]);
+				if (ret)
 					return ret;
-				}
 			}
 		}
 	}
-- 
1.8.1.2



