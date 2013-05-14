Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756572Ab3ENIOF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 04:14:05 -0400
Received: from cpsmtpb-ews05.kpnxchange.com ([213.75.39.8]:57800 "EHLO
	cpsmtpb-ews05.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751102Ab3ENIOC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 04:14:02 -0400
Message-ID: <1368519240.1350.91.camel@x61.thuisdomein>
Subject: [PATCH v2] Blackfin: bf537: rename "CONFIG_ADT7310" and friends
From: Paul Bolle <pebolle@tiscali.nl>
To: Mike Frysinger <vapier@gentoo.org>
Cc: Lars-Peter Clausen <lars@metafoo.de>, Jonathan Cameron <jic23@kernel.org>,
        uclinux-dist-devel@blackfin.uclinux.org, linux-kernel@vger.kernel.org
Date: Tue, 14 May 2013 10:14:00 +0200
In-Reply-To: <1368479743.1350.79.camel@x61.thuisdomein>
References: <1368479743.1350.79.camel@x61.thuisdomein>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 14 May 2013 08:14:00.0641 (UTC) FILETIME=[FD4FA310:01CE507A]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In v3.10-rc1 the Analog Devices ADT7310/ADT7410 temperature sensor
driver was removed as an IIO driver. But it was apparently overlooked to
rename four references to CONFIG_ADT7310 and CONFIG_ADT7410 to
CONFIG_SENSORS_ADT7310 and CONFIG_SENSORS_ADT7410 respectively. Do so
now. Use the IS_ENABLED() macro, while we're at it.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
0) The previous version ("Blackfin: bf537: rename "CONFIG_ADT7410"")
assumed an earlier patch had been applied upstream. That patch can be
found at https://lkml.org/lkml/2013/3/25/194 . But it is actually only
applied locally, on a branch that I use to do patches like these. It was
trivial to squash both patches into one patch.

1) Still untested. The choice for SENSORS_ADT7310 and SENSORS_ADT7410 is
still just educated guesswork.

2) It was commit cddc1424f39e7c04045a6431eaf13a003fb8335a ("staging:iio:
Remove adt7410 driver") that triggered this patch.

 arch/blackfin/mach-bf537/boards/stamp.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/blackfin/mach-bf537/boards/stamp.c b/arch/blackfin/mach-bf537/boards/stamp.c
index 759a430..90d2ab1 100644
--- a/arch/blackfin/mach-bf537/boards/stamp.c
+++ b/arch/blackfin/mach-bf537/boards/stamp.c
@@ -701,7 +701,7 @@ static struct bfin5xx_spi_chip ad7816_spi_chip_info = {
 };
 #endif
 
-#if defined(CONFIG_ADT7310) || defined(CONFIG_ADT7310_MODULE)
+#if IS_ENABLED(CONFIG_SENSORS_ADT7310)
 static unsigned long adt7310_platform_data[3] = {
 /* INT bound temperature alarm event. line 1 */
 	IRQ_PG4, IRQF_TRIGGER_LOW,
@@ -1063,7 +1063,7 @@ static struct spi_board_info bfin_spi_board_info[] __initdata = {
 	},
 #endif
 
-#if defined(CONFIG_ADT7310) || defined(CONFIG_ADT7310_MODULE)
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

