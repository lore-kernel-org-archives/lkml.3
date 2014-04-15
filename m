Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754507AbaDOK2U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 06:28:20 -0400
Received: from top.free-electrons.com ([176.31.233.9]:39028 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754444AbaDOK2Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 06:28:16 -0400
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jonathan Cameron <jic23@kernel.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-iio@vger.kernel.org, linux-input@vger.kernel.org,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>
Subject: [PATCHv3 02/15] ARM: at91: sam9260: remove unused platform_data
Date: Tue, 15 Apr 2014 12:27:57 +0200
Message-Id: <1397557690-5650-3-git-send-email-alexandre.belloni@free-electrons.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1397557690-5650-1-git-send-email-alexandre.belloni@free-electrons.com>
References: <1397557690-5650-1-git-send-email-alexandre.belloni@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

num_channels and registers are not used anymore since they are defined inside
the at91_adc driver and assigned by matching the id_table.

Also, remove the mach/at91_adc.h include that is not necessary anymore.

Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
Acked-by: Jonathan Cameron <jic23@kernel.org>
---
 arch/arm/mach-at91/at91sam9260_devices.c | 10 ----------
 1 file changed, 10 deletions(-)

diff --git a/arch/arm/mach-at91/at91sam9260_devices.c b/arch/arm/mach-at91/at91sam9260_devices.c
index a0282928e9c1..fffcd09ac878 100644
--- a/arch/arm/mach-at91/at91sam9260_devices.c
+++ b/arch/arm/mach-at91/at91sam9260_devices.c
@@ -24,7 +24,6 @@
 #include <mach/at91sam9260_matrix.h>
 #include <mach/at91_matrix.h>
 #include <mach/at91sam9_smc.h>
-#include <mach/at91_adc.h>
 #include <mach/hardware.h>
 
 #include "board.h"
@@ -1325,13 +1324,6 @@ static struct at91_adc_trigger at91_adc_triggers[] = {
 	},
 };
 
-static struct at91_adc_reg_desc at91_adc_register_g20 = {
-	.channel_base = AT91_ADC_CHR(0),
-	.drdy_mask = AT91_ADC_DRDY,
-	.status_register = AT91_ADC_SR,
-	.trigger_register = AT91_ADC_MR,
-};
-
 void __init at91_add_device_adc(struct at91_adc_data *data)
 {
 	if (!data)
@@ -1349,9 +1341,7 @@ void __init at91_add_device_adc(struct at91_adc_data *data)
 	if (data->use_external_triggers)
 		at91_set_A_periph(AT91_PIN_PA22, 0);
 
-	data->num_channels = 4;
 	data->startup_time = 10;
-	data->registers = &at91_adc_register_g20;
 	data->trigger_number = 4;
 	data->trigger_list = at91_adc_triggers;
 
-- 
1.8.3.2

