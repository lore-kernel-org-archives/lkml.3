Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752056Ab3KSKW1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 05:22:27 -0500
Received: from mail-wi0-f175.google.com ([209.85.212.175]:62982 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751869Ab3KSKWP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 05:22:15 -0500
From: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali.rohar@gmail.com>
To: Anton Vorontsov <anton@enomsg.org>, David Woodhouse <dwmw2@infradead.org>,
        Tony Lindgren <tony@atomide.com>,
        Russell King <linux@arm.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        freemangordon@abv.bg, aaro.koskinen@iki.fi, pavel@ucw.cz,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali.rohar@gmail.com>
Subject: [PATCH v2 3/3] RX-51: Add platform data for bq24150a charger
Date: Tue, 19 Nov 2013 11:18:05 +0100
Message-Id: <1384856285-19593-4-git-send-email-pali.rohar@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1384856285-19593-1-git-send-email-pali.rohar@gmail.com>
References: <1378630239-10006-1-git-send-email-pali.rohar@gmail.com>
 <1384856285-19593-1-git-send-email-pali.rohar@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch will register bq24150a charger in RX-51 board data.

So finally charging battery on Nokia N900 (RX-51) working
automatically without any proprietary Nokia bits in userspace.

Signed-off-by: Pali Rohár <pali.rohar@gmail.com>
---
 arch/arm/mach-omap2/board-rx51-peripherals.c |   17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

diff --git a/arch/arm/mach-omap2/board-rx51-peripherals.c b/arch/arm/mach-omap2/board-rx51-peripherals.c
index 70fcaff..95e6638 100644
--- a/arch/arm/mach-omap2/board-rx51-peripherals.c
+++ b/arch/arm/mach-omap2/board-rx51-peripherals.c
@@ -25,6 +25,7 @@
 #include <linux/gpio_keys.h>
 #include <linux/mmc/host.h>
 #include <linux/power/isp1704_charger.h>
+#include <linux/power/bq2415x_charger.h>
 #include <linux/platform_data/spi-omap2-mcspi.h>
 #include <linux/platform_data/mtd-onenand-omap2.h>
 #include <linux/hsi/hsi.h>
@@ -1275,6 +1276,16 @@ static struct aic3x_pdata rx51_aic3x_data2 = {
 	.gpio_reset = 60,
 };
 
+static struct bq2415x_platform_data rx51_bq24150a_platform_data = {
+	.current_limit = 100,			/* mA */
+	.weak_battery_voltage = 3400,		/* mV */
+	.battery_regulation_voltage = 4200,	/* mV */
+	.charge_current = 650,			/* mA */
+	.termination_current = 100,		/* mA */
+	.resistor_sense = 68,			/* m ohm */
+	.notify_device = "isp1704",
+};
+
 static struct i2c_board_info __initdata rx51_peripherals_i2c_board_info_2[] = {
 	{
 		I2C_BOARD_INFO("tlv320aic3x", 0x18),
@@ -1302,7 +1313,11 @@ static struct i2c_board_info __initdata rx51_peripherals_i2c_board_info_2[] = {
 	{
 		I2C_BOARD_INFO("tpa6130a2", 0x60),
 		.platform_data = &rx51_tpa6130a2_data,
-	}
+	},
+	{
+		I2C_BOARD_INFO("bq24150a", 0x6b),
+		.platform_data = &rx51_bq24150a_platform_data,
+	},
 };
 
 static struct i2c_board_info __initdata rx51_peripherals_i2c_board_info_3[] = {
-- 
1.7.9.5

