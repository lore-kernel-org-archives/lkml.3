Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751349AbaEGRp4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 13:45:56 -0400
Received: from top.free-electrons.com ([176.31.233.9]:33138 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750884AbaEGRpy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 13:45:54 -0400
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Andrew Victor <linux@maxim.org.za>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>
Subject: [PATCH] ARM: at91: sam9260: fix compilation issues
Date: Wed,  7 May 2014 19:45:48 +0200
Message-Id: <1399484748-32718-1-git-send-email-alexandre.belloni@free-electrons.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the hexadecimal values for the triggers to match what is done for the device
tree. This also fixes compilation issues as the defines have been moved
elsewhere.

Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
---
I believe that at some point, we may want to reintroduce defines for those
values but we should probably do that in a dt-bindings include and choose better
names as the meaning differ between SoCs.

 arch/arm/mach-at91/at91sam9260_devices.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/arm/mach-at91/at91sam9260_devices.c b/arch/arm/mach-at91/at91sam9260_devices.c
index fffcd09ac878..a8d0d9cb1bca 100644
--- a/arch/arm/mach-at91/at91sam9260_devices.c
+++ b/arch/arm/mach-at91/at91sam9260_devices.c
@@ -1307,19 +1307,19 @@ static struct platform_device at91_adc_device = {
 static struct at91_adc_trigger at91_adc_triggers[] = {
 	[0] = {
 		.name = "timer-counter-0",
-		.value = AT91_ADC_TRGSEL_TC0 | AT91_ADC_TRGEN,
+		.value = 0x1,
 	},
 	[1] = {
 		.name = "timer-counter-1",
-		.value = AT91_ADC_TRGSEL_TC1 | AT91_ADC_TRGEN,
+		.value = 0x3,
 	},
 	[2] = {
 		.name = "timer-counter-2",
-		.value = AT91_ADC_TRGSEL_TC2 | AT91_ADC_TRGEN,
+		.value = 0x5,
 	},
 	[3] = {
 		.name = "external",
-		.value = AT91_ADC_TRGSEL_EXTERNAL | AT91_ADC_TRGEN,
+		.value = 0xd,
 		.is_external = true,
 	},
 };
-- 
1.9.1

