Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754454AbaKXP6t (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 10:58:49 -0500
Received: from hosting.pavoucek.net ([46.28.107.168]:60868 "EHLO
	hosting.pavoucek.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753749AbaKXP6o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 10:58:44 -0500
From: Tomas Novotny <tomas@novotny.cz>
To: Alessandro Zummo <a.zummo@towertech.it>, rtc-linux@googlegroups.com
Cc: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tomas Novotny <tomas@novotny.cz>
Subject: [PATCH 4/4] rtc: ds1307: add device tree support
Date: Mon, 24 Nov 2014 16:49:24 +0100
Message-Id: <1416844164-16782-5-git-send-email-tomas@novotny.cz>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <1416844164-16782-1-git-send-email-tomas@novotny.cz>
References: <1416844164-16782-1-git-send-email-tomas@novotny.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Note that alarm interrupt and trickle charger are not handled (I have no
hardware with these features).

Signed-off-by: Tomas Novotny <tomas@novotny.cz>
---

Only the "common" compatible string for that driver (maxim,ds1307) is
documented, so checkpatch complains for the rest. If it is better to document
every compatible, I will post a new series with documentation files pointing to
the maxim,ds1307.txt.

 drivers/rtc/rtc-ds1307.c | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/drivers/rtc/rtc-ds1307.c b/drivers/rtc/rtc-ds1307.c
index 4ffabb3..3bb6a20 100644
--- a/drivers/rtc/rtc-ds1307.c
+++ b/drivers/rtc/rtc-ds1307.c
@@ -18,6 +18,7 @@
 #include <linux/string.h>
 #include <linux/rtc.h>
 #include <linux/bcd.h>
+#include <linux/of.h>
 #include <linux/rtc/ds1307.h>
 
 /*
@@ -1242,10 +1243,31 @@ static int ds1307_remove(struct i2c_client *client)
 	return 0;
 }
 
+#ifdef CONFIG_OF
+static const struct of_device_id ds1307_driver_dt_ids[] = {
+	/* driver_data are passed through ds1307_id */
+	{ .compatible = "maxim,ds1307" },
+	{ .compatible = "maxim,ds1337" },
+	{ .compatible = "maxim,ds1338" },
+	{ .compatible = "maxim,ds1339" },
+	{ .compatible = "maxim,ds1388" },
+	{ .compatible = "maxim,ds1340" },
+	{ .compatible = "maxim,ds3231" },
+	{ .compatible = "st,m41t00" },
+	{ .compatible = "microchip,mcp7940x" },
+	{ .compatible = "microchip,mcp7941x" },
+	{ .compatible = "pericom,pt7c4338" },
+	{ .compatible = "epson,rx8025" },
+	{ }
+};
+MODULE_DEVICE_TABLE(of, ds1307_driver_dt_ids);
+#endif
+
 static struct i2c_driver ds1307_driver = {
 	.driver = {
 		.name	= "rtc-ds1307",
 		.owner	= THIS_MODULE,
+		.of_match_table	= of_match_ptr(ds1307_driver_dt_ids),
 	},
 	.probe		= ds1307_probe,
 	.remove		= ds1307_remove,
-- 
2.1.2

