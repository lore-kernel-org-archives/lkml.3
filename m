Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755371Ab3LRPcD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 10:32:03 -0500
Received: from mail1.bemta3.messagelabs.com ([195.245.230.168]:61329 "EHLO
	mail1.bemta3.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754888Ab3LRPcA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 10:32:00 -0500
X-Greylist: delayed 431 seconds by postgrey-1.27 at vger.kernel.org; Wed, 18 Dec 2013 10:32:00 EST
X-Env-Sender: anthony.olech.opensource@diasemi.com
X-Msg-Ref: server-4.tower-38.messagelabs.com!1387380286!2474455!1
X-Originating-IP: [82.210.246.133]
X-StarScan-Received: 
X-StarScan-Version: 6.9.16; banners=-,-,-
X-VirusChecked: Checked
Message-ID: <201312181524.rBIFOhNp017016@swsrvapps-02.lan>
From: Anthony Olech <anthony.olech.opensource@diasemi.com>
Date: Wed, 18 Dec 2013 15:15:31 +0000
Subject: [PATCH V1] fix adc to voltage calculation in da9052 hwmon driver
To: Jean Delvare <khali@linux-fr.org>, Guenter Roeck <linux@roeck-us.net>
CC: "open list:HARDWARE MONITORING" <lm-sensors@lm-sensors.org>,
        open list <linux-kernel@vger.kernel.org>,
        David Dajun Chen <david.chen@diasemi.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The ADC resolution of the PMIC is 10-bits, this means that the maximum
possible value is 1023 and not the 1024 as originally in the code.

Signed-off-by: Anthony Olech <anthony.olech.opensource@diasemi.com>
---
This patch is relative to linux-next repository tag next-20131218

 drivers/hwmon/da9052-hwmon.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/hwmon/da9052-hwmon.c b/drivers/hwmon/da9052-hwmon.c
index 960fac3..afd3104 100644
--- a/drivers/hwmon/da9052-hwmon.c
+++ b/drivers/hwmon/da9052-hwmon.c
@@ -45,7 +45,7 @@ static const char * const input_names[] = {
 /* Conversion function for VDDOUT and VBAT */
 static inline int volt_reg_to_mv(int value)
 {
-	return DIV_ROUND_CLOSEST(value * 1000, 512) + 2500;
+	return DIV_ROUND_CLOSEST(value * 2000, 1023) + 2500;
 }
 
 /* Conversion function for ADC channels 4, 5 and 6 */
@@ -57,7 +57,7 @@ static inline int input_reg_to_mv(int value)
 /* Conversion function for VBBAT */
 static inline int vbbat_reg_to_mv(int value)
 {
-	return DIV_ROUND_CLOSEST(value * 2500, 512);
+	return DIV_ROUND_CLOSEST(value * 5000, 1023);
 }
 
 static inline int da9052_enable_vddout_channel(struct da9052 *da9052)
-- 
end-of-patch for fix adc to voltage calculation in da9052 hwmon driver V1

