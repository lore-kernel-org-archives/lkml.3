Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753928AbaH2STW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2014 14:19:22 -0400
Received: from relay1.mentorg.com ([192.94.38.131]:33189 "EHLO
	relay1.mentorg.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752974AbaH2STU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2014 14:19:20 -0400
From: Dmitry Eremin-Solenikov <dmitry_eremin@mentor.com>
To: <linux-kernel@vger.kernel.org>
CC: Mark Brown <broonie@kernel.org>, Liam Girdwood <lgirdwood@gmail.com>,
        Dirk Behme <dirk.behme@de.bosch.com>,
        Gokulkrishnan Nagarajan <Gokulkrishnan.Nagarajan@in.bosch.com>
Subject: [PATCH] regulator: core: GPIO #0 is a valid GPIO
Date: Fri, 29 Aug 2014 22:19:16 +0400
Message-ID: <1409336356-27682-1-git-send-email-dmitry_eremin@mentor.com>
X-Mailer: git-send-email 2.1.0.rc1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dirk Behme <dirk.behme@de.bosch.com>

With GPIO #0, this if statement will always fail. Remove this, the
check for gpio_is_valid() is sufficent here.

Change-Id: Ia10e8e9c74e11deba852fcd44040cc275b583cfd
Signed-off-by: Gokulkrishnan Nagarajan <Gokulkrishnan.Nagarajan@in.bosch.com>
Signed-off-by: Dirk Behme <dirk.behme@de.bosch.com>
---
 drivers/regulator/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index 117f9f8..2f0794f 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -3524,7 +3524,7 @@ regulator_register(const struct regulator_desc *regulator_desc,
 
 	dev_set_drvdata(&rdev->dev, rdev);
 
-	if (config->ena_gpio && gpio_is_valid(config->ena_gpio)) {
+	if (gpio_is_valid(config->ena_gpio)) {
 		ret = regulator_ena_gpio_request(rdev, config);
 		if (ret != 0) {
 			rdev_err(rdev, "Failed to request enable GPIO%d: %d\n",
-- 
2.1.0.rc1

