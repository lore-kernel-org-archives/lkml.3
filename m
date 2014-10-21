Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934081AbaJUV6d (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 17:58:33 -0400
Received: from down.free-electrons.com ([37.187.137.238]:52066 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933738AbaJUV4J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 17:56:09 -0400
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Sebastian Reichel <sre@kernel.org>
Cc: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>
Subject: [PATCH 3/8] ARM: at91: sam9: probe the RAMC driver from pdata
Date: Tue, 21 Oct 2014 23:55:35 +0200
Message-Id: <1413928540-27099-4-git-send-email-alexandre.belloni@free-electrons.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1413928540-27099-1-git-send-email-alexandre.belloni@free-electrons.com>
References: <1413928540-27099-1-git-send-email-alexandre.belloni@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Probe the atmel-sdramc driver from the board files, using platform_data.

Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
---
 arch/arm/mach-at91/Kconfig       |  2 +-
 arch/arm/mach-at91/at91sam9260.c | 15 +++++++++++++++
 arch/arm/mach-at91/at91sam9261.c | 15 +++++++++++++++
 arch/arm/mach-at91/at91sam9263.c | 15 +++++++++++++++
 4 files changed, 46 insertions(+), 1 deletion(-)

diff --git a/arch/arm/mach-at91/Kconfig b/arch/arm/mach-at91/Kconfig
index 0e6d548b70d9..db38e1d4b4fa 100644
--- a/arch/arm/mach-at91/Kconfig
+++ b/arch/arm/mach-at91/Kconfig
@@ -48,7 +48,7 @@ config SOC_AT91SAM9
 	select CPU_ARM926T
 	select GENERIC_CLOCKEVENTS
 	select MEMORY if USE_OF
-	select ATMEL_SDRAMC if USE_OF
+	select ATMEL_SDRAMC
 
 config SOC_SAMA5
 	bool
diff --git a/arch/arm/mach-at91/at91sam9260.c b/arch/arm/mach-at91/at91sam9260.c
index aab1f969a7c3..d5a6df9ce570 100644
--- a/arch/arm/mach-at91/at91sam9260.c
+++ b/arch/arm/mach-at91/at91sam9260.c
@@ -378,6 +378,20 @@ static struct platform_device rstc_device = {
 	.num_resources  = ARRAY_SIZE(rstc_resources),
 };
 
+static struct resource ramc_resources[] = {
+	[0] = {
+		.start  = AT91SAM9260_BASE_SDRAMC,
+		.end    = AT91SAM9260_BASE_SDRAMC + SZ_512 - 1,
+		.flags  = IORESOURCE_MEM,
+	},
+};
+
+static struct platform_device ramc_device = {
+	.name           = "at91-sam9260-ramc",
+	.resource       = ramc_resources,
+	.num_resources  = ARRAY_SIZE(ramc_resources),
+};
+
 static struct resource shdwc_resources[] = {
 	[0] = {
 		.start  = AT91SAM9260_BASE_SHDWC,
@@ -394,6 +408,7 @@ static struct platform_device shdwc_device = {
 
 static void __init at91sam9260_register_devices(void)
 {
+	platform_device_register(&ramc_device);
 	platform_device_register(&rstc_device);
 	platform_device_register(&shdwc_device);
 }
diff --git a/arch/arm/mach-at91/at91sam9261.c b/arch/arm/mach-at91/at91sam9261.c
index a8bd35963332..1b23a023cca6 100644
--- a/arch/arm/mach-at91/at91sam9261.c
+++ b/arch/arm/mach-at91/at91sam9261.c
@@ -337,6 +337,20 @@ static struct platform_device rstc_device = {
 	.num_resources  = ARRAY_SIZE(rstc_resources),
 };
 
+static struct resource ramc_resources[] = {
+	[0] = {
+		.start  = AT91SAM9261_BASE_SDRAMC,
+		.end    = AT91SAM9261_BASE_SDRAMC + SZ_512 - 1,
+		.flags  = IORESOURCE_MEM,
+	},
+};
+
+static struct platform_device ramc_device = {
+	.name           = "at91-sam9260-ramc",
+	.resource       = ramc_resources,
+	.num_resources  = ARRAY_SIZE(ramc_resources),
+};
+
 static struct resource shdwc_resources[] = {
 	[0] = {
 		.start  = AT91SAM9261_BASE_SHDWC,
@@ -353,6 +367,7 @@ static struct platform_device shdwc_device = {
 
 static void __init at91sam9261_register_devices(void)
 {
+	platform_device_register(&ramc_device);
 	platform_device_register(&rstc_device);
 	platform_device_register(&shdwc_device);
 }
diff --git a/arch/arm/mach-at91/at91sam9263.c b/arch/arm/mach-at91/at91sam9263.c
index fbff228cc63e..55c0c212fde1 100644
--- a/arch/arm/mach-at91/at91sam9263.c
+++ b/arch/arm/mach-at91/at91sam9263.c
@@ -360,6 +360,20 @@ static struct platform_device rstc_device = {
 	.num_resources  = ARRAY_SIZE(rstc_resources),
 };
 
+static struct resource ramc_resources[] = {
+	[0] = {
+		.start  = AT91SAM9263_BASE_SDRAMC0,
+		.end    = AT91SAM9263_BASE_SDRAMC0 + SZ_512 - 1,
+		.flags  = IORESOURCE_MEM,
+	},
+};
+
+static struct platform_device ramc_device = {
+	.name           = "at91-sam9260-ramc",
+	.resource       = ramc_resources,
+	.num_resources  = ARRAY_SIZE(ramc_resources),
+};
+
 static struct resource shdwc_resources[] = {
 	[0] = {
 		.start  = AT91SAM9263_BASE_SHDWC,
@@ -376,6 +390,7 @@ static struct platform_device shdwc_device = {
 
 static void __init at91sam9263_register_devices(void)
 {
+	platform_device_register(&ramc_device);
 	platform_device_register(&rstc_device);
 	platform_device_register(&shdwc_device);
 }
-- 
1.9.1

