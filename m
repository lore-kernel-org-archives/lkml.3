Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751955AbaH1OgL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 10:36:11 -0400
Received: from mail-qa0-f43.google.com ([209.85.216.43]:46826 "EHLO
	mail-qa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751801AbaH1OgI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 10:36:08 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: lee.jones@linaro.org, kernel@stlinux.com, wsa@the-dreams.de,
        grant.likely@linaro.org, linux-i2c@vger.kernel.org,
        devicetree@vger.kernel.org, linus.walleij@linaro.org
Subject: [PATCH 7/8] mfd: 88pm860x: Move over to new I2C device .probe() call
Date: Thu, 28 Aug 2014 15:35:37 +0100
Message-Id: <1409236538-21274-8-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1409236538-21274-1-git-send-email-lee.jones@linaro.org>
References: <1409236538-21274-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As part of an effort to rid the mostly unused second parameter for I2C
related .probe() functions and to conform to other existing frameworks
we're moving over to a temporary replacement .probe() call-back.

Acked-by: Grant Likely <grant.likely@linaro.org>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/mfd/88pm860x-core.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/mfd/88pm860x-core.c b/drivers/mfd/88pm860x-core.c
index 3a26045..3372c47 100644
--- a/drivers/mfd/88pm860x-core.c
+++ b/drivers/mfd/88pm860x-core.c
@@ -1134,8 +1134,7 @@ static int pm860x_dt_init(struct device_node *np,
 	return 0;
 }
 
-static int pm860x_probe(struct i2c_client *client,
-				  const struct i2c_device_id *id)
+static int pm860x_probe(struct i2c_client *client)
 {
 	struct pm860x_platform_data *pdata = dev_get_platdata(&client->dev);
 	struct device_node *node = client->dev.of_node;
@@ -1262,7 +1261,7 @@ static struct i2c_driver pm860x_driver = {
 		.pm     = &pm860x_pm_ops,
 		.of_match_table	= pm860x_dt_ids,
 	},
-	.probe		= pm860x_probe,
+	.probe2		= pm860x_probe,
 	.remove		= pm860x_remove,
 	.id_table	= pm860x_id_table,
 };
-- 
1.9.1

