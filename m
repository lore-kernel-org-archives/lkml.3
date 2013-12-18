Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755295Ab3LRPb2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 10:31:28 -0500
Received: from mail1.bemta14.messagelabs.com ([193.109.254.112]:16680 "EHLO
	mail1.bemta14.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755155Ab3LRPb0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 10:31:26 -0500
X-Greylist: delayed 380 seconds by postgrey-1.27 at vger.kernel.org; Wed, 18 Dec 2013 10:31:26 EST
X-Env-Sender: anthony.olech.opensource@diasemi.com
X-Msg-Ref: server-12.tower-194.messagelabs.com!1387380303!12663685!1
X-Originating-IP: [82.210.246.133]
X-StarScan-Received: 
X-StarScan-Version: 6.9.16; banners=-,-,-
X-VirusChecked: Checked
Message-ID: <201312181524.rBIFOv96017094@swsrvapps-02.lan>
From: Anthony Olech <anthony.olech.opensource@diasemi.com>
Date: Wed, 18 Dec 2013 15:21:13 +0000
Subject: [PATCH V1] fix adc to voltage calculation in da9052 power driver
To: Anton Vorontsov <anton@enomsg.org>, David Woodhouse <dwmw2@infradead.org>
CC: "open list:HARDWARE MONITORING" <lm-sensors@lm-sensors.org>,
        open list <linux-kernel@vger.kernel.org>,
        David Dajun Chen <david.chen@diasemi.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The ADC resolution of the PMIC is 10-bits, this means that the maximum
possible value is 1023 and not the 1024 as in the code.

Signed-off-by: Anthony Olech <anthony.olech.opensource@diasemi.com>
---
This patch is relative to linux-next repository tag next-20131218

 drivers/power/da9052-battery.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/power/da9052-battery.c b/drivers/power/da9052-battery.c
index f8f4c0f..8f0f259 100644
--- a/drivers/power/da9052-battery.c
+++ b/drivers/power/da9052-battery.c
@@ -178,7 +178,7 @@ struct da9052_battery {
 
 static inline int volt_reg_to_mV(int value)
 {
-	return ((value * 1000) / 512) + 2500;
+	return DIV_ROUND_CLOSEST(value * 2000, 1023) + 2500;
 }
 
 static inline int ichg_reg_to_mA(int value)
-- 
end-of-patch for fix adc to voltage calculation in da9052 power driver V1

