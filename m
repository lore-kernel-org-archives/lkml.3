Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755044Ab3CONMf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 09:12:35 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:42682 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754833Ab3CONMd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 09:12:33 -0400
From: Eduardo Valentin <eduardo.valentin@ti.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-pm@vger.kernel.org>,
        Eduardo Valentin <eduardo.valentin@ti.com>
Subject: [PATCH 31/50] staging: omap-thermal: refactor temp_sensor_unmask_interrupts
Date: Fri, 15 Mar 2013 09:00:19 -0400
Message-ID: <1363352438-15935-32-git-send-email-eduardo.valentin@ti.com>
X-Mailer: git-send-email 1.7.7.1.488.ge8e1c
In-Reply-To: <1363352438-15935-1-git-send-email-eduardo.valentin@ti.com>
References: <1363352438-15935-1-git-send-email-eduardo.valentin@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This change improves temp_sensor_unmask_interrupts by:
. renaming it to omap_bandgap_unmask_interrupts
. making it a void function, as there is nothing really to report an error.

Signed-off-by: Eduardo Valentin <eduardo.valentin@ti.com>
---
 drivers/staging/omap-thermal/omap-bandgap.c |   14 ++++++++------
 1 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/omap-thermal/omap-bandgap.c b/drivers/staging/omap-thermal/omap-bandgap.c
index f86c104..26d36f3 100644
--- a/drivers/staging/omap-thermal/omap-bandgap.c
+++ b/drivers/staging/omap-thermal/omap-bandgap.c
@@ -338,8 +338,8 @@ exit:
 /***   Helper functions handling device Alert/Shutdown signals   ***/
 
 /* Talert masks. Call it only if HAS(TALERT) is set */
-static int temp_sensor_unmask_interrupts(struct omap_bandgap *bg_ptr, int id,
-					 u32 t_hot, u32 t_cold)
+static void omap_bandgap_unmask_interrupts(struct omap_bandgap *bg_ptr, int id,
+					   u32 t_hot, u32 t_cold)
 {
 	struct temp_sensor_registers *tsr;
 	u32 temp, reg_val;
@@ -360,8 +360,6 @@ static int temp_sensor_unmask_interrupts(struct omap_bandgap *bg_ptr, int id,
 	else
 		reg_val &= ~tsr->mask_cold_mask;
 	omap_bandgap_writel(bg_ptr, reg_val, tsr->bgap_mask_ctrl);
-
-	return 0;
 }
 
 /* Talert Thot threshold. Call it only if HAS(TALERT) is set */
@@ -399,7 +397,9 @@ int temp_sensor_configure_thot(struct omap_bandgap *bg_ptr, int id, int t_hot)
 		return -EIO;
 	}
 
-	return temp_sensor_unmask_interrupts(bg_ptr, id, t_hot, cold);
+	omap_bandgap_unmask_interrupts(bg_ptr, id, t_hot, cold);
+
+	return 0;
 }
 
 /* Talert Tcold threshold. Call it only if HAS(TALERT) is set */
@@ -438,7 +438,9 @@ int temp_sensor_configure_tcold(struct omap_bandgap *bg_ptr, int id,
 		return -EIO;
 	}
 
-	return temp_sensor_unmask_interrupts(bg_ptr, id, hot, t_cold);
+	omap_bandgap_unmask_interrupts(bg_ptr, id, hot, t_cold);
+
+	return 0;
 }
 
 #define bandgap_is_valid(b)						\
-- 
1.7.7.1.488.ge8e1c

