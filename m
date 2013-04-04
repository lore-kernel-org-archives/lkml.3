Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757753Ab3DDLCO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 07:02:14 -0400
Received: from cpsmtpb-ews01.kpnxchange.com ([213.75.39.4]:60650 "EHLO
	cpsmtpb-ews01.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755758Ab3DDLCN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 07:02:13 -0400
Message-ID: <1365073330.1830.34.camel@x61.thuisdomein>
Subject: [PATCH] Blackfin: bf537: rename ad2s120x ->ad2s1200
From: Paul Bolle <pebolle@tiscali.nl>
To: Mike Frysinger <vapier@gentoo.org>
Cc: Jonathan Cameron <jic23@cam.ac.uk>,
        Michael Hennerich <michael.hennerich@analog.com>,
        uclinux-dist-devel@blackfin.uclinux.org, linux-kernel@vger.kernel.org
Date: Thu, 04 Apr 2013 13:02:10 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 04 Apr 2013 11:02:11.0459 (UTC) FILETIME=[DB624530:01CE3123]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In v3.2 the Analog Devices ad2s1200/ad2s1205 driver was renamed from
ad2s120x to ad2s1200. But it apparently forgot to rename the references
to this driver in the BF537-STAMP code. Rename these now, and use the
IS_ENABLED() macro, while we're at it.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
0) Also untested. The ".modalias" change is educated guesswork.

1) See commit 10e4a52b6e471cea2e87e71f8708a8c8c6b75266
("staging:iio:resolver rename ad2s120x ->ad2s1200") for the commit that
started all this.

 arch/blackfin/mach-bf537/boards/stamp.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/arch/blackfin/mach-bf537/boards/stamp.c b/arch/blackfin/mach-bf537/boards/stamp.c
index 9735345..e6fdc2a 100644
--- a/arch/blackfin/mach-bf537/boards/stamp.c
+++ b/arch/blackfin/mach-bf537/boards/stamp.c
@@ -654,13 +654,13 @@ static struct bfin5xx_spi_chip ad2s90_spi_chip_info = {
 };
 #endif
 
-#if defined(CONFIG_AD2S120X) || defined(CONFIG_AD2S120X_MODULE)
-static unsigned short ad2s120x_platform_data[] = {
+#if IS_ENABLED(CONFIG_AD2S1200)
+static unsigned short ad2s1200_platform_data[] = {
 	/* used as SAMPLE and RDVEL */
 	GPIO_PF5, GPIO_PF6, 0
 };
 
-static struct bfin5xx_spi_chip ad2s120x_spi_chip_info = {
+static struct bfin5xx_spi_chip ad2s1200_spi_chip_info = {
 	.enable_dma = 0,
 };
 #endif
@@ -1018,13 +1018,13 @@ static struct spi_board_info bfin_spi_board_info[] __initdata = {
 	},
 #endif
 
-#if defined(CONFIG_AD2S120X) || defined(CONFIG_AD2S120X_MODULE)
+#if IS_ENABLED(CONFIG_AD2S1200)
 	{
-		.modalias = "ad2s120x",
+		.modalias = "ad2s1200",
 		.bus_num = 0,
 		.chip_select = 4,            /* CS, change it for your board */
-		.platform_data = ad2s120x_platform_data,
-		.controller_data = &ad2s120x_spi_chip_info,
+		.platform_data = ad2s1200_platform_data,
+		.controller_data = &ad2s1200_spi_chip_info,
 	},
 #endif
 
-- 
1.7.11.7

