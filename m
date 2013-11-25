Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753354Ab3KYMXV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 07:23:21 -0500
Received: from mail-bk0-f51.google.com ([209.85.214.51]:39612 "EHLO
	mail-bk0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751693Ab3KYMXO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 07:23:14 -0500
From: Thierry Reding <thierry.reding@gmail.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] mfd: cros ec: i2c: Use consistent function names
Date: Mon, 25 Nov 2013 13:22:31 +0100
Message-Id: <1385382151-28079-2-git-send-email-treding@nvidia.com>
X-Mailer: git-send-email 1.8.4.2
In-Reply-To: <1385382151-28079-1-git-send-email-treding@nvidia.com>
References: <1385382151-28079-1-git-send-email-treding@nvidia.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rename cros_ec_{probe,remove}_i2c() to cros_ec_i2c_{probe,remove}() for
consistency.

Signed-off-by: Thierry Reding <treding@nvidia.com>
---
 drivers/mfd/cros_ec_i2c.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/mfd/cros_ec_i2c.c b/drivers/mfd/cros_ec_i2c.c
index 123044608b63..4f71be99a183 100644
--- a/drivers/mfd/cros_ec_i2c.c
+++ b/drivers/mfd/cros_ec_i2c.c
@@ -120,7 +120,7 @@ static int cros_ec_command_xfer(struct cros_ec_device *ec_dev,
 	return ret;
 }
 
-static int cros_ec_probe_i2c(struct i2c_client *client,
+static int cros_ec_i2c_probe(struct i2c_client *client,
 			     const struct i2c_device_id *dev_id)
 {
 	struct device *dev = &client->dev;
@@ -150,7 +150,7 @@ static int cros_ec_probe_i2c(struct i2c_client *client,
 	return 0;
 }
 
-static int cros_ec_remove_i2c(struct i2c_client *client)
+static int cros_ec_i2c_remove(struct i2c_client *client)
 {
 	struct cros_ec_device *ec_dev = i2c_get_clientdata(client);
 
@@ -190,8 +190,8 @@ static struct i2c_driver cros_ec_driver = {
 		.owner	= THIS_MODULE,
 		.pm	= &cros_ec_i2c_pm_ops,
 	},
-	.probe		= cros_ec_probe_i2c,
-	.remove		= cros_ec_remove_i2c,
+	.probe		= cros_ec_i2c_probe,
+	.remove		= cros_ec_i2c_remove,
 	.id_table	= cros_ec_i2c_id,
 };
 
-- 
1.8.4.2

