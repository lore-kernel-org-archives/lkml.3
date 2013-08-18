Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754565Ab3HRREM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Aug 2013 13:04:12 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:54714 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753814Ab3HRREL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Aug 2013 13:04:11 -0400
From: Mark Brown <broonie@kernel.org>
To: Liam Girdwood <lgirdwood@gmail.com>
Cc: linux-kernel@vger.kernel.org, Mark Brown <broonie@linaro.org>
Date: Sun, 18 Aug 2013 18:03:46 +0100
Message-Id: <1376845426-21799-1-git-send-email-broonie@kernel.org>
X-Mailer: git-send-email 1.8.4.rc3
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: [PATCH] regulator: core: Use bool for exclusivitity flag
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mark Brown <broonie@linaro.org>

Just for neatness.

Signed-off-by: Mark Brown <broonie@linaro.org>
---
 drivers/regulator/core.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index 77943ed..b471706 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -1243,7 +1243,7 @@ static struct regulator_dev *regulator_dev_lookup(struct device *dev,
 
 /* Internal regulator request function */
 static struct regulator *_regulator_get(struct device *dev, const char *id,
-					int exclusive)
+					bool exclusive)
 {
 	struct regulator_dev *rdev;
 	struct regulator *regulator = ERR_PTR(-EPROBE_DEFER);
@@ -1349,7 +1349,7 @@ out:
  */
 struct regulator *regulator_get(struct device *dev, const char *id)
 {
-	return _regulator_get(dev, id, 0);
+	return _regulator_get(dev, id, false);
 }
 EXPORT_SYMBOL_GPL(regulator_get);
 
@@ -1410,7 +1410,7 @@ EXPORT_SYMBOL_GPL(devm_regulator_get);
  */
 struct regulator *regulator_get_exclusive(struct device *dev, const char *id)
 {
-	return _regulator_get(dev, id, 1);
+	return _regulator_get(dev, id, true);
 }
 EXPORT_SYMBOL_GPL(regulator_get_exclusive);
 
-- 
1.8.4.rc3

