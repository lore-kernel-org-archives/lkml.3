Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932455Ab3FAJ6m (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Jun 2013 05:58:42 -0400
Received: from www17.your-server.de ([213.133.104.17]:60910 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932430Ab3FAJ6g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Jun 2013 05:58:36 -0400
Message-ID: <1370080711.29224.34.camel@localhost.localdomain>
Subject: [PATCH] rtc: Cocci spatch "ptr_ret.spatch"
From: Thomas Meyer <thomas@m3y3r.de>
To: a.zummo@towertech.it, rtc-linux@googlegroups.com,
        linux-kernel@vger.kernel.org
Date: Sat, 01 Jun 2013 11:58:31 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: thomas@m3y3r.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Thomas Meyer <thomas@m3y3r.de>
---

diff -u -p a/drivers/rtc/rtc-da9052.c b/drivers/rtc/rtc-da9052.c
--- a/drivers/rtc/rtc-da9052.c
+++ b/drivers/rtc/rtc-da9052.c
@@ -249,10 +249,7 @@ static int da9052_rtc_probe(struct platf
 
 	rtc->rtc = devm_rtc_device_register(&pdev->dev, pdev->name,
 				       &da9052_rtc_ops, THIS_MODULE);
-	if (IS_ERR(rtc->rtc))
-		return PTR_ERR(rtc->rtc);
-
-	return 0;
+	return PTR_RET(rtc->rtc);
 }
 
 static int da9052_rtc_remove(struct platform_device *pdev)
diff -u -p a/drivers/rtc/rtc-isl12022.c b/drivers/rtc/rtc-isl12022.c
--- a/drivers/rtc/rtc-isl12022.c
+++ b/drivers/rtc/rtc-isl12022.c
@@ -267,10 +267,7 @@ static int isl12022_probe(struct i2c_cli
 	isl12022->rtc = devm_rtc_device_register(&client->dev,
 					isl12022_driver.driver.name,
 					&isl12022_rtc_ops, THIS_MODULE);
-	if (IS_ERR(isl12022->rtc))
-		return PTR_ERR(isl12022->rtc);
-
-	return 0;
+	return PTR_RET(isl12022->rtc);
 }
 
 static int isl12022_remove(struct i2c_client *client)
diff -u -p a/drivers/rtc/rtc-m48t35.c b/drivers/rtc/rtc-m48t35.c
--- a/drivers/rtc/rtc-m48t35.c
+++ b/drivers/rtc/rtc-m48t35.c
@@ -174,10 +174,7 @@ static int m48t35_probe(struct platform_
 
 	priv->rtc = devm_rtc_device_register(&pdev->dev, "m48t35",
 				  &m48t35_ops, THIS_MODULE);
-	if (IS_ERR(priv->rtc))
-		return PTR_ERR(priv->rtc);
-
-	return 0;
+	return PTR_RET(priv->rtc);
 }
 
 static int m48t35_remove(struct platform_device *pdev)
diff -u -p a/drivers/rtc/rtc-pcf8563.c b/drivers/rtc/rtc-pcf8563.c
--- a/drivers/rtc/rtc-pcf8563.c
+++ b/drivers/rtc/rtc-pcf8563.c
@@ -263,10 +263,7 @@ static int pcf8563_probe(struct i2c_clie
 				pcf8563_driver.driver.name,
 				&pcf8563_rtc_ops, THIS_MODULE);
 
-	if (IS_ERR(pcf8563->rtc))
-		return PTR_ERR(pcf8563->rtc);
-
-	return 0;
+	return PTR_RET(pcf8563->rtc);
 }
 
 static int pcf8563_remove(struct i2c_client *client)
diff -u -p a/drivers/rtc/rtc-pcf8583.c b/drivers/rtc/rtc-pcf8583.c
--- a/drivers/rtc/rtc-pcf8583.c
+++ b/drivers/rtc/rtc-pcf8583.c
@@ -283,10 +283,7 @@ static int pcf8583_probe(struct i2c_clie
 				pcf8583_driver.driver.name,
 				&pcf8583_rtc_ops, THIS_MODULE);
 
-	if (IS_ERR(pcf8583->rtc))
-		return PTR_ERR(pcf8583->rtc);
-
-	return 0;
+	return PTR_RET(pcf8583->rtc);
 }
 
 static int pcf8583_remove(struct i2c_client *client)


