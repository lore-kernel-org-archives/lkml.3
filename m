Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754601Ab3CONDQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 09:03:16 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:49881 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754537Ab3CONDO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 09:03:14 -0400
From: Eduardo Valentin <eduardo.valentin@ti.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-pm@vger.kernel.org>,
        Eduardo Valentin <eduardo.valentin@ti.com>
Subject: [PATCH 05/50] staging: omap-thermal: style cleanup on omap-bandgap.c
Date: Fri, 15 Mar 2013 08:59:53 -0400
Message-ID: <1363352438-15935-6-git-send-email-eduardo.valentin@ti.com>
X-Mailer: git-send-email 1.7.7.1.488.ge8e1c
In-Reply-To: <1363352438-15935-1-git-send-email-eduardo.valentin@ti.com>
References: <1363352438-15935-1-git-send-email-eduardo.valentin@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

simple changes on alignments and white spaces

Signed-off-by: Eduardo Valentin <eduardo.valentin@ti.com>
---
 drivers/staging/omap-thermal/omap-bandgap.c |   32 ++++++++++++--------------
 1 files changed, 15 insertions(+), 17 deletions(-)

diff --git a/drivers/staging/omap-thermal/omap-bandgap.c b/drivers/staging/omap-thermal/omap-bandgap.c
index d4a3788..9f2d7cc 100644
--- a/drivers/staging/omap-thermal/omap-bandgap.c
+++ b/drivers/staging/omap-thermal/omap-bandgap.c
@@ -437,7 +437,7 @@ static inline int omap_bandgap_validate(struct omap_bandgap *bg_ptr, int id)
  * returns 0 on success or the proper error code
  */
 int omap_bandgap_read_thot(struct omap_bandgap *bg_ptr, int id,
-			      int *thot)
+			   int *thot)
 {
 	struct temp_sensor_registers *tsr;
 	u32 temp;
@@ -512,7 +512,7 @@ int omap_bandgap_write_thot(struct omap_bandgap *bg_ptr, int id, int val)
  * returns 0 on success or the proper error code
  */
 int omap_bandgap_read_tcold(struct omap_bandgap *bg_ptr, int id,
-			       int *tcold)
+			    int *tcold)
 {
 	struct temp_sensor_registers *tsr;
 	u32 temp;
@@ -617,7 +617,7 @@ int omap_bandgap_read_update_interval(struct omap_bandgap *bg_ptr, int id,
  * returns 0 on success or the proper error code
  */
 int omap_bandgap_write_update_interval(struct omap_bandgap *bg_ptr,
-					  int id, u32 interval)
+				       int id, u32 interval)
 {
 	int ret = omap_bandgap_validate(bg_ptr, id);
 	if (ret)
@@ -643,7 +643,7 @@ int omap_bandgap_write_update_interval(struct omap_bandgap *bg_ptr,
  * returns 0 on success or the proper error code
  */
 int omap_bandgap_read_temperature(struct omap_bandgap *bg_ptr, int id,
-				     int *temperature)
+				  int *temperature)
 {
 	struct temp_sensor_registers *tsr;
 	u32 temp;
@@ -677,7 +677,7 @@ int omap_bandgap_read_temperature(struct omap_bandgap *bg_ptr, int id,
  * returns 0 on success or the proper error code
  */
 int omap_bandgap_set_sensor_data(struct omap_bandgap *bg_ptr, int id,
-				void *data)
+				 void *data)
 {
 	int ret = omap_bandgap_validate(bg_ptr, id);
 	if (ret)
@@ -762,7 +762,7 @@ static int enable_continuous_mode(struct omap_bandgap *bg_ptr)
 }
 
 static int omap_bandgap_tshut_init(struct omap_bandgap *bg_ptr,
-				      struct platform_device *pdev)
+				   struct platform_device *pdev)
 {
 	int gpio_nr = bg_ptr->tshut_gpio;
 	int status;
@@ -795,7 +795,7 @@ static int omap_bandgap_tshut_init(struct omap_bandgap *bg_ptr,
 
 /* Initialization of Talert. Call it only if HAS(TALERT) is set */
 static int omap_bandgap_talert_init(struct omap_bandgap *bg_ptr,
-				       struct platform_device *pdev)
+				    struct platform_device *pdev)
 {
 	int ret;
 
@@ -855,7 +855,7 @@ static struct omap_bandgap *omap_bandgap_build(struct platform_device *pdev)
 			bg_ptr->base = chunk;
 		if (IS_ERR(chunk))
 			return ERR_CAST(chunk);
-		
+
 		i++;
 	} while (res);
 
@@ -1108,9 +1108,8 @@ static int omap_bandgap_restore_ctxt(struct omap_bandgap *bg_ptr)
 			val = omap_bandgap_readl(bg_ptr, tsr->bgap_counter);
 
 		if (OMAP_BANDGAP_HAS(bg_ptr, TSHUT_CONFIG))
-			omap_bandgap_writel(bg_ptr,
-				rval->tshut_threshold,
-					   tsr->tshut_threshold);
+			omap_bandgap_writel(bg_ptr, rval->tshut_threshold,
+					    tsr->tshut_threshold);
 		/* Force immediate temperature measurement and update
 		 * of the DTEMP field
 		 */
@@ -1118,16 +1117,15 @@ static int omap_bandgap_restore_ctxt(struct omap_bandgap *bg_ptr)
 
 		if (OMAP_BANDGAP_HAS(bg_ptr, COUNTER))
 			omap_bandgap_writel(bg_ptr, rval->bg_counter,
-						   tsr->bgap_counter);
+					    tsr->bgap_counter);
 		if (OMAP_BANDGAP_HAS(bg_ptr, MODE_CONFIG))
 			omap_bandgap_writel(bg_ptr, rval->bg_mode_ctrl,
-						   tsr->bgap_mode_ctrl);
+					    tsr->bgap_mode_ctrl);
 		if (OMAP_BANDGAP_HAS(bg_ptr, TALERT)) {
-			omap_bandgap_writel(bg_ptr,
-						   rval->bg_threshold,
-						   tsr->bgap_threshold);
+			omap_bandgap_writel(bg_ptr, rval->bg_threshold,
+					    tsr->bgap_threshold);
 			omap_bandgap_writel(bg_ptr, rval->bg_ctrl,
-						   tsr->bgap_mask_ctrl);
+					    tsr->bgap_mask_ctrl);
 		}
 	}
 
-- 
1.7.7.1.488.ge8e1c

