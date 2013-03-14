Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757394Ab3CNKpD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 06:45:03 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:52030 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757287Ab3CNKiD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 06:38:03 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 66/88] hwmon: (sht15) Check return value of regulator_enable()
Date: Thu, 14 Mar 2013 10:35:59 +0000
Message-Id: <1363257381-15900-67-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1363257381-15900-1-git-send-email-luis.henriques@canonical.com>
References: <1363257381-15900-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.8 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mark Brown <broonie@opensource.wolfsonmicro.com>

commit 3e78080f81481aa8340374d5a37ae033c1cf4272 upstream.

Not having power is a pretty serious error so check that we are able to
enable the supply and error out if we can't.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/hwmon/sht15.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/hwmon/sht15.c b/drivers/hwmon/sht15.c
index 8b011d0..eb01802 100644
--- a/drivers/hwmon/sht15.c
+++ b/drivers/hwmon/sht15.c
@@ -926,7 +926,13 @@ static int __devinit sht15_probe(struct platform_device *pdev)
 		if (voltage)
 			data->supply_uV = voltage;
 
-		regulator_enable(data->reg);
+		ret = regulator_enable(data->reg);
+		if (ret != 0) {
+			dev_err(&pdev->dev,
+				"failed to enable regulator: %d\n", ret);
+			return ret;
+		}
+
 		/*
 		 * Setup a notifier block to update this if another device
 		 * causes the voltage to change
-- 
1.8.1.2

