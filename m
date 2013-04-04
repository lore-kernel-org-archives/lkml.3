Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759544Ab3DDKbK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 06:31:10 -0400
Received: from cpsmtpb-ews08.kpnxchange.com ([213.75.39.13]:62862 "EHLO
	cpsmtpb-ews08.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759426Ab3DDKbI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 06:31:08 -0400
Message-ID: <1365071466.1830.29.camel@x61.thuisdomein>
Subject: [PATCH] Blackfin: bf537: rename "CONFIG_ADT75"
From: Paul Bolle <pebolle@tiscali.nl>
To: Mike Frysinger <vapier@gentoo.org>
Cc: Michael Hennerich <michael.hennerich@analog.com>,
        Jonathan Cameron <jic23@cam.ac.uk>, Jean Delvare <khali@linux-fr.org>,
        Guenter Roeck <linux@roeck-us.net>,
        uclinux-dist-devel@blackfin.uclinux.org, linux-kernel@vger.kernel.org
Date: Thu, 04 Apr 2013 12:31:06 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 04 Apr 2013 10:31:06.0303 (UTC) FILETIME=[83AA0CF0:01CE311F]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In v3.2 the Analog Devices ADT75 temperature sensor driver was removed
as an IIO driver and support for it was added to the LM75 HWMON driver.
But it was apparently overlooked to rename one reference to CONFIG_ADT75
to CONFIG_SENSORS_LM75. Do so now. Use the IS_ENABLED() macro, while
we're at it.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
0) Also untested.

1) See commits e96f9d89e6213c7630a3323cd0c754e7f2619564 ("hwmon: (lm75)
Add support for Analog Devices ADT75") and
cdea0bec8d37f2943ae500512b0c178bc76de6e3 ("iio: adc: remove ADT75 driver
- hwmon/lm75 will take over ADT75 support") for the two patches involved
in this operation.

 arch/blackfin/mach-bf537/boards/stamp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/blackfin/mach-bf537/boards/stamp.c b/arch/blackfin/mach-bf537/boards/stamp.c
index b40b849..9735345 100644
--- a/arch/blackfin/mach-bf537/boards/stamp.c
+++ b/arch/blackfin/mach-bf537/boards/stamp.c
@@ -2221,7 +2221,7 @@ static struct i2c_board_info __initdata bfin_i2c_board_info[] = {
 	},
 #endif
 
-#if defined(CONFIG_ADT75) || defined(CONFIG_ADT75_MODULE)
+#if IS_ENABLED(CONFIG_SENSORS_LM75)
 	{
 		I2C_BOARD_INFO("adt75", 0x9),
 		.irq = IRQ_PG5,
-- 
1.7.11.7

