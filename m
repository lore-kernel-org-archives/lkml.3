Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932726Ab3CSO7V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 10:59:21 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:35041 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932171Ab3CSO7R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 10:59:17 -0400
From: Eduardo Valentin <eduardo.valentin@ti.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-pm@vger.kernel.org>,
        Eduardo Valentin <eduardo.valentin@ti.com>
Subject: [PATCHv2 12/12] staging: ti-soc-thermal: propagate error code
Date: Tue, 19 Mar 2013 10:54:28 -0400
Message-ID: <1363704868-11843-13-git-send-email-eduardo.valentin@ti.com>
X-Mailer: git-send-email 1.7.7.1.488.ge8e1c
In-Reply-To: <1363704868-11843-1-git-send-email-eduardo.valentin@ti.com>
References: <1363704868-11843-1-git-send-email-eduardo.valentin@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While writing talert thresholds, propagate the error code from
ti_bandgap_update_alert_threshold to the caller of
_ti_bandgap_write_threshold.

Signed-off-by: Eduardo Valentin <eduardo.valentin@ti.com>
---
 drivers/staging/ti-soc-thermal/ti-bandgap.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/ti-soc-thermal/ti-bandgap.c b/drivers/staging/ti-soc-thermal/ti-bandgap.c
index 5c946cd..d479e50 100644
--- a/drivers/staging/ti-soc-thermal/ti-bandgap.c
+++ b/drivers/staging/ti-soc-thermal/ti-bandgap.c
@@ -511,7 +511,7 @@ static int _ti_bandgap_write_threshold(struct ti_bandgap *bgp, int id, int val,
 		goto exit;
 
 	spin_lock(&bgp->lock);
-	ti_bandgap_update_alert_threshold(bgp, id, adc_val, hot);
+	ret = ti_bandgap_update_alert_threshold(bgp, id, adc_val, hot);
 	spin_unlock(&bgp->lock);
 
 exit:
-- 
1.7.7.1.488.ge8e1c

