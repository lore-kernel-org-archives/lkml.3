Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754926Ab3CONJA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 09:09:00 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:42523 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754848Ab3CONI6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 09:08:58 -0400
From: Eduardo Valentin <eduardo.valentin@ti.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-pm@vger.kernel.org>,
        Eduardo Valentin <eduardo.valentin@ti.com>
Subject: [PATCH 21/50] staging: omap-thermal: name adc_to_temp_conversion in a better way
Date: Fri, 15 Mar 2013 09:00:09 -0400
Message-ID: <1363352438-15935-22-git-send-email-eduardo.valentin@ti.com>
X-Mailer: git-send-email 1.7.7.1.488.ge8e1c
In-Reply-To: <1363352438-15935-1-git-send-email-eduardo.valentin@ti.com>
References: <1363352438-15935-1-git-send-email-eduardo.valentin@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rename adc_to_temp_conversion to omap_bandgap_adc_to_mcelsius. This name,
though longer, describes better the function.

Signed-off-by: Eduardo Valentin <eduardo.valentin@ti.com>
---
 drivers/staging/omap-thermal/omap-bandgap.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/omap-thermal/omap-bandgap.c b/drivers/staging/omap-thermal/omap-bandgap.c
index 2acd30e..a7fd3e8 100644
--- a/drivers/staging/omap-thermal/omap-bandgap.c
+++ b/drivers/staging/omap-thermal/omap-bandgap.c
@@ -234,8 +234,8 @@ static irqreturn_t omap_bandgap_tshut_irq_handler(int irq, void *data)
 /***   Helper functions which manipulate conversion ADC <-> mi Celsius   ***/
 
 static
-int adc_to_temp_conversion(struct omap_bandgap *bg_ptr, int id, int adc_val,
-			   int *t)
+int omap_bandgap_adc_to_mcelsius(struct omap_bandgap *bg_ptr, int id,
+				 int adc_val, int *t)
 {
 	struct temp_sensor_data *ts_data = bg_ptr->conf->sensors[id].ts_data;
 
@@ -308,7 +308,7 @@ int add_hyst(int adc_val, int hyst_val, struct omap_bandgap *bg_ptr, int i,
 {
 	int temp, ret;
 
-	ret = adc_to_temp_conversion(bg_ptr, i, adc_val, &temp);
+	ret = omap_bandgap_adc_to_mcelsius(bg_ptr, i, adc_val, &temp);
 	if (ret < 0)
 		return ret;
 
@@ -439,7 +439,7 @@ int omap_bandgap_read_thot(struct omap_bandgap *bg_ptr, int id,
 	temp = omap_bandgap_readl(bg_ptr, tsr->bgap_threshold);
 	temp = (temp & tsr->threshold_thot_mask) >>
 		__ffs(tsr->threshold_thot_mask);
-	ret |= adc_to_temp_conversion(bg_ptr, id, temp, &temp);
+	ret |= omap_bandgap_adc_to_mcelsius(bg_ptr, id, temp, &temp);
 	if (ret) {
 		dev_err(bg_ptr->dev, "failed to read thot\n");
 		return -EIO;
@@ -514,7 +514,7 @@ int omap_bandgap_read_tcold(struct omap_bandgap *bg_ptr, int id,
 	temp = omap_bandgap_readl(bg_ptr, tsr->bgap_threshold);
 	temp = (temp & tsr->threshold_tcold_mask)
 	    >> __ffs(tsr->threshold_tcold_mask);
-	ret |= adc_to_temp_conversion(bg_ptr, id, temp, &temp);
+	ret |= omap_bandgap_adc_to_mcelsius(bg_ptr, id, temp, &temp);
 	if (ret)
 		return -EIO;
 
@@ -641,7 +641,7 @@ int omap_bandgap_read_temperature(struct omap_bandgap *bg_ptr, int id,
 	temp = omap_bandgap_read_temp(bg_ptr, id);
 	mutex_unlock(&bg_ptr->bg_mutex);
 
-	ret |= adc_to_temp_conversion(bg_ptr, id, temp, &temp);
+	ret |= omap_bandgap_adc_to_mcelsius(bg_ptr, id, temp, &temp);
 	if (ret)
 		return -EIO;
 
-- 
1.7.7.1.488.ge8e1c

