Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759979Ab3FCWac (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 18:30:32 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:6606 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759643Ab3FCWaK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 18:30:10 -0400
X-Authority-Analysis: v=2.0 cv=fZsvOjsF c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=FpHKU8Ff_xgA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=mNcsKcCz_5cA:10 a=YhdJeHolAAAA:8 a=VwQbUJbxAAAA:8 a=_jlGtV7tAAAA:8 a=u6Kjp6XQMGfe5Rn6x1sA:9 a=L1RTw_NLzc0A:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130603221202.711933097@goodmis.org>
User-Agent: quilt/0.60-1
Date: Mon, 03 Jun 2013 18:11:17 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Wei Yongjun <yongjun_wei@trendmicro.com.cn>,
        Guenter Roeck <linux@roeck-us.net>
Subject: [61/65] hwmon: fix error return code in abituguru_probe()
References: <20130603221016.243553628@goodmis.org>
Content-Disposition: inline; filename=0061-hwmon-fix-error-return-code-in-abituguru_probe.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.5 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

[ Upstream commit ecacb0b17c08fae89f65468727f0e4b8e91da4e1 ]

Fix to return a negative error code from the error handling
case instead of 0, as done elsewhere in this function.

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
Cc: stable@vger.kernel.org
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/hwmon/abituguru.c |   16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/drivers/hwmon/abituguru.c b/drivers/hwmon/abituguru.c
index d4419b4..b13409c 100644
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
1.7.10.4


