Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932693Ab3CSO6i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 10:58:38 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:55089 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755762Ab3CSO6g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 10:58:36 -0400
From: Eduardo Valentin <eduardo.valentin@ti.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-pm@vger.kernel.org>,
        Eduardo Valentin <eduardo.valentin@ti.com>
Subject: [PATCHv2 10/12] staging: ti-soc-thermal: fix condition to apply hyst
Date: Tue, 19 Mar 2013 10:54:26 -0400
Message-ID: <1363704868-11843-11-git-send-email-eduardo.valentin@ti.com>
X-Mailer: git-send-email 1.7.7.1.488.ge8e1c
In-Reply-To: <1363704868-11843-1-git-send-email-eduardo.valentin@ti.com>
References: <1363704868-11843-1-git-send-email-eduardo.valentin@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While updating talert thresholds, threshold cold must
always be lower than threshold hot. This patch fixes
the function ti_bandgap_update_alert_threshold to only
change the thresholds by applying a hysteresis when
they violate this condition.

Signed-off-by: Eduardo Valentin <eduardo.valentin@ti.com>
---
 drivers/staging/ti-soc-thermal/ti-bandgap.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/ti-soc-thermal/ti-bandgap.c b/drivers/staging/ti-soc-thermal/ti-bandgap.c
index a9d6d2a..d075186 100644
--- a/drivers/staging/ti-soc-thermal/ti-bandgap.c
+++ b/drivers/staging/ti-soc-thermal/ti-bandgap.c
@@ -406,7 +406,7 @@ static int ti_bandgap_update_alert_threshold(struct ti_bandgap *bgp, int id,
 	else
 		t_cold = val;
 
-	if (t_cold < t_hot) {
+	if (t_cold > t_hot) {
 		if (hot)
 			err = ti_bandgap_add_hyst(bgp, t_hot,
 						  -ts_data->hyst_val,
-- 
1.7.7.1.488.ge8e1c

