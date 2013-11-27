Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757366Ab3K0QYo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 11:24:44 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:36456 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756735Ab3K0QYn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 11:24:43 -0500
From: Mark Brown <broonie@kernel.org>
To: Fabio Estevam <festevam@gmail.com>, Liam Girdwood <lgirdwood@gmail.com>
Cc: thierry.reding@gmail.com, linux-kernel@vger.kernel.org,
        linaro-kernel@lists.linaro.org, Mark Brown <broonie@linaro.org>
Date: Wed, 27 Nov 2013 16:24:16 +0000
Message-Id: <1385569457-8650-1-git-send-email-broonie@kernel.org>
X-Mailer: git-send-email 1.8.4.4
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: [PATCH 1/2] regulator: core: Replace checks of have_full_constraints with a function
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mark Brown <broonie@linaro.org>

Simple code reorganisation so we can change the logic for deciding what
full constraints are more easily.

Signed-off-by: Mark Brown <broonie@linaro.org>
---
 drivers/regulator/core.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index 3fe13130baec..02fdf925bb56 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -119,6 +119,11 @@ static const char *rdev_get_name(struct regulator_dev *rdev)
 		return "";
 }
 
+static bool have_full_constraints(void)
+{
+	return has_full_constraints;
+}
+
 /**
  * of_get_regulator - get a regulator device node based on supply name
  * @dev: Device pointer for the consumer (of regulator) device
@@ -1340,7 +1345,7 @@ static struct regulator *_regulator_get(struct device *dev, const char *id,
 	 * Assume that a regulator is physically present and enabled
 	 * even if it isn't hooked up and just provide a dummy.
 	 */
-	if (has_full_constraints && allow_dummy) {
+	if (have_full_constraints() && allow_dummy) {
 		pr_warn("%s supply %s not found, using dummy regulator\n",
 			devname, id);
 
@@ -3627,7 +3632,7 @@ int regulator_suspend_finish(void)
 			if (error)
 				ret = error;
 		} else {
-			if (!has_full_constraints)
+			if (!have_full_constraints())
 				goto unlock;
 			if (!ops->disable)
 				goto unlock;
@@ -3825,7 +3830,7 @@ static int __init regulator_init_complete(void)
 		if (!enabled)
 			goto unlock;
 
-		if (has_full_constraints) {
+		if (have_full_constraints()) {
 			/* We log since this may kill the system if it
 			 * goes wrong. */
 			rdev_info(rdev, "disabling\n");
-- 
1.8.4.4

