Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758029Ab3DDKI3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 06:08:29 -0400
Received: from cpsmtpb-ews04.kpnxchange.com ([213.75.39.7]:60903 "EHLO
	cpsmtpb-ews04.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756855Ab3DDKI1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 06:08:27 -0400
Message-ID: <1365070105.1830.21.camel@x61.thuisdomein>
Subject: [PATCH] Blackfin: bf537: rename "CONFIG_AD7314"
From: Paul Bolle <pebolle@tiscali.nl>
To: Mike Frysinger <vapier@gentoo.org>
Cc: Jonathan Cameron <jic23@cam.ac.uk>,
        Guenter Roeck <guenter.roeck@ericsson.com>,
        Michael Hennerich <michael.hennerich@analog.com>,
        uclinux-dist-devel@blackfin.uclinux.org, linux-kernel@vger.kernel.org
Date: Thu, 04 Apr 2013 12:08:25 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 04 Apr 2013 10:08:25.0177 (UTC) FILETIME=[585EB490:01CE311C]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In v3.2 the Analog Devices AD7314 temperature sensor driver was removed
as an IIO driver and added as a HWMON driver. But it was apparently
overlooked to rename two references to CONFIG_AD7314 to
CONFIG_SENSORS_AD7314. Do so now. Use the IS_ENABLED() macro, while
we're at it.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
0) Entirely untested.

1) See commits 4f3a659581cabf1be441d6467b523be914615496 ("hwmon: AD7314
driver (ported from IIO)") and 48a2c3799b7141c271a771d3249142a104faeefc
("staging:iio:adc:ad7314 removal. Supported via hwmon.") for the two
patches involved.

 arch/blackfin/mach-bf537/boards/stamp.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/blackfin/mach-bf537/boards/stamp.c b/arch/blackfin/mach-bf537/boards/stamp.c
index 23bb55d..b40b849 100644
--- a/arch/blackfin/mach-bf537/boards/stamp.c
+++ b/arch/blackfin/mach-bf537/boards/stamp.c
@@ -681,7 +681,7 @@ static struct bfin5xx_spi_chip ad2s1210_spi_chip_info = {
 };
 #endif
 
-#if defined(CONFIG_AD7314) || defined(CONFIG_AD7314_MODULE)
+#if IS_ENABLED(CONFIG_SENSORS_AD7314)
 static struct bfin5xx_spi_chip ad7314_spi_chip_info = {
 	.enable_dma = 0,
 };
@@ -1039,7 +1039,7 @@ static struct spi_board_info bfin_spi_board_info[] __initdata = {
 	},
 #endif
 
-#if defined(CONFIG_AD7314) || defined(CONFIG_AD7314_MODULE)
+#if IS_ENABLED(CONFIG_SENSORS_AD7314)
 	{
 		.modalias = "ad7314",
 		.max_speed_hz = 1000000,
-- 
1.7.11.7

