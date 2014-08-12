Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754649AbaHLCCD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 22:02:03 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:18686 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754023AbaHLCBV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 22:01:21 -0400
X-AuditID: cbfee61b-f79f86d00000144c-a5-53e9756d51ed
From: y@samsung.com
To: a.zummo@towertech.it
Cc: kgene.kim@samsung.com, kyungmin.park@samsung.com,
        rtc-linux@googlegroups.com, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org,
        Chanwoo Choi <cw00.choi@samsung.com>
Subject: [PATCHv2 2/5] rtc: s3c: Remove warning message when checking coding
 style with checkpatch script
Date: Tue, 12 Aug 2014 11:01:08 +0900
Message-id: <1407808871-6046-3-git-send-email-y@samsung.com>
X-Mailer: git-send-email 1.8.0
In-reply-to: <1407808871-6046-1-git-send-email-y@samsung.com>
References: <y@samsung.com> <1407808871-6046-1-git-send-email-y@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupjluLIzCtJLcpLzFFi42I5/e+xgG5u6ctgg8NLhC2WXLzKbnH9y3NW
	i94FV9kszja9Ybe4vGsOm8WM8/uYLPZ3djA6sHvsmXiSzaNvyypGj+nzfjJ5fN4kF8ASxWWT
	kpqTWZZapG+XwJWx53g7Y8EGtYorjy4wNzAekO9i5OCQEDCReHDGq4uRE8gUk7hwbz1bFyMX
	h5DAIkaJI+/6GCGcJiaJhyd3MII0sAkIS0w9oAXSICIgIbFkzh2wGmaB3YwSk9e8ZAFJCAtk
	S9y7e5MRxGYRUJXY2jGBDcTmFbCRmPFlLjPENjmJD3sesYPYnAK2Er+WrADrFRLwkbg3+Qbr
	BEbeBYwMqxhFUwuSC4qT0nON9IoTc4tL89L1kvNzNzGCQ+mZ9A7GVQ0WhxgFOBiVeHhn/H0R
	LMSaWFZcmXuIUYKDWUmE95jsy2Ah3pTEyqrUovz4otKc1OJDjNIcLErivAdbrQOFBNITS1Kz
	U1MLUotgskwcnFINjAEBzjO5zVodXm6PvpJ+JPZ1nqn1sUXe/w/qb5jxaPamInOTn1NsuBTT
	0id9jX4t4lqdkXlgS7qFWLPNo5nZB5YdZ7nxs+r4plT2ZeUTzPLmzbjzjW1jZsG063XNlraG
	Qov6YlueOv1IZty4fmKnfUHw/0m/I+1N+crN37v7He6J9t1kt6P5tRJLcUaioRZzUXEiAJSI
	PMQhAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Chanwoo Choi <cw00.choi@samsung.com>

