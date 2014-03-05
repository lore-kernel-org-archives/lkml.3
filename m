Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756070AbaCERf4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 12:35:56 -0500
Received: from top.free-electrons.com ([176.31.233.9]:50746 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751983AbaCERfw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 12:35:52 -0500
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jonathan Cameron <jic23@kernel.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-iio@vger.kernel.org, linux-input@vger.kernel.org,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>
Subject: [PATCH 01/15] ARM: at91: sam9g45: remove unused platform_data
Date: Wed,  5 Mar 2014 18:35:26 +0100
Message-Id: <1394040940-18246-2-git-send-email-alexandre.belloni@free-electrons.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1394040940-18246-1-git-send-email-alexandre.belloni@free-electrons.com>
References: <1394040940-18246-1-git-send-email-alexandre.belloni@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

num_channels and registers are not used anymore since they are defined inside
the at91_adc driver and assigned by matching the id_table.

Also, remove the mach/at91_adc.h include that is not necessary anymore.

Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
---
 arch/arm/mach-at91/at91sam9g45_devices.c | 10 ----------
 1 file changed, 10 deletions(-)

diff --git a/arch/arm/mach-at91/at91sam9g45_devices.c b/arch/arm/mach-at91/at91sam9g45_devices.c
index 88554024eb2d..cd36009c3511 100644
--- a/arch/arm/mach-at91/at91sam9g45_devices.c
+++ b/arch/arm/mach-at91/at91sam9g45_devices.c
@@ -25,7 +25,6 @@
 #include <linux/fb.h>
 #include <video/atmel_lcdc.h>
 
-#include <mach/at91_adc.h>
 #include <mach/at91sam9g45.h>
 #include <mach/at91sam9g45_matrix.h>
 #include <mach/at91_matrix.h>
@@ -1235,13 +1234,6 @@ static struct at91_adc_trigger at91_adc_triggers[] = {
 	},
 };
 
-static struct at91_adc_reg_desc at91_adc_register_g45 = {
-	.channel_base = AT91_ADC_CHR(0),
-	.drdy_mask = AT91_ADC_DRDY,
-	.status_register = AT91_ADC_SR,
-	.trigger_register = 0x08,
-};
-
 void __init at91_add_device_adc(struct at91_adc_data *data)
 {
 	if (!data)
@@ -1267,9 +1259,7 @@ void __init at91_add_device_adc(struct at91_adc_data *data)
 	if (data->use_external_triggers)
 		at91_set_A_periph(AT91_PIN_PD28, 0);
 
-	data->num_channels = 8;
 	data->startup_time = 40;
-	data->registers = &at91_adc_register_g45;
 	data->trigger_number = 4;
 	data->trigger_list = at91_adc_triggers;
 
-- 
1.8.3.2

