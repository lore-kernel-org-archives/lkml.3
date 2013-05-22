Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754625Ab3EVNHO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 09:07:14 -0400
Received: from mail-wi0-f174.google.com ([209.85.212.174]:56250 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750921Ab3EVNHN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 09:07:13 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com,
        srinidhi.kasagar@stericsson.com, Lee Jones <lee.jones@linaro.org>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH] regulator: ab8500: Remove external regulator init() clauses
Date: Wed, 22 May 2013 14:07:05 +0100
Message-Id: <1369228025-17192-1-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The driver no longer needs to worry about which platform can and can't
use external regulators successfully. Instead platform code will hold
back external regulator initialisation data in the use-cases where the
driver isn't applicable.

Cc: Mark Brown <broonie@kernel.org>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/regulator/ab8500.c |   10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/regulator/ab8500.c b/drivers/regulator/ab8500.c
index f6656b8..b6270f5 100644
--- a/drivers/regulator/ab8500.c
+++ b/drivers/regulator/ab8500.c
@@ -3156,12 +3156,10 @@ static int ab8500_regulator_probe(struct platform_device *pdev)
 			return err;
 	}
 
-	if (!is_ab8505(ab8500)) {
-		/* register external regulators (before Vaux1, 2 and 3) */
-		err = ab8500_ext_regulator_init(pdev);
-		if (err)
-			return err;
-	}
+	/* register external regulators (before Vaux1, 2 and 3) */
+	err = ab8500_ext_regulator_init(pdev);
+	if (err)
+		return err;
 
 	/* register all regulators */
 	for (i = 0; i < abx500_regulator.info_size; i++) {
-- 
1.7.10.4

