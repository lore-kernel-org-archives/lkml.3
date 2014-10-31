Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758773AbaJaUqG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 16:46:06 -0400
Received: from down.free-electrons.com ([37.187.137.238]:44806 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756548AbaJaUqF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 16:46:05 -0400
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Wim Van Sebroeck <wim@iguana.be>, Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Boris Brezillon <boris.brezillon@free-electrons.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Arnd Bergmann <arnd@arndb.de>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-watchdog@vger.kernel.org,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>
Subject: [PATCH 1/2] ARM: at91: rm9200 add system timer resources to watchdog
Date: Fri, 31 Oct 2014 21:45:58 +0100
Message-Id: <1414788359-15759-1-git-send-email-alexandre.belloni@free-electrons.com>
X-Mailer: git-send-email 2.1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To be able to make the watchdog driver independent from the mach/ includes, pass
the system timer register space as a resource.

Also, change the name to avoid conflicting with the at91sam9 watchdog driver.

Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
---
 arch/arm/mach-at91/at91rm9200_devices.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/arch/arm/mach-at91/at91rm9200_devices.c b/arch/arm/mach-at91/at91rm9200_devices.c
index 74f1eaf97801..4add0481adab 100644
--- a/arch/arm/mach-at91/at91rm9200_devices.c
+++ b/arch/arm/mach-at91/at91rm9200_devices.c
@@ -719,10 +719,19 @@ static void __init at91_add_device_rtc(void) {}
  * -------------------------------------------------------------------- */
 
 #if defined(CONFIG_AT91RM9200_WATCHDOG) || defined(CONFIG_AT91RM9200_WATCHDOG_MODULE)
+static struct resource wdt_resources[] = {
+	[0] = {
+		.start	= AT91RM9200_BASE_ST,
+		.end	= AT91RM9200_BASE_ST + SZ_256 - 1,
+		.flags	= IORESOURCE_MEM,
+	},
+};
+
 static struct platform_device at91rm9200_wdt_device = {
-	.name		= "at91_wdt",
+	.name		= "at91rm9200_wdt",
 	.id		= -1,
-	.num_resources	= 0,
+	.resource	= wdt_resources,
+	.num_resources	= 1,
 };
 
 static void __init at91_add_device_watchdog(void)
-- 
2.1.0

