Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755194Ab3CONP3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 09:15:29 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:50542 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754384Ab3CONP0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 09:15:26 -0400
From: Eduardo Valentin <eduardo.valentin@ti.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-pm@vger.kernel.org>,
        Eduardo Valentin <eduardo.valentin@ti.com>
Subject: [PATCH 39/50] staging: omap-thermal: document omap_bandgap_update_alert_threshold function
Date: Fri, 15 Mar 2013 09:00:27 -0400
Message-ID: <1363352438-15935-40-git-send-email-eduardo.valentin@ti.com>
X-Mailer: git-send-email 1.7.7.1.488.ge8e1c
In-Reply-To: <1363352438-15935-1-git-send-email-eduardo.valentin@ti.com>
References: <1363352438-15935-1-git-send-email-eduardo.valentin@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Document function to program alert thresholds

Signed-off-by: Eduardo Valentin <eduardo.valentin@ti.com>
---
 drivers/staging/omap-thermal/omap-bandgap.c |   14 ++++++++++++++
 1 files changed, 14 insertions(+), 0 deletions(-)

diff --git a/drivers/staging/omap-thermal/omap-bandgap.c b/drivers/staging/omap-thermal/omap-bandgap.c
index 065f371..0eb21b3 100644
--- a/drivers/staging/omap-thermal/omap-bandgap.c
+++ b/drivers/staging/omap-thermal/omap-bandgap.c
@@ -370,6 +370,20 @@ static void omap_bandgap_unmask_interrupts(struct omap_bandgap *bg_ptr, int id,
 	omap_bandgap_writel(bg_ptr, reg_val, tsr->bgap_mask_ctrl);
 }
 
+/**
+ * omap_bandgap_update_alert_threshold() - sequence to update thresholds
+ * @bg_ptr: struct omap_bandgap pointer
+ * @id: bandgap sensor id
+ * @val: value (ADC) of a new threshold
+ * @hot: desired threshold to be updated. true if threshold hot, false if
+ *       threshold cold
+ *
+ * It will program the required thresholds (hot and cold) for TALERT signal.
+ * This function can be used to update t_hot or t_cold, depending on @hot value.
+ * It checks the resulting t_hot and t_cold values, based on the new passed @val
+ * and configures the thresholds so that t_hot is always greater than t_cold.
+ * Call this function only if bandgap features HAS(TALERT).
+ */
 static
 int omap_bandgap_update_alert_threshold(struct omap_bandgap *bg_ptr, int id,
 					int val, bool hot)
-- 
1.7.7.1.488.ge8e1c

