Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933483AbaJURwj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 13:52:39 -0400
Received: from mail-lb0-f169.google.com ([209.85.217.169]:35072 "EHLO
	mail-lb0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933374AbaJURoz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 13:44:55 -0400
X-Google-Original-Sender: <johan@hovold.com>
From: Johan Hovold <johan@kernel.org>
To: Alessandro Zummo <a.zummo@towertech.it>, Tony Lindgren <tony@atomide.com>,
        =?UTF-8?q?Beno=C3=AEt=20Cousson?= <bcousson@baylibre.com>,
        Felipe Balbi <balbi@ti.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Lokesh Vutla <lokeshvutla@ti.com>, Guenter Roeck <linux@roeck-us.net>,
        nsekhar@ti.com, t-kristo@ti.com, j-keerthy@ti.com,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org, rtc-linux@googlegroups.com,
        linux-kernel@vger.kernel.org, Johan Hovold <johan@kernel.org>
Subject: [PATCH v2 10/20] rtc: omap: remove DRIVER_NAME macro
Date: Tue, 21 Oct 2014 19:37:56 +0200
Message-Id: <1413913086-12730-11-git-send-email-johan@kernel.org>
X-Mailer: git-send-email 2.0.4
In-Reply-To: <1413913086-12730-1-git-send-email-johan@kernel.org>
References: <1412881594-25678-1-git-send-email-johan@kernel.org>
 <1413913086-12730-1-git-send-email-johan@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove DRIVER_NAME macro which was used for unrelated strings (e.g.
id-table entry and module name), but not for related ones (e.g. module
name and alias).

Also move the module alias to the other module-info entries.

Signed-off-by: Johan Hovold <johan@kernel.org>
---
 drivers/rtc/rtc-omap.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/rtc/rtc-omap.c b/drivers/rtc/rtc-omap.c
index 1da610b8981f..f70ae660368b 100644
--- a/drivers/rtc/rtc-omap.c
+++ b/drivers/rtc/rtc-omap.c
@@ -39,8 +39,6 @@
  * the SoC). See the BOARD-SPECIFIC CUSTOMIZATION comment.
  */
 
-#define	DRIVER_NAME			"omap_rtc"
-
 /* RTC registers */
 #define OMAP_RTC_SECONDS_REG		0x00
 #define OMAP_RTC_MINUTES_REG		0x04
@@ -360,7 +358,7 @@ static struct rtc_class_ops omap_rtc_ops = {
 
 static const struct platform_device_id omap_rtc_devtype[] = {
 	{
-		.name	= DRIVER_NAME,
+		.name	= "omap_rtc",
 	},
 	[OMAP_RTC_DATA_AM3352_IDX] = {
 		.name	= "am3352-rtc",
@@ -587,12 +585,11 @@ static void omap_rtc_shutdown(struct platform_device *pdev)
 	rtc_write(rtc, OMAP_RTC_INTERRUPTS_REG, 0);
 }
 
-MODULE_ALIAS("platform:omap_rtc");
 static struct platform_driver omap_rtc_driver = {
 	.remove		= __exit_p(omap_rtc_remove),
 	.shutdown	= omap_rtc_shutdown,
 	.driver		= {
-		.name	= DRIVER_NAME,
+		.name	= "omap_rtc",
 		.owner	= THIS_MODULE,
 		.pm	= &omap_rtc_pm_ops,
 		.of_match_table = omap_rtc_of_match,
@@ -602,5 +599,6 @@ static struct platform_driver omap_rtc_driver = {
 
 module_platform_driver_probe(omap_rtc_driver, omap_rtc_probe);
 
+MODULE_ALIAS("platform:omap_rtc");
 MODULE_AUTHOR("George G. Davis (and others)");
 MODULE_LICENSE("GPL");
-- 
2.0.4