This patch remove warning message when checking codeing style with checkpatch
script and reduce un-necessary i2c read operation on s3c_rtc_enable.

	WARNING: line over 80 characters
	#406: FILE: drivers/rtc/rtc-s3c.c:406:
	+		if ((readw(info->base + S3C2410_RTCCON) & S3C2410_RTCCON_RTCEN) == 0) {

	WARNING: line over 80 characters
	#414: FILE: drivers/rtc/rtc-s3c.c:414:
	+		if ((readw(info->base + S3C2410_RTCCON) & S3C2410_RTCCON_CNTSEL)) {

	WARNING: line over 80 characters
	#422: FILE: drivers/rtc/rtc-s3c.c:422:
	+		if ((readw(info->base + S3C2410_RTCCON) & S3C2410_RTCCON_CLKRST)) {

	WARNING: Missing a blank line after declarations
	#451: FILE: drivers/rtc/rtc-s3c.c:451:
	+	struct s3c_rtc_drv_data *data;
	+	if (pdev->dev.of_node) {

	WARNING: Missing a blank line after declarations
	#453: FILE: drivers/rtc/rtc-s3c.c:453:
	+		const struct of_device_id *match;
	+		match = of_match_node(s3c_rtc_dt_match, pdev->dev.of_node);

	WARNING: DT compatible string "samsung,s3c2416-rtc" appears un-documented -- check ./Documentation/devicetree/bindings/
	#650: FILE: drivers/rtc/rtc-s3c.c:650:
	+		.compatible = "samsung,s3c2416-rtc",

	WARNING: DT compatible string "samsung,s3c2443-rtc" appears un-documented -- check ./Documentation/devicetree/bindings/
	#653: FILE: drivers/rtc/rtc-s3c.c:653:
	+		.compatible = "samsung,s3c2443-rtc",

Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 Documentation/devicetree/bindings/rtc/s3c-rtc.txt |  2 ++
 drivers/rtc/rtc-s3c.c                             | 26 ++++++++++++-----------
 2 files changed, 16 insertions(+), 12 deletions(-)

diff --git a/Documentation/devicetree/bindings/rtc/s3c-rtc.txt b/Documentation/devicetree/bindings/rtc/s3c-rtc.txt
index 7ac7259..06db446 100644
--- a/Documentation/devicetree/bindings/rtc/s3c-rtc.txt
+++ b/Documentation/devicetree/bindings/rtc/s3c-rtc.txt
@@ -3,6 +3,8 @@
 Required properties:
 - compatible: should be one of the following.
     * "samsung,s3c2410-rtc" - for controllers compatible with s3c2410 rtc.
+    * "samsung,s3c2416-rtc" - for controllers compatible with s3c2416 rtc.
+    * "samsung,s3c2443-rtc" - for controllers compatible with s3c2443 rtc.
     * "samsung,s3c6410-rtc" - for controllers compatible with s3c6410 rtc.
 - reg: physical base address of the controller and length of memory mapped
   region.
diff --git a/drivers/rtc/rtc-s3c.c b/drivers/rtc/rtc-s3c.c
index 1d9e158..d8f25bd 100644
--- a/drivers/rtc/rtc-s3c.c
+++ b/drivers/rtc/rtc-s3c.c
@@ -400,28 +400,28 @@ static const struct rtc_class_ops s3c_rtcops = {
 
 static void s3c_rtc_enable(struct s3c_rtc *info, int en)
 {
-	unsigned int tmp;
+	unsigned int con, tmp;
 
 	if (!info->base)
 		return;
 
 	clk_enable(info->rtc_clk);
+
+	con = readw(info->base + S3C2410_RTCCON);
 	if (!en) {
-		tmp = readw(info->base + S3C2410_RTCCON);
 		if (info->cpu_type == TYPE_S3C64XX)
-			tmp &= ~S3C64XX_RTCCON_TICEN;
-		tmp &= ~S3C2410_RTCCON_RTCEN;
-		writew(tmp, info->base + S3C2410_RTCCON);
+			con &= ~S3C64XX_RTCCON_TICEN;
+		con &= ~S3C2410_RTCCON_RTCEN;
+		writew(con, info->base + S3C2410_RTCCON);
 
 		if (info->cpu_type != TYPE_S3C64XX) {
-			tmp = readb(info->base + S3C2410_TICNT);
-			tmp &= ~S3C2410_TICNT_ENABLE;
-			writeb(tmp, info->base + S3C2410_TICNT);
+			con = readb(info->base + S3C2410_TICNT);
+			con &= ~S3C2410_TICNT_ENABLE;
+			writeb(con, info->base + S3C2410_TICNT);
 		}
 	} else {
 		/* re-enable the device, and check it is ok */
-
-		if ((readw(info->base + S3C2410_RTCCON) & S3C2410_RTCCON_RTCEN) == 0) {
+		if ((con & S3C2410_RTCCON_RTCEN) == 0) {
 			dev_info(info->dev, "rtc disabled, re-enabling\n");
 
 			tmp = readw(info->base + S3C2410_RTCCON);
@@ -429,7 +429,7 @@ static void s3c_rtc_enable(struct s3c_rtc *info, int en)
 				info->base + S3C2410_RTCCON);
 		}
 
-		if ((readw(info->base + S3C2410_RTCCON) & S3C2410_RTCCON_CNTSEL)) {
+		if (con & S3C2410_RTCCON_CNTSEL) {
 			dev_info(info->dev, "removing RTCCON_CNTSEL\n");
 
 			tmp = readw(info->base + S3C2410_RTCCON);
@@ -437,7 +437,7 @@ static void s3c_rtc_enable(struct s3c_rtc *info, int en)
 				info->base + S3C2410_RTCCON);
 		}
 
-		if ((readw(info->base + S3C2410_RTCCON) & S3C2410_RTCCON_CLKRST)) {
+		if (con & S3C2410_RTCCON_CLKRST) {
 			dev_info(info->dev, "removing RTCCON_CLKRST\n");
 
 			tmp = readw(info->base + S3C2410_RTCCON);
@@ -466,8 +466,10 @@ static inline int s3c_rtc_get_driver_data(struct platform_device *pdev)
 {
 #ifdef CONFIG_OF
 	struct s3c_rtc_drv_data *data;
+
 	if (pdev->dev.of_node) {
 		const struct of_device_id *match;
+
 		match = of_match_node(s3c_rtc_dt_match, pdev->dev.of_node);
 		data = (struct s3c_rtc_drv_data *) match->data;
 		return data->cpu_type;
-- 
1.8.0

