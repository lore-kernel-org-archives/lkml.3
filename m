Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753952Ab3JDKoc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Oct 2013 06:44:32 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:52724 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752464Ab3JDKob (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Oct 2013 06:44:31 -0400
From: Mark Brown <broonie@kernel.org>
To: Liam Girdwood <lgirdwood@gmail.com>,
        Stephen Warren <swarren@wwwdotorg.org>
Cc: linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        Mark Brown <broonie@linaro.org>
Date: Fri,  4 Oct 2013 11:44:24 +0100
Message-Id: <1380883464-28851-1-git-send-email-broonie@kernel.org>
X-Mailer: git-send-email 1.8.4.rc3
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: [PATCH] regulator: core: Always warn when using a dummy regulator
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mark Brown <broonie@linaro.org>

This helps people spot if they have missed a supply from a device tree or
equivalent data structure.

Suggested-by: Stephen Warren <swarren@nvidia.com>
Signed-off-by: Mark Brown <broonie@linaro.org>
---
 drivers/regulator/core.c | 9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index 6333080..13263d1 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -1299,13 +1299,8 @@ static struct regulator *_regulator_get(struct device *dev, const char *id,
 	 * even if it isn't hooked up and just provide a dummy.
 	 */
 	if (has_full_constraints && allow_dummy) {
-		/*
-		 * Log the substitution if regulator configuration is
-		 * not complete to help development.
-		 */
-		if (!has_full_constraints)
-			pr_warn("%s supply %s not found, using dummy regulator\n",
-				devname, id);
+		pr_warn("%s supply %s not found, using dummy regulator\n",
+			devname, id);
 
 		rdev = dummy_regulator_rdev;
 		goto found;
-- 
1.8.4.rc3

