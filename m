Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753024Ab3IWPOt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 11:14:49 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:55593 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752537Ab3IWPOs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 11:14:48 -0400
From: Mark Brown <broonie@kernel.org>
To: Liam Girdwood <lgirdwood@gmail.com>,
        Thierry Reding <thierry.reding@gmail.com>
Cc: linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        Mark Brown <broonie@linaro.org>
Date: Mon, 23 Sep 2013 16:14:43 +0100
Message-Id: <1379949283-5885-1-git-send-email-broonie@kernel.org>
X-Mailer: git-send-email 1.8.4.rc3
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: [PATCH] regulator: core: Always use return value when regulator_dev_lookup() fails
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mark Brown <broonie@linaro.org>

Ensure that the return value is always set when we return now that the
logic has changed for regulator_get_optional() so we don't get missing
codes leaking out.

Reported-by: Thierry Reding <treding@nvidia.com>
Signed-off-by: Mark Brown <broonie@linaro.org>
---
 drivers/regulator/core.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index fabbf32..6333080 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -1281,12 +1281,13 @@ static struct regulator *_regulator_get(struct device *dev, const char *id,
 	if (rdev)
 		goto found;
 
+	regulator = ERR_PTR(ret);
+
 	/*
 	 * If we have return value from dev_lookup fail, we do not expect to
 	 * succeed, so, quit with appropriate error value
 	 */
 	if (ret && ret != -ENODEV) {
-		regulator = ERR_PTR(ret);
 		goto out;
 	}
 
-- 
1.8.4.rc3

