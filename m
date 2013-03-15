Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755013Ab3CONKG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 09:10:06 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:50334 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754774Ab3CONKD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 09:10:03 -0400
From: Eduardo Valentin <eduardo.valentin@ti.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-pm@vger.kernel.org>,
        Eduardo Valentin <eduardo.valentin@ti.com>
Subject: [PATCH 24/50] staging: omap-thermal: name temp_to_adc_conversion in a better way
Date: Fri, 15 Mar 2013 09:00:12 -0400
Message-ID: <1363352438-15935-25-git-send-email-eduardo.valentin@ti.com>
X-Mailer: git-send-email 1.7.7.1.488.ge8e1c
In-Reply-To: <1363352438-15935-1-git-send-email-eduardo.valentin@ti.com>
References: <1363352438-15935-1-git-send-email-eduardo.valentin@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rename temp_to_adc_conversion to omap_bandgap_mcelsius_to_adc. This name,
though longer, describes better the function.

This patch also changes this function signature so the function follows
the style of this file.

Signed-off-by: Eduardo Valentin <eduardo.valentin@ti.com>
---
 drivers/staging/omap-thermal/omap-bandgap.c |   11 ++++++-----
 1 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/omap-thermal/omap-bandgap.c b/drivers/staging/omap-thermal/omap-bandgap.c
index 8279cca..d5359e3 100644
--- a/drivers/staging/omap-thermal/omap-bandgap.c
+++ b/drivers/staging/omap-thermal/omap-bandgap.c
@@ -264,8 +264,9 @@ exit:
 	return ret;
 }
 
-static int temp_to_adc_conversion(long temp, struct omap_bandgap *bg_ptr, int i,
-				  int *adc)
+static
+int omap_bandgap_mcelsius_to_adc(struct omap_bandgap *bg_ptr, int i, long temp,
+				 int *adc)
 {
 	struct temp_sensor_data *ts_data = bg_ptr->conf->sensors[i].ts_data;
 	const int *conv_table = bg_ptr->conf->conv_table;
@@ -330,7 +331,7 @@ int add_hyst(int adc_val, int hyst_val, struct omap_bandgap *bg_ptr, int i,
 
 	temp += hyst_val;
 
-	return temp_to_adc_conversion(temp, bg_ptr, i, sum);
+	return omap_bandgap_mcelsius_to_adc(bg_ptr, i, temp, sum);
 }
 
 /* Talert Thot threshold. Call it only if HAS(TALERT) is set */
@@ -493,7 +494,7 @@ int omap_bandgap_write_thot(struct omap_bandgap *bg_ptr, int id, int val)
 
 	if (val < ts_data->min_temp + ts_data->hyst_val)
 		return -EINVAL;
-	ret = temp_to_adc_conversion(val, bg_ptr, id, &t_hot);
+	ret = omap_bandgap_mcelsius_to_adc(bg_ptr, id, val, &t_hot);
 	if (ret < 0)
 		return ret;
 
@@ -566,7 +567,7 @@ int omap_bandgap_write_tcold(struct omap_bandgap *bg_ptr, int id, int val)
 	if (val > ts_data->max_temp + ts_data->hyst_val)
 		return -EINVAL;
 
-	ret = temp_to_adc_conversion(val, bg_ptr, id, &t_cold);
+	ret = omap_bandgap_mcelsius_to_adc(bg_ptr, id, val, &t_cold);
 	if (ret < 0)
 		return ret;
 
-- 
1.7.7.1.488.ge8e1c

