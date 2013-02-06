Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757523Ab3BFK7f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 05:59:35 -0500
Received: from mail-wi0-f171.google.com ([209.85.212.171]:36880 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757222Ab3BFKzO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 05:55:14 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: broonie@opensource.wolfsonmicro.com, linus.walleij@linaro.org,
        Rabin Vincent <rabin.vincent@stericsson.com>,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 36/49] regulator: ab8500: Don't register external regulators on AB8505
Date: Wed,  6 Feb 2013 10:53:58 +0000
Message-Id: <1360148051-7560-37-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1360148051-7560-1-git-send-email-lee.jones@linaro.org>
References: <1360148051-7560-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rabin Vincent <rabin.vincent@stericsson.com>

ExtSupply regulators are not included on AB8505 based platforms.

Signed-off-by: Rabin Vincent <rabin.vincent@stericsson.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
Tested-by: Marcus COOPER <marcus.xm.cooper@stericsson.com>
---
 drivers/regulator/ab8500.c |   20 ++++++++++++--------
 1 file changed, 12 insertions(+), 8 deletions(-)

diff --git a/drivers/regulator/ab8500.c b/drivers/regulator/ab8500.c
index 1df809e..20c3270 100644
--- a/drivers/regulator/ab8500.c
+++ b/drivers/regulator/ab8500.c
@@ -2761,10 +2761,12 @@ static int ab8500_regulator_probe(struct platform_device *pdev)
 			return err;
 	}
 
-	/* register external regulators (before Vaux1, 2 and 3) */
-	err = ab8500_ext_regulator_init(pdev);
-	if (err)
-		return err;
+	if (!is_ab8505(ab8500)) {
+		/* register external regulators (before Vaux1, 2 and 3) */
+		err = ab8500_ext_regulator_init(pdev);
+		if (err)
+			return err;
+	}
 
 	/* register all regulators */
 	for (i = 0; i < regulator_info_size; i++) {
@@ -2806,10 +2808,12 @@ static int ab8500_regulator_remove(struct platform_device *pdev)
 		regulator_unregister(info->regulator);
 	}
 
-	/* remove external regulators (after Vaux1, 2 and 3) */
-	err = ab8500_ext_regulator_exit(pdev);
-	if (err)
-		return err;
+	if (!is_ab8505(ab8500)) {
+		/* remove external regulators (after Vaux1, 2 and 3) */
+		err = ab8500_ext_regulator_exit(pdev);
+		if (err)
+			return err;
+	}
 
 	/* remove regulator debug */
 	err = ab8500_regulator_debug_exit(pdev);
-- 
1.7.9.5

