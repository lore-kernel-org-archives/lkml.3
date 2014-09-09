Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755915AbaIIHxA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 03:53:00 -0400
Received: from bhuna.collabora.co.uk ([93.93.135.160]:34483 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755315AbaIIHw7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 03:52:59 -0400
From: Sjoerd Simons <sjoerd.simons@collabora.co.uk>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Nick Dyer <nick.dyer@itdev.co.uk>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Sjoerd Simons <sjoerd.simons@collabora.co.uk>
Subject: [PATCH] Input: atmel_mxt_ts: Add of node type to the i2c table
Date: Tue,  9 Sep 2014 09:52:38 +0200
Message-Id: <1410249158-18192-1-git-send-email-sjoerd.simons@collabora.co.uk>
X-Mailer: git-send-email 2.1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For i2c devices in OF the modalias exposed to userspace is i2c:<node
type>, for the Maxtouch driver this is i2c:maxtouch.

Add maxtouch to the i2c id table such that userspace can correctly
load the module for the device and drop the OF table as it's not
needed for i2c devices.

Signed-off-by: Sjoerd Simons <sjoerd.simons@collabora.co.uk>
---
 drivers/input/touchscreen/atmel_mxt_ts.c | 8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff --git a/drivers/input/touchscreen/atmel_mxt_ts.c b/drivers/input/touchscreen/atmel_mxt_ts.c
index db178ed..57ff26d 100644
--- a/drivers/input/touchscreen/atmel_mxt_ts.c
+++ b/drivers/input/touchscreen/atmel_mxt_ts.c
@@ -2267,16 +2267,11 @@ static int mxt_resume(struct device *dev)
 
 static SIMPLE_DEV_PM_OPS(mxt_pm_ops, mxt_suspend, mxt_resume);
 
-static const struct of_device_id mxt_of_match[] = {
-	{ .compatible = "atmel,maxtouch", },
-	{},
-};
-MODULE_DEVICE_TABLE(of, mxt_of_match);
-
 static const struct i2c_device_id mxt_id[] = {
 	{ "qt602240_ts", 0 },
 	{ "atmel_mxt_ts", 0 },
 	{ "atmel_mxt_tp", 0 },
+	{ "maxtouch", 0 },
 	{ "mXT224", 0 },
 	{ }
 };
@@ -2286,7 +2281,6 @@ static struct i2c_driver mxt_driver = {
 	.driver = {
 		.name	= "atmel_mxt_ts",
 		.owner	= THIS_MODULE,
-		.of_match_table = of_match_ptr(mxt_of_match),
 		.pm	= &mxt_pm_ops,
 	},
 	.probe		= mxt_probe,
-- 
2.1.0

