Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753872Ab3AXKzf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 05:55:35 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:49429 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753749Ab3AXKyx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 05:54:53 -0500
From: "Vishwanathrao Badarkhe, Manish" <manishv.b@ti.com>
To: <devicetree-discuss@lists.ozlabs.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <davinci-linux-open-source@linux.davincidsp.com>
CC: <anilkumar@ti.com>, <tony@atomide.com>, <hs@denx.de>,
        <broonie@opensource.wolfsonmicro.com>, <lrg@ti.com>,
        <sameo@linux.intel.com>, <khilman@ti.com>, <linux@arm.linux.org.uk>,
        <rob@landley.net>, <rob.herring@calxeda.com>,
        <grant.likely@secretlab.ca>, <manishv.b@ti.com>
Subject: [PATCH 3/6] davinci: mfd: tps6507x: add device-tree support.
Date: Thu, 24 Jan 2013 16:25:17 +0530
Message-ID: <1359024920-32190-4-git-send-email-manishv.b@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1359024920-32190-1-git-send-email-manishv.b@ti.com>
References: <1359024920-32190-1-git-send-email-manishv.b@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add device tree based initialization support for TI's
tps6507x mfd device.

Signed-off-by: Vishwanathrao Badarkhe, Manish <manishv.b@ti.com>
---
 drivers/mfd/tps6507x.c |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/drivers/mfd/tps6507x.c b/drivers/mfd/tps6507x.c
index 409afa2..5ad4b77 100644
--- a/drivers/mfd/tps6507x.c
+++ b/drivers/mfd/tps6507x.c
@@ -19,6 +19,7 @@
 #include <linux/init.h>
 #include <linux/slab.h>
 #include <linux/i2c.h>
+#include <linux/of_device.h>
 #include <linux/mfd/core.h>
 #include <linux/mfd/tps6507x.h>
 
@@ -116,11 +117,19 @@ static const struct i2c_device_id tps6507x_i2c_id[] = {
 };
 MODULE_DEVICE_TABLE(i2c, tps6507x_i2c_id);
 
+#ifdef CONFIG_OF
+static struct of_device_id tps6507x_of_match[] = {
+	{.compatible = "ti,tps6507x", },
+	{},
+};
+MODULE_DEVICE_TABLE(of, tps6507x_of_match);
+#endif
 
 static struct i2c_driver tps6507x_i2c_driver = {
 	.driver = {
 		   .name = "tps6507x",
 		   .owner = THIS_MODULE,
+		   .of_match_table = of_match_ptr(tps6507x_of_match),
 	},
 	.probe = tps6507x_i2c_probe,
 	.remove = tps6507x_i2c_remove,
-- 
1.7.4.1

