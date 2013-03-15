Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754698Ab3CONFu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 09:05:50 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:50088 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754195Ab3CONFs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 09:05:48 -0400
From: Eduardo Valentin <eduardo.valentin@ti.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-pm@vger.kernel.org>,
        Eduardo Valentin <eduardo.valentin@ti.com>
Subject: [PATCH 12/50] staging: omap-thermal: rename talert handler
Date: Fri, 15 Mar 2013 09:00:00 -0400
Message-ID: <1363352438-15935-13-git-send-email-eduardo.valentin@ti.com>
X-Mailer: git-send-email 1.7.7.1.488.ge8e1c
In-Reply-To: <1363352438-15935-1-git-send-email-eduardo.valentin@ti.com>
References: <1363352438-15935-1-git-send-email-eduardo.valentin@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Simple rename to cope with file naming pattern.

Signed-off-by: Eduardo Valentin <eduardo.valentin@ti.com>
---
 drivers/staging/omap-thermal/omap-bandgap.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/omap-thermal/omap-bandgap.c b/drivers/staging/omap-thermal/omap-bandgap.c
index 02817b5..1906ef1 100644
--- a/drivers/staging/omap-thermal/omap-bandgap.c
+++ b/drivers/staging/omap-thermal/omap-bandgap.c
@@ -147,7 +147,7 @@ static u32 omap_bandgap_read_temp(struct omap_bandgap *bg_ptr, int id)
 }
 
 /* This is the Talert handler. Call it only if HAS(TALERT) is set */
-static irqreturn_t talert_irq_handler(int irq, void *data)
+static irqreturn_t omap_bandgap_talert_irq_handler(int irq, void *data)
 {
 	struct omap_bandgap *bg_ptr = data;
 	struct temp_sensor_registers *tsr;
@@ -750,7 +750,7 @@ static int omap_bandgap_talert_init(struct omap_bandgap *bg_ptr,
 		return bg_ptr->irq;
 	}
 	ret = request_threaded_irq(bg_ptr->irq, NULL,
-				   talert_irq_handler,
+				   omap_bandgap_talert_irq_handler,
 				   IRQF_TRIGGER_HIGH | IRQF_ONESHOT,
 				   "talert", bg_ptr);
 	if (ret) {
-- 
1.7.7.1.488.ge8e1c

