Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754086Ab3ATDEw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jan 2013 22:04:52 -0500
Received: from mail-wg0-f51.google.com ([74.125.82.51]:60503 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752502Ab3ATDEq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jan 2013 22:04:46 -0500
From: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali.rohar@gmail.com>
To: Peter Ujfalusi <peter.ujfalusi@ti.com>,
        Jarkko Nikula <jarkko.nikula@bitmer.com>,
        Tony Lindgren <tony@atomide.com>
Cc: linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali.rohar@gmail.com>
Subject: [PATCH 2/2] ARM: OMAP: rx51: Register audio device
Date: Sun, 20 Jan 2013 04:04:30 +0100
Message-Id: <1358651070-30029-3-git-send-email-pali.rohar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1358651070-30029-1-git-send-email-pali.rohar@gmail.com>
References: <1358651070-30029-1-git-send-email-pali.rohar@gmail.com>
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
index 45d401a..038ea1f 100644
--- a/arch/arm/mach-omap2/board-rx51-peripherals.c
+++ b/arch/arm/mach-omap2/board-rx51-peripherals.c
@@ -1370,6 +1370,16 @@ error:
 	 */
 }
 
+static struct platform_device rx51_audio_device = {
+	.name	= "rx51-audio",
+	.id	= -1,
+};
+
+static void __init rx51_init_audio(void)
+{
+	platform_device_register(&rx51_audio_device);
+}
+
 static struct tsc2005_platform_data tsc2005_pdata = {
 	.ts_pressure_max	= 2048,
 	.ts_pressure_fudge	= 2,
@@ -1568,6 +1578,7 @@ void __init rx51_peripherals_init(void)
 	gpmc_onenand_init(board_onenand_data);
 	board_smc91x_init();
 	rx51_add_gpio_keys();
+	rx51_init_audio();
 	rx51_init_wl1251();
 	rx51_init_tsc2005();
 	rx51_init_si4713();
-- 
1.7.10.4

