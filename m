Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757853Ab3CNNL4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 09:11:56 -0400
Received: from mail-ee0-f53.google.com ([74.125.83.53]:35030 "EHLO
	mail-ee0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757816Ab3CNNLx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 09:11:53 -0400
From: Fabio Porcedda <fabio.porcedda@gmail.com>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-media@vger.kernel.org, linux-ide@vger.kernel.org,
        lm-sensors@lm-sensors.org, linux-input@vger.kernel.org,
        linux-fbdev@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jean Delvare <khali@linux-fr.org>, Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 04/10] drivers: hwmon: use module_platform_driver_probe()
Date: Thu, 14 Mar 2013 14:11:25 +0100
Message-Id: <1363266691-15757-6-git-send-email-fabio.porcedda@gmail.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1363266691-15757-1-git-send-email-fabio.porcedda@gmail.com>
References: <1363266691-15757-1-git-send-email-fabio.porcedda@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch converts the drivers to use the
module_platform_driver_probe() macro which makes the code smaller and
a bit simpler.

Signed-off-by: Fabio Porcedda <fabio.porcedda@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jean Delvare <khali@linux-fr.org>
Cc: Guenter Roeck <linux@roeck-us.net>
Cc: lm-sensors@lm-sensors.org
---
 drivers/hwmon/mc13783-adc.c | 13 +------------
 1 file changed, 1 insertion(+), 12 deletions(-)

diff --git a/drivers/hwmon/mc13783-adc.c b/drivers/hwmon/mc13783-adc.c
index 2a7f331..982d862 100644
--- a/drivers/hwmon/mc13783-adc.c
+++ b/drivers/hwmon/mc13783-adc.c
@@ -273,18 +273,7 @@ static struct platform_driver mc13783_adc_driver = {
 	.id_table	= mc13783_adc_idtable,
 };
 
-static int __init mc13783_adc_init(void)
-{
-	return platform_driver_probe(&mc13783_adc_driver, mc13783_adc_probe);
-}
-
-static void __exit mc13783_adc_exit(void)
-{
-	platform_driver_unregister(&mc13783_adc_driver);
-}
-
-module_init(mc13783_adc_init);
-module_exit(mc13783_adc_exit);
+module_platform_driver_probe(mc13783_adc_driver, mc13783_adc_probe);
 
 MODULE_DESCRIPTION("MC13783 ADC driver");
 MODULE_AUTHOR("Luotao Fu <l.fu@pengutronix.de>");
-- 
1.8.1.5

