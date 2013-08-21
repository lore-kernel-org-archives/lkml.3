Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753314Ab3HUWpg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 18:45:36 -0400
Received: from mail-ee0-f48.google.com ([74.125.83.48]:41398 "EHLO
	mail-ee0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753284Ab3HUWp3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 18:45:29 -0400
From: Marek Belisko <marek.belisko@open-nandra.com>
To: anton@enomsg.org, dwmw2@infradead.org
Cc: linux-kernel@vger.kernel.org, pali.rohar@gmail.com,
        Marek Belisko <marek.belisko@open-nandra.com>
Subject: [PATCH] power: rx51_battery: Replace hardcoded channels values.
Date: Thu, 22 Aug 2013 00:45:10 +0200
Message-Id: <1377125110-16886-1-git-send-email-marek.belisko@open-nandra.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In twl4030_madc header exist defines for fixed channels
+ add rx51 specific channels and replace all hardcoded channels
values.

Signed-off-by: Marek Belisko <marek.belisko@open-nandra.com>
---
 drivers/power/rx51_battery.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/power/rx51_battery.c b/drivers/power/rx51_battery.c
index 8a6288d..03f5761 100644
--- a/drivers/power/rx51_battery.c
+++ b/drivers/power/rx51_battery.c
@@ -25,6 +25,10 @@
 #include <linux/slab.h>
 #include <linux/i2c/twl4030-madc.h>
 
+/* RX51 specific channels */
+#define TWL4030_MADC_BTEMP_RX51	TWL4030_MADC_ADCIN0
+#define TWL4030_MADC_BCI_RX51	TWL4030_MADC_ADCIN4
+
 struct rx51_device_info {
 	struct device *dev;
 	struct power_supply bat;
@@ -37,7 +41,7 @@ static int rx51_battery_read_adc(int channel)
 {
 	struct twl4030_madc_request req;
 
-	req.channels = 1 << channel;
+	req.channels = channel;
 	req.do_avg = 1;
 	req.method = TWL4030_MADC_SW1;
 	req.func_cb = NULL;
@@ -56,7 +60,7 @@ static int rx51_battery_read_adc(int channel)
  */
 static int rx51_battery_read_voltage(struct rx51_device_info *di)
 {
-	int voltage = rx51_battery_read_adc(12);
+	int voltage = rx51_battery_read_adc(TWL4030_MADC_VBAT);
 
 	if (voltage < 0)
 		return voltage;
@@ -108,7 +112,7 @@ static int rx51_battery_read_temperature(struct rx51_device_info *di)
 {
 	int min = 0;
 	int max = ARRAY_SIZE(rx51_temp_table2) - 1;
-	int raw = rx51_battery_read_adc(0);
+	int raw = rx51_battery_read_adc(TWL4030_MADC_BTEMP_RX51);
 
 	/* Zero and negative values are undefined */
 	if (raw <= 0)
@@ -142,7 +146,7 @@ static int rx51_battery_read_temperature(struct rx51_device_info *di)
  */
 static int rx51_battery_read_capacity(struct rx51_device_info *di)
 {
-	int capacity = rx51_battery_read_adc(4);
+	int capacity = rx51_battery_read_adc(TWL4030_MADC_BCI_RX51);
 
 	if (capacity < 0)
 		return capacity;
-- 
1.8.1.2

