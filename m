Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752043AbaFJJp0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 05:45:26 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:48742 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751867AbaFJJpS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 05:45:18 -0400
From: Juergen Borleis <jbe@pengutronix.de>
To: linux-kernel@vger.kernel.org
Cc: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>, kernel@pengutronix.de
Subject: [PATCH 1/7] bq27425: fix register offset for SOC on bq27425
Date: Tue, 10 Jun 2014 11:44:47 +0200
Message-Id: <1402393493-3559-2-git-send-email-jbe@pengutronix.de>
X-Mailer: git-send-email 2.0.0.rc2
In-Reply-To: <1402393493-3559-1-git-send-email-jbe@pengutronix.de>
References: <1402393493-3559-1-git-send-email-jbe@pengutronix.de>
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:a236:9fff:fe00:814
X-SA-Exim-Mail-From: jbe@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The SOC register is at offset 0x1C according to its datasheet. Due to the
fact the access routine subtracts BQ27425_REG_OFFSET from this value we need
0x20 to reach the real offset at 0x1C.

This offset is valid for the following devices:
 - BQ27425-G1, firmware device info 0x0410
 - BQ27425-G2a, firmware device info 0x0425

Signed-off-by: Juergen Borleis <jbe@pengutronix.de>
---
 drivers/power/bq27x00_battery.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/power/bq27x00_battery.c b/drivers/power/bq27x00_battery.c
index b309713..f3de29e 100644
--- a/drivers/power/bq27x00_battery.c
+++ b/drivers/power/bq27x00_battery.c
@@ -72,7 +72,7 @@
 
 /* bq27425 register addresses are same as bq27x00 addresses minus 4 */
 #define BQ27425_REG_OFFSET		0x04
-#define BQ27425_REG_SOC			0x18 /* Register address plus offset */
+#define BQ27425_REG_SOC			0x20 /* Register address plus offset */
 
 #define BQ27000_RS			20 /* Resistor sense */
 #define BQ27x00_POWER_CONSTANT		(256 * 29200 / 1000)
-- 
2.0.0.rc2

