Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752445Ab3ATC4W (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jan 2013 21:56:22 -0500
Received: from mail-wi0-f176.google.com ([209.85.212.176]:44389 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752288Ab3ATC4U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jan 2013 21:56:20 -0500
From: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali.rohar@gmail.com>
To: Tony Lindgren <tony@atomide.com>, Russell King <linux@arm.linux.org.uk>
Cc: linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali.rohar@gmail.com>
Subject: [PATCH] RX-51: Register twl4030-madc device
Date: Sun, 20 Jan 2013 03:54:26 +0100
Message-Id: <1358650466-29917-1-git-send-email-pali.rohar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Pali Rohár <pali.rohar@gmail.com>
---
 arch/arm/mach-omap2/board-rx51-peripherals.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/arch/arm/mach-omap2/board-rx51-peripherals.c b/arch/arm/mach-omap2/board-rx51-peripherals.c
index 9a0dbb7..286292e 100644
--- a/arch/arm/mach-omap2/board-rx51-peripherals.c
+++ b/arch/arm/mach-omap2/board-rx51-peripherals.c
@@ -1364,6 +1364,16 @@ static void __init rx51_init_lirc(void)
 }
 #endif
 
+static struct platform_device madc_hwmon = {
+	.name	= "twl4030_madc_hwmon",
+	.id	= -1,
+};
+
+static void __init rx51_init_twl4030_hwmon(void)
+{
+	platform_device_register(&madc_hwmon);
+}
+
 void __init rx51_peripherals_init(void)
 {
 	rx51_i2c_init();
@@ -1386,5 +1396,6 @@ void __init rx51_peripherals_init(void)
 		omap_hsmmc_init(mmc);
 
 	rx51_charger_init();
+	rx51_init_twl4030_hwmon();
 }
 
-- 
1.7.10.4

