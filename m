Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753211AbaGPVbd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 17:31:33 -0400
Received: from 203-174-129-26.bri.static-ipl.aapt.com.au ([203.174.129.26]:32909
	"EHLO bne.vrt.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752132AbaGPVbb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 17:31:31 -0400
From: Stuart Longland <stuartl@vrt.com.au>
To: Roman Fietze <roman.fietze@telemotive.de>
Cc: linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        Mark Rutland <mark.rutland@arm.com>,
        Stuart Longland <stuartl@vrt.com.au>
Subject: [PATCH 1/2] drivers/rtc/rtc-isl12022.c: Device tree support
Date: Thu, 17 Jul 2014 07:31:01 +1000
Message-Id: <1405546262-4333-2-git-send-email-stuartl@vrt.com.au>
X-Mailer: git-send-email 1.8.5.5
In-Reply-To: <1405546262-4333-1-git-send-email-stuartl@vrt.com.au>
References: <20140716085904.GA26951@leverpostej>
 <1405546262-4333-1-git-send-email-stuartl@vrt.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add some support for configuring isl12020/isl12022 devices using the
Device Tree blob.

Signed-off-by: Stuart Longland <stuartl@vrt.com.au>
---
 drivers/rtc/rtc-isl12022.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/rtc/rtc-isl12022.c b/drivers/rtc/rtc-isl12022.c
index 03b8911..59b0ea2 100644
--- a/drivers/rtc/rtc-isl12022.c
+++ b/drivers/rtc/rtc-isl12022.c
@@ -17,6 +17,8 @@
 #include <linux/slab.h>
 #include <linux/module.h>
 #include <linux/err.h>
+#include <linux/of.h>
+#include <linux/of_device.h>
 
 #define DRV_VERSION "0.1"
 
@@ -271,6 +273,13 @@ static int isl12022_probe(struct i2c_client *client,
 	return PTR_ERR_OR_ZERO(isl12022->rtc);
 }
 
+#ifdef CONFIG_OF
+static struct of_device_id isl12022_dt_match[] = {
+	{ .compatible = "isl,isl12022" },
+	{ },
+};
+#endif
+
 static const struct i2c_device_id isl12022_id[] = {
 	{ "isl12022", 0 },
 	{ }
@@ -280,6 +289,7 @@ MODULE_DEVICE_TABLE(i2c, isl12022_id);
 static struct i2c_driver isl12022_driver = {
 	.driver		= {
 		.name	= "rtc-isl12022",
+		.of_match_table = of_match_ptr(isl12022_dt_match),
 	},
 	.probe		= isl12022_probe,
 	.id_table	= isl12022_id,
-- 
1.8.5.5

