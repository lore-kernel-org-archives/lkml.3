Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755419Ab3BDL5f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 06:57:35 -0500
Received: from mail-wg0-f54.google.com ([74.125.82.54]:61326 "EHLO
	mail-wg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755376Ab3BDL5b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 06:57:31 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-kernel@vger.kernel.org, broonie@opensource.wolfsonmicro.com
Cc: Rabin Vincent <rabin.vincent@stericsson.com>,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 53/73] regulator: ab8500: Don't register external regulators on AB8505
Date: Mon,  4 Feb 2013 11:54:08 +0000
Message-Id: <1359978868-28736-54-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1359978868-28736-1-git-send-email-lee.jones@linaro.org>
References: <1359978868-28736-1-git-send-email-lee.jones@linaro.org>
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
index 12ec061..392e469 100644
--- a/drivers/regulator/ab8500.c
+++ b/drivers/regulator/ab8500.c
@@ -2740,10 +2740,12 @@ static int ab8500_regulator_probe(struct platform_device *pdev)
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
@@ -2785,10 +2787,12 @@ static int ab8500_regulator_remove(struct platform_device *pdev)
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

