Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932699Ab3CSO67 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 10:58:59 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:56894 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932223Ab3CSO64 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 10:58:56 -0400
From: Eduardo Valentin <eduardo.valentin@ti.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-pm@vger.kernel.org>,
        Eduardo Valentin <eduardo.valentin@ti.com>
Subject: [PATCHv2 11/12] staging: ti-soc-thermal: fix bitfield writing while updating thresholds
Date: Tue, 19 Mar 2013 10:54:27 -0400
Message-ID: <1363704868-11843-12-git-send-email-eduardo.valentin@ti.com>
X-Mailer: git-send-email 1.7.7.1.488.ge8e1c
In-Reply-To: <1363704868-11843-1-git-send-email-eduardo.valentin@ti.com>
References: <1363704868-11843-1-git-send-email-eduardo.valentin@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Wrong threshold cold values may be written with current implementation.
This patch fixes the threshold update function by simplifying the
bitfield manipulation sequence.

Signed-off-by: Eduardo Valentin <eduardo.valentin@ti.com>
---
 drivers/staging/ti-soc-thermal/ti-bandgap.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/ti-soc-thermal/ti-bandgap.c b/drivers/staging/ti-soc-thermal/ti-bandgap.c
index d075186..5c946cd 100644
--- a/drivers/staging/ti-soc-thermal/ti-bandgap.c
+++ b/drivers/staging/ti-soc-thermal/ti-bandgap.c
@@ -418,10 +418,10 @@ static int ti_bandgap_update_alert_threshold(struct ti_bandgap *bgp, int id,
 	}
 
 	/* write the new threshold values */
-	reg_val = thresh_val & ~tsr->threshold_thot_mask;
-	reg_val |= (t_hot << __ffs(tsr->threshold_thot_mask));
-	reg_val |= thresh_val & ~tsr->threshold_tcold_mask;
-	reg_val |= (t_cold << __ffs(tsr->threshold_tcold_mask));
+	reg_val = thresh_val &
+		  ~(tsr->threshold_thot_mask | tsr->threshold_tcold_mask);
+	reg_val |= (t_hot << __ffs(tsr->threshold_thot_mask)) |
+		   (t_cold << __ffs(tsr->threshold_tcold_mask));
 	ti_bandgap_writel(bgp, reg_val, tsr->bgap_threshold);
 
 	if (err) {
-- 
1.7.7.1.488.ge8e1c

