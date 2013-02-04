Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754055Ab3BDImL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 03:42:11 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:16657 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753691Ab3BDImK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 03:42:10 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Mon, 04 Feb 2013 00:41:45 -0800
From: Alexandre Courbot <acourbot@nvidia.com>
To: Linus Walleij <linus.walleij@linaro.org>,
        Grant Likely <grant.likely@secretlab.ca>
CC: <linux-kernel@vger.kernel.org>, Alexandre Courbot <acourbot@nvidia.com>
Subject: [PATCH] gpiolib: add missing braces in gpio_direction_show
Date: Mon, 4 Feb 2013 17:42:04 +0900
Message-ID: <1359967324-13074-1-git-send-email-acourbot@nvidia.com>
X-Mailer: git-send-email 1.8.1.2
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add missing braces in an if..else condition.

Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
---
 drivers/gpio/gpiolib.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
index e27877a..e14eb88 100644
--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -212,13 +212,14 @@ static ssize_t gpio_direction_show(struct device *dev,
 
 	mutex_lock(&sysfs_lock);
 
-	if (!test_bit(FLAG_EXPORT, &desc->flags))
+	if (!test_bit(FLAG_EXPORT, &desc->flags)) {
 		status = -EIO;
-	else
+	} else {
 		gpio_get_direction(gpio);
 		status = sprintf(buf, "%s\n",
 			test_bit(FLAG_IS_OUT, &desc->flags)
 				? "out" : "in");
+	}
 
 	mutex_unlock(&sysfs_lock);
 	return status;
-- 
1.8.1.2

