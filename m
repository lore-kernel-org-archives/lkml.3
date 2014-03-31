Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754872AbaCaNc7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 09:32:59 -0400
Received: from mail-pd0-f180.google.com ([209.85.192.180]:60435 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753803AbaCaNc4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 09:32:56 -0400
Message-ID: <1396272757.7843.2.camel@phoenix>
Subject: [PATCH 2/2] mfd: bcm590xx: Add missing remove function
From: Axel Lin <axel.lin@ingics.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: Samuel Ortiz <sameo@linux.intel.com>, Matt Porter <mporter@linaro.org>,
        linux-kernel@vger.kernel.org
Date: Mon, 31 Mar 2014 21:32:37 +0800
In-Reply-To: <1396272676.7843.1.camel@phoenix>
References: <1396272676.7843.1.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add missing mfd_remove_devices() call in remove function.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/mfd/bcm590xx.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/mfd/bcm590xx.c b/drivers/mfd/bcm590xx.c
index 40c0dd3..c986149 100644
--- a/drivers/mfd/bcm590xx.c
+++ b/drivers/mfd/bcm590xx.c
@@ -64,6 +64,12 @@ static int bcm590xx_i2c_probe(struct i2c_client *i2c,
 	return ret;
 }
 
+static int bcm590xx_i2c_remove(struct i2c_client *i2c)
+{
+	mfd_remove_devices(&i2c->dev);
+	return 0;
+}
+
 static const struct of_device_id bcm590xx_of_match[] = {
 	{ .compatible = "brcm,bcm59056" },
 	{ }
@@ -83,6 +89,7 @@ static struct i2c_driver bcm590xx_i2c_driver = {
 		   .of_match_table = of_match_ptr(bcm590xx_of_match),
 	},
 	.probe = bcm590xx_i2c_probe,
+	.remove = bcm590xx_i2c_remove,
 	.id_table = bcm590xx_i2c_id,
 };
 module_i2c_driver(bcm590xx_i2c_driver);
-- 
1.8.3.2



