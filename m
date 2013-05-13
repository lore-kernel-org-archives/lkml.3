Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753911Ab3EMVPq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 17:15:46 -0400
Received: from cpsmtpb-ews10.kpnxchange.com ([213.75.39.15]:56292 "EHLO
	cpsmtpb-ews10.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752618Ab3EMVPp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 17:15:45 -0400
Message-ID: <1368479743.1350.79.camel@x61.thuisdomein>
Subject: [PATCH] Blackfin: bf537: rename "CONFIG_ADT7410"
From: Paul Bolle <pebolle@tiscali.nl>
To: Mike Frysinger <vapier@gentoo.org>
Cc: Lars-Peter Clausen <lars@metafoo.de>, Jonathan Cameron <jic23@kernel.org>,
        uclinux-dist-devel@blackfin.uclinux.org, linux-kernel@vger.kernel.org
Date: Mon, 13 May 2013 23:15:43 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 13 May 2013 21:15:43.0808 (UTC) FILETIME=[075D3400:01CE501F]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In v3.10-rc1 the Analog Devices ADT7310/ADT7410 temperature sensor
driver was removed as an IIO driver. But it was apparently overlooked
to rename four references to CONFIG_ADT7410 to either
CONFIG_SENSORS_ADT7310 or CONFIG_SENSORS_ADT7410. Do so now. Use the
IS_ENABLED() macro, while we're at it.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
0) Untested. The choice for SENSORS_ADT7310 and SENSORS_ADT7410 is just
educated guesswork.

1) It was commit cddc1424f39e7c04045a6431eaf13a003fb8335a ("staging:iio:
Remove adt7410 driver") that triggered this patch.

 arch/blackfin/mach-bf537/boards/stamp.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/blackfin/mach-bf537/boards/stamp.c b/arch/blackfin/mach-bf537/boards/stamp.c
index 1cbe46e..90d2ab1 100644
--- a/arch/blackfin/mach-bf537/boards/stamp.c
+++ b/arch/blackfin/mach-bf537/boards/stamp.c
@@ -701,7 +701,7 @@ static struct bfin5xx_spi_chip ad7816_spi_chip_info = {
 };
 #endif
 
-#if defined(CONFIG_ADT7410) || defined(CONFIG_ADT7410_MODULE)
+#if IS_ENABLED(CONFIG_SENSORS_ADT7310)
 static unsigned long adt7310_platform_data[3] = {
 /* INT bound temperature alarm event. line 1 */
 	IRQ_PG4, IRQF_TRIGGER_LOW,
@@ -1063,7 +1063,7 @@ static struct spi_board_info bfin_spi_board_info[] __initdata = {
 	},
 #endif
 
-#if defined(CONFIG_ADT7410) || defined(CONFIG_ADT7410_MODULE)
+#if IS_ENABLED(CONFIG_SENSORS_ADT7310)
 	{
 		.modalias = "adt7310",
 		.max_speed_hz = 1000000,
@@ -2161,7 +2161,7 @@ static struct platform_device ad5398_userspace_consumer_device = {
 #endif
 #endif
 
-#if defined(CONFIG_ADT7410) || defined(CONFIG_ADT7410_MODULE)
+#if IS_ENABLED(CONFIG_SENSORS_ADT7410)
 /* INT bound temperature alarm event. line 1 */
 static unsigned long adt7410_platform_data[2] = {
 	IRQ_PG4, IRQF_TRIGGER_LOW,
@@ -2229,7 +2229,7 @@ static struct i2c_board_info __initdata bfin_i2c_board_info[] = {
 	},
 #endif
 
-#if defined(CONFIG_ADT7410) || defined(CONFIG_ADT7410_MODULE)
+#if IS_ENABLED(CONFIG_SENSORS_ADT7410)
 	{
 		I2C_BOARD_INFO("adt7410", 0x48),
 		/* CT critical temperature event. line 0 */
-- 
1.7.11.7

