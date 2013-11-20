Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753206Ab3KTH7S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 02:59:18 -0500
Received: from mail-pd0-f172.google.com ([209.85.192.172]:54828 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753067Ab3KTH7O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 02:59:14 -0500
From: Magnus Damm <magnus.damm@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Magnus Damm <magnus.damm@gmail.com>, horms@verge.net.au,
        linux-sh@vger.kernel.org
Date: Wed, 20 Nov 2013 16:59:56 +0900
Message-Id: <20131120075956.23557.51924.sendpatchset@w520>
In-Reply-To: <20131120075921.23557.23231.sendpatchset@w520>
References: <20131120075921.23557.23231.sendpatchset@w520>
Subject: [PATCH 04/05] ARM: shmobile: Add r8a7791 thermal platform device
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Magnus Damm <damm@opensource.se>

Add a thermal platform device for the legacy case
on the r8a7791 SoC. This keeps the r8a7791 in sync
with the r8a7790 sister device.

Signed-off-by: Magnus Damm <damm@opensource.se>
---

 arch/arm/mach-shmobile/setup-r8a7791.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

--- 0001/arch/arm/mach-shmobile/setup-r8a7791.c
+++ work/arch/arm/mach-shmobile/setup-r8a7791.c	2013-11-20 15:54:42.000000000 +0900
@@ -189,6 +189,17 @@ static struct resource irqc0_resources[]
 					  &irqc##idx##_data,		\
 					  sizeof(struct renesas_irqc_config))
 
+static const struct resource thermal_resources[] __initconst = {
+	DEFINE_RES_MEM(0xe61f0000, 0x14),
+	DEFINE_RES_MEM(0xe61f0100, 0x38),
+	DEFINE_RES_IRQ(gic_spi(69)),
+};
+
+#define r8a7791_register_thermal()					\
+	platform_device_register_simple("rcar_thermal", -1,		\
+					thermal_resources,		\
+					ARRAY_SIZE(thermal_resources))
+
 void __init r8a7791_add_dt_devices(void)
 {
 	r8a7791_register_scif(SCIFA0);
@@ -213,6 +224,7 @@ void __init r8a7791_add_standard_devices
 {
 	r8a7791_add_dt_devices();
 	r8a7791_register_irqc(0);
+	r8a7791_register_thermal();
 }
 
 void __init r8a7791_init_early(void)
