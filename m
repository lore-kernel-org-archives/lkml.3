Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932428AbaGCO1C (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 10:27:02 -0400
Received: from top.free-electrons.com ([176.31.233.9]:50951 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758468AbaGCOUZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 10:20:25 -0400
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: linux@maxim.org.za, Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        dwmw2@infradead.org, dbaryshkov@gmail.com
Cc: Boris Brezillon <boris@free-electrons.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Thomas Petazzoni <thomas@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: [PATCH 14/18] AT91: Register the poweroff driver
Date: Thu,  3 Jul 2014 16:14:57 +0200
Message-Id: <1404396906-25194-25-git-send-email-maxime.ripard@free-electrons.com>
X-Mailer: git-send-email 2.0.1
In-Reply-To: <1404396906-25194-1-git-send-email-maxime.ripard@free-electrons.com>
References: <1404396906-25194-1-git-send-email-maxime.ripard@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Register the poweroff driver in the old-style SoC definition so that the driver
is loaded and provide a shutdown hook.

Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
---
 arch/arm/mach-at91/at91sam9260.c | 15 +++++++++++++++
 arch/arm/mach-at91/at91sam9261.c | 15 +++++++++++++++
 arch/arm/mach-at91/at91sam9263.c | 15 +++++++++++++++
 arch/arm/mach-at91/at91sam9g45.c | 15 +++++++++++++++
 arch/arm/mach-at91/at91sam9rl.c  | 15 +++++++++++++++
 5 files changed, 75 insertions(+)

diff --git a/arch/arm/mach-at91/at91sam9260.c b/arch/arm/mach-at91/at91sam9260.c
index 197c0149406a..5fa1986be2aa 100644
--- a/arch/arm/mach-at91/at91sam9260.c
+++ b/arch/arm/mach-at91/at91sam9260.c
@@ -377,9 +377,24 @@ static struct platform_device rstc_device = {
 	.num_resources  = ARRAY_SIZE(rstc_resources),
 };
 
+static struct resource shdwc_resources[] = {
+	[0] = {
+		.start  = AT91SAM9260_BASE_SHDWC,
+		.end    = AT91SAM9260_BASE_SHDWC + SZ_16 - 1,
+		.flags  = IORESOURCE_MEM,
+	},
+};
+
+static struct platform_device shdwc_device = {
+	.name           = "at91-poweroff",
+	.resource       = shdwc_resources,
+	.num_resources  = ARRAY_SIZE(shdwc_resources),
+};
+
 static void __init at91sam9260_register_devices(void)
 {
 	platform_device_register(&rstc_device);
+	platform_device_register(&shdwc_device);
 }
 
 /* --------------------------------------------------------------------
diff --git a/arch/arm/mach-at91/at91sam9261.c b/arch/arm/mach-at91/at91sam9261.c
index ef44977f1cae..5ccc67235e7a 100644
--- a/arch/arm/mach-at91/at91sam9261.c
+++ b/arch/arm/mach-at91/at91sam9261.c
@@ -340,9 +340,24 @@ static struct platform_device rstc_device = {
 	.num_resources  = ARRAY_SIZE(rstc_resources),
 };
 
+static struct resource shdwc_resources[] = {
+	[0] = {
+		.start  = AT91SAM9261_BASE_SHDWC,
+		.end    = AT91SAM9261_BASE_SHDWC + SZ_16 - 1,
+		.flags  = IORESOURCE_MEM,
+	},
+};
+
+static struct platform_device shdwc_device = {
+	.name           = "at91-poweroff",
+	.resource       = shdwc_resources,
+	.num_resources  = ARRAY_SIZE(shdwc_resources),
+};
+
 static void __init at91sam9261_register_devices(void)
 {
 	platform_device_register(&rstc_device);
+	platform_device_register(&shdwc_device);
 }
 
 /* --------------------------------------------------------------------
diff --git a/arch/arm/mach-at91/at91sam9263.c b/arch/arm/mach-at91/at91sam9263.c
index cb078e150a19..4d28c3479d4b 100644
--- a/arch/arm/mach-at91/at91sam9263.c
+++ b/arch/arm/mach-at91/at91sam9263.c
@@ -358,9 +358,24 @@ static struct platform_device rstc_device = {
 	.num_resources  = ARRAY_SIZE(rstc_resources),
 };
 
+static struct resource shdwc_resources[] = {
+	[0] = {
+		.start  = AT91SAM9263_BASE_SHDWC,
+		.end    = AT91SAM9263_BASE_SHDWC + SZ_16 - 1,
+		.flags  = IORESOURCE_MEM,
+	},
+};
+
+static struct platform_device shdwc_device = {
+	.name           = "at91-poweroff",
+	.resource       = shdwc_resources,
+	.num_resources  = ARRAY_SIZE(shdwc_resources),
+};
+
 static void __init at91sam9263_register_devices(void)
 {
 	platform_device_register(&rstc_device);
+	platform_device_register(&shdwc_device);
 }
 
 /* --------------------------------------------------------------------
diff --git a/arch/arm/mach-at91/at91sam9g45.c b/arch/arm/mach-at91/at91sam9g45.c
index 329749eb1dff..22034c96d488 100644
--- a/arch/arm/mach-at91/at91sam9g45.c
+++ b/arch/arm/mach-at91/at91sam9g45.c
@@ -412,9 +412,24 @@ static struct platform_device rstc_device = {
 	.num_resources  = ARRAY_SIZE(rstc_resources),
 };
 
+static struct resource shdwc_resources[] = {
+	[0] = {
+		.start  = AT91SAM9G45_BASE_SHDWC,
+		.end    = AT91SAM9G45_BASE_SHDWC + SZ_16 - 1,
+		.flags  = IORESOURCE_MEM,
+	},
+};
+
+static struct platform_device shdwc_device = {
+	.name           = "at91-poweroff",
+	.resource       = shdwc_resources,
+	.num_resources  = ARRAY_SIZE(shdwc_resources),
+};
+
 static void __init at91sam9g45_register_devices(void)
 {
 	platform_device_register(&rstc_device);
+	platform_device_register(&shdwc_device);
 }
 
 /* --------------------------------------------------------------------
diff --git a/arch/arm/mach-at91/at91sam9rl.c b/arch/arm/mach-at91/at91sam9rl.c
index e0e1729fe0e4..323a9f90931a 100644
--- a/arch/arm/mach-at91/at91sam9rl.c
+++ b/arch/arm/mach-at91/at91sam9rl.c
@@ -350,9 +350,24 @@ static struct platform_device rstc_device = {
 	.num_resources  = ARRAY_SIZE(rstc_resources),
 };
 
+static struct resource shdwc_resources[] = {
+	[0] = {
+		.start  = AT91SAM9RL_BASE_SHDWC,
+		.end    = AT91SAM9RL_BASE_SHDWC + SZ_16 - 1,
+		.flags  = IORESOURCE_MEM,
+	},
+};
+
+static struct platform_device shdwc_device = {
+	.name           = "at91-poweroff",
+	.resource       = shdwc_resources,
+	.num_resources  = ARRAY_SIZE(shdwc_resources),
+};
+
 static void __init at91sam9rl_register_devices(void)
 {
 	platform_device_register(&rstc_device);
+	platform_device_register(&shdwc_device);
 }
 
 /* --------------------------------------------------------------------
-- 
2.0.1

