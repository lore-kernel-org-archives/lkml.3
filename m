Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754964Ab3CONJV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 09:09:21 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:50380 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754938Ab3CONJT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 09:09:19 -0400
From: Eduardo Valentin <eduardo.valentin@ti.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-pm@vger.kernel.org>,
        Eduardo Valentin <eduardo.valentin@ti.com>
Subject: [PATCH 22/50] staging: omap-thermal: rewrite omap_bandgap_adc_to_mcelsius on kernel coding style
Date: Fri, 15 Mar 2013 09:00:10 -0400
Message-ID: <1363352438-15935-23-git-send-email-eduardo.valentin@ti.com>
X-Mailer: git-send-email 1.7.7.1.488.ge8e1c
In-Reply-To: <1363352438-15935-1-git-send-email-eduardo.valentin@ti.com>
References: <1363352438-15935-1-git-send-email-eduardo.valentin@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Follow Documentation/CodingStyle while doing  omap_bandgap_adc_to_mcelsius.

Signed-off-by: Eduardo Valentin <eduardo.valentin@ti.com>
---
 drivers/staging/omap-thermal/omap-bandgap.c |   11 ++++++++---
 1 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/omap-thermal/omap-bandgap.c b/drivers/staging/omap-thermal/omap-bandgap.c
index a7fd3e8..0068c66 100644
--- a/drivers/staging/omap-thermal/omap-bandgap.c
+++ b/drivers/staging/omap-thermal/omap-bandgap.c
@@ -238,14 +238,19 @@ int omap_bandgap_adc_to_mcelsius(struct omap_bandgap *bg_ptr, int id,
 				 int adc_val, int *t)
 {
 	struct temp_sensor_data *ts_data = bg_ptr->conf->sensors[id].ts_data;
+	int ret = 0;
 
 	/* look up for temperature in the table and return the temperature */
-	if (adc_val < ts_data->adc_start_val || adc_val > ts_data->adc_end_val)
-		return -ERANGE;
+	if (adc_val < ts_data->adc_start_val ||
+	    adc_val > ts_data->adc_end_val) {
+		ret = -ERANGE;
+		goto exit;
+	}
 
 	*t = bg_ptr->conf->conv_table[adc_val - ts_data->adc_start_val];
 
-	return 0;
+exit:
+	return ret;
 }
 
 static int temp_to_adc_conversion(long temp, struct omap_bandgap *bg_ptr, int i,
-- 
1.7.7.1.488.ge8e1c

