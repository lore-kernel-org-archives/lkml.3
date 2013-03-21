Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934079Ab3CUQFn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 12:05:43 -0400
Received: from mail-wi0-f177.google.com ([209.85.212.177]:65083 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756211Ab3CUQBG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 12:01:06 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        broonie@opensource.wolfsonmicro.com
Cc: arnd@arndb.de, linus.walleij@stericsson.com,
        Rabin Vincent <rabin.vincent@stericsson.com>,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 31/46] regulator: ab8500: Don't register external regulators on AB8505
Date: Thu, 21 Mar 2013 15:59:28 +0000
Message-Id: <1363881583-15234-32-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1363881583-15234-1-git-send-email-lee.jones@linaro.org>
References: <1363881583-15234-1-git-send-email-lee.jones@linaro.org>
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
index 840f23b..c1e1cf9 100644
--- a/drivers/regulator/ab8500.c
+++ b/drivers/regulator/ab8500.c
@@ -2767,10 +2767,12 @@ static int ab8500_regulator_probe(struct platform_device *pdev)
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
@@ -2812,10 +2814,12 @@ static int ab8500_regulator_remove(struct platform_device *pdev)
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
1.7.10.4

