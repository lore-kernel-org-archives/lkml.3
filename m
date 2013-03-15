Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754985Ab3CONPs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 09:15:48 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:42811 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754482Ab3CONPr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 09:15:47 -0400
From: Eduardo Valentin <eduardo.valentin@ti.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-pm@vger.kernel.org>,
        Eduardo Valentin <eduardo.valentin@ti.com>
Subject: [PATCH 40/50] staging: omap-thermal: document _omap_bandgap_write_threshold function
Date: Fri, 15 Mar 2013 09:00:28 -0400
Message-ID: <1363352438-15935-41-git-send-email-eduardo.valentin@ti.com>
X-Mailer: git-send-email 1.7.7.1.488.ge8e1c
In-Reply-To: <1363352438-15935-1-git-send-email-eduardo.valentin@ti.com>
References: <1363352438-15935-1-git-send-email-eduardo.valentin@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Document function to update alert thresholds.

Signed-off-by: Eduardo Valentin <eduardo.valentin@ti.com>
---
 drivers/staging/omap-thermal/omap-bandgap.c |   13 +++++++++++++
 1 files changed, 13 insertions(+), 0 deletions(-)

diff --git a/drivers/staging/omap-thermal/omap-bandgap.c b/drivers/staging/omap-thermal/omap-bandgap.c
index 0eb21b3..4cacfc1 100644
--- a/drivers/staging/omap-thermal/omap-bandgap.c
+++ b/drivers/staging/omap-thermal/omap-bandgap.c
@@ -455,6 +455,19 @@ exit:
 	return ret;
 }
 
+/**
+ * _omap_bandgap_write_threshold() - helper to update TALERT t_cold or t_hot
+ * @bg_ptr: struct omap_bandgap pointer
+ * @id: bandgap sensor id
+ * @val: value (mCelsius) of a new threshold
+ * @hot: desired threshold to be updated. true if threshold hot, false if
+ *       threshold cold
+ *
+ * It will update the required thresholds (hot and cold) for TALERT signal.
+ * This function can be used to update t_hot or t_cold, depending on @hot value.
+ * Validates the mCelsius range and update the requested threshold.
+ * Call this function only if bandgap features HAS(TALERT).
+ */
 int _omap_bandgap_write_threshold(struct omap_bandgap *bg_ptr, int id, int val,
 				  bool hot)
 {
-- 
1.7.7.1.488.ge8e1c

