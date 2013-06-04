Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755430Ab3FDO2X (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 10:28:23 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:46624 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755278Ab3FDOHh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 10:07:37 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Wei Yongjun <yongjun_wei@trendmicro.com.cn>,
        Guenter Roeck <linux@roeck-us.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 01/70] hwmon: fix error return code in abituguru_probe()
Date: Tue,  4 Jun 2013 15:06:17 +0100
Message-Id: <1370354846-14213-2-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1370354846-14213-1-git-send-email-luis.henriques@canonical.com>
References: <1370354846-14213-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.14 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

commit ecacb0b17c08fae89f65468727f0e4b8e91da4e1 upstream.

Fix to return a negative error code from the error handling
case instead of 0, as done elsewhere in this function.

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/hwmon/abituguru.c | 16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/drivers/hwmon/abituguru.c b/drivers/hwmon/abituguru.c
index a72bf25..56b178a 100644
--- a/drivers/hwmon/abituguru.c
+++ b/drivers/hwmon/abituguru.c
@@ -1410,14 +1410,18 @@ static int __devinit abituguru_probe(struct platform_device *pdev)
 	pr_info("found Abit uGuru\n");
 
 	/* Register sysfs hooks */
-	for (i = 0; i < sysfs_attr_i; i++)
-		if (device_create_file(&pdev->dev,
-				&data->sysfs_attr[i].dev_attr))
+	for (i = 0; i < sysfs_attr_i; i++) {
+		res = device_create_file(&pdev->dev,
+					 &data->sysfs_attr[i].dev_attr);
+		if (res)
 			goto abituguru_probe_error;
-	for (i = 0; i < ARRAY_SIZE(abituguru_sysfs_attr); i++)
-		if (device_create_file(&pdev->dev,
-				&abituguru_sysfs_attr[i].dev_attr))
+	}
+	for (i = 0; i < ARRAY_SIZE(abituguru_sysfs_attr); i++) {
+		res = device_create_file(&pdev->dev,
+					 &abituguru_sysfs_attr[i].dev_attr);
+		if (res)
 			goto abituguru_probe_error;
+	}
 
 	data->hwmon_dev = hwmon_device_register(&pdev->dev);
 	if (!IS_ERR(data->hwmon_dev))
-- 
1.8.1.2

