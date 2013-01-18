Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750830Ab3ARFDD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 00:03:03 -0500
Received: from mail-da0-f47.google.com ([209.85.210.47]:64671 "EHLO
	mail-da0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750747Ab3ARFDA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 00:03:00 -0500
From: Hideki EIRAKU <hdk@igel.co.jp>
To: Simon Horman <horms@verge.net.au>, Magnus Damm <magnus.damm@gmail.com>,
        Russell King <linux@arm.linux.org.uk>
Cc: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        Damian Hobson-Garcia <dhobsong@igel.co.jp>,
        Katsuya MATSUBARA <matsu@igel.co.jp>, linux-sh@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Hideki EIRAKU <hdk@igel.co.jp>
Subject: [PATCH] ARM: shmobile: armadillo800eva: set clock rates before timer init
Date: Fri, 18 Jan 2013 14:02:05 +0900
Message-Id: <1358485325-19673-1-git-send-email-hdk@igel.co.jp>
X-Mailer: git-send-email 1.8.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Previously clock rates were set after initialization of timer.
Therefore the timer used the default extal1 clock rate (25MHz)
instead of the correct rate for this board (24MHz).

Signed-off-by: Hideki EIRAKU <hdk@igel.co.jp>
---
 arch/arm/mach-shmobile/board-armadillo800eva.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/arm/mach-shmobile/board-armadillo800eva.c b/arch/arm/mach-shmobile/board-armadillo800eva.c
index 5353adf..1e79cfb 100644
--- a/arch/arm/mach-shmobile/board-armadillo800eva.c
+++ b/arch/arm/mach-shmobile/board-armadillo800eva.c
@@ -1175,8 +1175,6 @@ static void __init eva_init(void)
 	platform_add_devices(eva_devices,
 			     ARRAY_SIZE(eva_devices));
 
-	eva_clock_init();
-
 	rmobile_add_device_to_domain("A4LC", &lcdc0_device);
 	rmobile_add_device_to_domain("A4LC", &hdmi_lcdc_device);
 	if (usb)
@@ -1187,6 +1185,9 @@ static void __init eva_earlytimer_init(void)
 {
 	r8a7740_clock_init(MD_CK0 | MD_CK2);
 	shmobile_earlytimer_init();
+
+	/* the rate of extal1 clock must be set before late_time_init */
+	eva_clock_init();
 }
 
 static void __init eva_add_early_devices(void)
-- 
1.8.0

