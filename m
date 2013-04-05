Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161089Ab3DEJUu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Apr 2013 05:20:50 -0400
Received: from cpsmtpb-ews06.kpnxchange.com ([213.75.39.9]:52338 "EHLO
	cpsmtpb-ews06.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752196Ab3DEJUt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Apr 2013 05:20:49 -0400
Message-ID: <1365153646.1830.58.camel@x61.thuisdomein>
Subject: [PATCH] Blackfin: bf537: use "CONFIG_SND_SOC_AD193X"
From: Paul Bolle <pebolle@tiscali.nl>
To: Mike Frysinger <vapier@gentoo.org>
Cc: Jean Delvare <khali@linux-fr.org>, Guenter Roeck <linux@roeck-us.net>,
        uclinux-dist-devel@blackfin.uclinux.org, linux-kernel@vger.kernel.org
Date: Fri, 05 Apr 2013 11:20:46 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 05 Apr 2013 09:20:46.0767 (UTC) FILETIME=[DB09B3F0:01CE31DE]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 57084ede395bb3c9da7905701d34a3b7d33c9356 ("blackfin: bf537:
stamp: update board file for 193x") changed two references to
CONFIG_SND_BF5XX_SOC_AD193X (and CONFIG_SND_BF5XX_SOC_AD193X_MODULE).
One was changed to CONFIG_SND_SOC_AD193X_SPI, the other to
CONFIG_SND_SOC_AD193X_I2C. The commit explanation doesn't elaborate on
the reason for these changes nor on the reason to drop module support.

Anyhow, neither of these two new Kconfig macros is valid. It was
probably intended to use CONFIG_SND_SOC_AD193X here. So let's use that.
And let's also reenable module support by using the IS_ENABLED() macro.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
0) Untested. Please note that I fail to see the point of commit
57084ede395bb3c9da7905701d34a3b7d33c9356, which was added in v3.4, even
if I assume it wanted to use CONFIG_SND_SOC_AD193X. Perhaps I'm missing
something obvious. Anyhow, review is appreciated.

1) Added Jean and Guenter because they seem to take in interest in
Blackfin's stamp files.

 arch/blackfin/mach-bf537/boards/stamp.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/blackfin/mach-bf537/boards/stamp.c b/arch/blackfin/mach-bf537/boards/stamp.c
index e6fdc2a..94a193e 100644
--- a/arch/blackfin/mach-bf537/boards/stamp.c
+++ b/arch/blackfin/mach-bf537/boards/stamp.c
@@ -975,7 +975,7 @@ static struct spi_board_info bfin_spi_board_info[] __initdata = {
 	},
 #endif
 
-#ifdef CONFIG_SND_SOC_AD193X_SPI
+#if IS_ENABLED(CONFIG_SND_SOC_AD193X)
 	{
 		.modalias = "ad193x",
 		.max_speed_hz = 3125000,     /* max spi clock (SCK) speed in HZ */
@@ -2176,7 +2176,7 @@ static unsigned long adt7316_i2c_data[2] = {
 #endif
 
 static struct i2c_board_info __initdata bfin_i2c_board_info[] = {
-#ifdef CONFIG_SND_SOC_AD193X_I2C
+#if IS_ENABLED(CONFIG_SND_SOC_AD193X)
 	{
 		I2C_BOARD_INFO("ad1937", 0x04),
 	},
-- 
1.7.11.7

