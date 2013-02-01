Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757352Ab3BATug (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2013 14:50:36 -0500
Received: from rere.qmqm.pl ([89.167.52.164]:59525 "EHLO rere.qmqm.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756777Ab3BATuc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2013 14:50:32 -0500
X-Greylist: delayed 613 seconds by postgrey-1.27 at vger.kernel.org; Fri, 01 Feb 2013 14:50:32 EST
Message-Id: <2849e2f3d81b148eb82ad5161e8cf41bda81080e.1359746656.git.mirq-linux@rere.qmqm.pl>
From: =?UTF-8?q?Micha=C5=82=20Miros=C5=82aw?= <mirq-linux@rere.qmqm.pl>
Subject: [PATCH] regulator: show state for GPIO-controlled regulators
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
To: Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org (open list)
Date: Fri,  1 Feb 2013 20:40:17 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Michał Mirosław <mirq-linux@rere.qmqm.pl>
---

patch against https://github.com/torvalds/linux.git master

 drivers/regulator/core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index 2785843..6b3550a 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -3208,7 +3208,7 @@ static int add_regulator_attributes(struct regulator_dev *rdev)
 		if (status < 0)
 			return status;
 	}
-	if (ops->is_enabled) {
+	if (rdev->ena_gpio || ops->is_enabled) {
 		status = device_create_file(dev, &dev_attr_state);
 		if (status < 0)
 			return status;
-- 
1.7.10.4

