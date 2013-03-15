Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754710Ab3CONGJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 09:06:09 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:59919 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754635Ab3CONGG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 09:06:06 -0400
From: Eduardo Valentin <eduardo.valentin@ti.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-pm@vger.kernel.org>,
        Eduardo Valentin <eduardo.valentin@ti.com>
Subject: [PATCH 13/50] staging: omap-thermal: update documentation for talert irq handler
Date: Fri, 15 Mar 2013 09:00:01 -0400
Message-ID: <1363352438-15935-14-git-send-email-eduardo.valentin@ti.com>
X-Mailer: git-send-email 1.7.7.1.488.ge8e1c
In-Reply-To: <1363352438-15935-1-git-send-email-eduardo.valentin@ti.com>
References: <1363352438-15935-1-git-send-email-eduardo.valentin@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Document the Talert IRQ handler.

Signed-off-by: Eduardo Valentin <eduardo.valentin@ti.com>
---
 drivers/staging/omap-thermal/omap-bandgap.c |   12 +++++++++++-
 1 files changed, 11 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/omap-thermal/omap-bandgap.c b/drivers/staging/omap-thermal/omap-bandgap.c
index 1906ef1..aa60b7b 100644
--- a/drivers/staging/omap-thermal/omap-bandgap.c
+++ b/drivers/staging/omap-thermal/omap-bandgap.c
@@ -146,7 +146,17 @@ static u32 omap_bandgap_read_temp(struct omap_bandgap *bg_ptr, int id)
 	return temp;
 }
 
-/* This is the Talert handler. Call it only if HAS(TALERT) is set */
+/**
+ * omap_bandgap_talert_irq_handler() - handles Temperature alert IRQs
+ * @irq: IRQ number
+ * @data: private data (struct omap_bandgap *)
+ *
+ * This is the Talert handler. Use it only if bandgap device features
+ * HAS(TALERT). This handler goes over all sensors and checks their
+ * conditions and acts accordingly. In case there are events pending,
+ * it will reset the event mask to wait for the opposite event (next event).
+ * Every time there is a new event, it will be reported to thermal layer.
+ */
 static irqreturn_t omap_bandgap_talert_irq_handler(int irq, void *data)
 {
 	struct omap_bandgap *bg_ptr = data;
-- 
1.7.7.1.488.ge8e1c

