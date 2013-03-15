Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755155Ab3CONRF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 09:17:05 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:42875 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754717Ab3CONRB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 09:17:01 -0400
From: Eduardo Valentin <eduardo.valentin@ti.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-pm@vger.kernel.org>,
        Eduardo Valentin <eduardo.valentin@ti.com>
Subject: [PATCH 43/50] staging: omap-thermal: document omap_bandgap_alert_init function
Date: Fri, 15 Mar 2013 09:00:31 -0400
Message-ID: <1363352438-15935-44-git-send-email-eduardo.valentin@ti.com>
X-Mailer: git-send-email 1.7.7.1.488.ge8e1c
In-Reply-To: <1363352438-15935-1-git-send-email-eduardo.valentin@ti.com>
References: <1363352438-15935-1-git-send-email-eduardo.valentin@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Document function that sets talert handling up.

Signed-off-by: Eduardo Valentin <eduardo.valentin@ti.com>
---
 drivers/staging/omap-thermal/omap-bandgap.c |   12 +++++++++++-
 1 files changed, 11 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/omap-thermal/omap-bandgap.c b/drivers/staging/omap-thermal/omap-bandgap.c
index f2ebbcf..3150ec2 100644
--- a/drivers/staging/omap-thermal/omap-bandgap.c
+++ b/drivers/staging/omap-thermal/omap-bandgap.c
@@ -842,7 +842,17 @@ static int omap_bandgap_tshut_init(struct omap_bandgap *bg_ptr,
 	return 0;
 }
 
-/* Initialization of Talert. Call it only if HAS(TALERT) is set */
+/**
+ * omap_bandgap_alert_init() - setup and initialize talert handling
+ * @bg_ptr: pointer to struct omap_bandgap
+ * @pdev: pointer to device struct platform_device
+ *
+ * Call this function only in case the bandgap features HAS(TALERT).
+ * In this case, the driver needs to handle the TALERT signals as an IRQs.
+ * TALERT is a normal IRQ and it is fired any time thresholds (hot or cold)
+ * are violated. In these situation, the driver must reprogram the thresholds,
+ * accordingly to specified policy.
+ */
 static int omap_bandgap_talert_init(struct omap_bandgap *bg_ptr,
 				    struct platform_device *pdev)
 {
-- 
1.7.7.1.488.ge8e1c

