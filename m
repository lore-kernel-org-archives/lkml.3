Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754567AbaDOKeh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 06:34:37 -0400
Received: from top.free-electrons.com ([176.31.233.9]:39034 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754451AbaDOK2R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 06:28:17 -0400
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jonathan Cameron <jic23@kernel.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-iio@vger.kernel.org, linux-input@vger.kernel.org,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>
Subject: [PATCHv3 03/15] iio: adc: at91: cleanup platform_data
Date: Tue, 15 Apr 2014 12:27:58 +0200
Message-Id: <1397557690-5650-4-git-send-email-alexandre.belloni@free-electrons.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1397557690-5650-1-git-send-email-alexandre.belloni@free-electrons.com>
References: <1397557690-5650-1-git-send-email-alexandre.belloni@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

num_channels and registers are not used anymore since they are defined inside
the driver and assigned by matching the id_table.

Also, struct at91_adc_reg_desc is now only used inside the driver.

Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
Acked-by: Jonathan Cameron <jic23@kernel.org>
---
 drivers/iio/adc/at91_adc.c             | 19 +++++++++++++++++++
 include/linux/platform_data/at91_adc.h | 23 -----------------------
 2 files changed, 19 insertions(+), 23 deletions(-)

diff --git a/drivers/iio/adc/at91_adc.c b/drivers/iio/adc/at91_adc.c
index 89777ed9abd8..1beae65aef2c 100644
--- a/drivers/iio/adc/at91_adc.c
+++ b/drivers/iio/adc/at91_adc.c
@@ -46,6 +46,25 @@
 #define TOUCH_SAMPLE_PERIOD_US		2000	/* 2ms */
 #define TOUCH_PEN_DETECT_DEBOUNCE_US	200
 
+/**
+ * struct at91_adc_reg_desc - Various informations relative to registers
+ * @channel_base:	Base offset for the channel data registers
+ * @drdy_mask:		Mask of the DRDY field in the relevant registers
+			(Interruptions registers mostly)
+ * @status_register:	Offset of the Interrupt Status Register
+ * @trigger_register:	Offset of the Trigger setup register
+ * @mr_prescal_mask:	Mask of the PRESCAL field in the adc MR register
+ * @mr_startup_mask:	Mask of the STARTUP field in the adc MR register
+ */
+struct at91_adc_reg_desc {
+	u8	channel_base;
+	u32	drdy_mask;
+	u8	status_register;
+	u8	trigger_register;
+	u32	mr_prescal_mask;
+	u32	mr_startup_mask;
+};
+
 struct at91_adc_caps {
 	bool	has_ts;		/* Support touch screen */
 	bool	has_tsmr;	/* only at91sam9x5, sama5d3 have TSMR reg */
diff --git a/include/linux/platform_data/at91_adc.h b/include/linux/platform_data/at91_adc.h
index b3ca1e94e0c8..fcf73879dbfe 100644
--- a/include/linux/platform_data/at91_adc.h
+++ b/include/linux/platform_data/at91_adc.h
@@ -8,25 +8,6 @@
 #define _AT91_ADC_H_
 
 /**
- * struct at91_adc_reg_desc - Various informations relative to registers
- * @channel_base:	Base offset for the channel data registers
- * @drdy_mask:		Mask of the DRDY field in the relevant registers
-			(Interruptions registers mostly)
- * @status_register:	Offset of the Interrupt Status Register
- * @trigger_register:	Offset of the Trigger setup register
- * @mr_prescal_mask:	Mask of the PRESCAL field in the adc MR register
- * @mr_startup_mask:	Mask of the STARTUP field in the adc MR register
- */
-struct at91_adc_reg_desc {
-	u8	channel_base;
-	u32	drdy_mask;
-	u8	status_register;
-	u8	trigger_register;
-	u32	mr_prescal_mask;
-	u32	mr_startup_mask;
-};
-
-/**
  * struct at91_adc_trigger - description of triggers
  * @name:		name of the trigger advertised to the user
  * @value:		value to set in the ADC's trigger setup register
@@ -42,8 +23,6 @@ struct at91_adc_trigger {
 /**
  * struct at91_adc_data - platform data for ADC driver
  * @channels_used:		channels in use on the board as a bitmask
- * @num_channels:		global number of channels available on the board
- * @registers:			Registers definition on the board
  * @startup_time:		startup time of the ADC in microseconds
  * @trigger_list:		Triggers available in the ADC
  * @trigger_number:		Number of triggers available in the ADC
@@ -52,8 +31,6 @@ struct at91_adc_trigger {
  */
 struct at91_adc_data {
 	unsigned long			channels_used;
-	u8				num_channels;
-	struct at91_adc_reg_desc	*registers;
 	u8				startup_time;
 	struct at91_adc_trigger		*trigger_list;
 	u8				trigger_number;
-- 
1.8.3.2

