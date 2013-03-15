Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754643Ab3CONGb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 09:06:31 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:42424 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754228Ab3CONG2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 09:06:28 -0400
From: Eduardo Valentin <eduardo.valentin@ti.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-pm@vger.kernel.org>,
        Eduardo Valentin <eduardo.valentin@ti.com>
Subject: [PATCH 14/50] staging: omap-thermal: update tshut IRQ handler documentation
Date: Fri, 15 Mar 2013 09:00:02 -0400
Message-ID: <1363352438-15935-15-git-send-email-eduardo.valentin@ti.com>
X-Mailer: git-send-email 1.7.7.1.488.ge8e1c
In-Reply-To: <1363352438-15935-1-git-send-email-eduardo.valentin@ti.com>
References: <1363352438-15935-1-git-send-email-eduardo.valentin@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Documents tshut handler better.

Signed-off-by: Eduardo Valentin <eduardo.valentin@ti.com>
---
 drivers/staging/omap-thermal/omap-bandgap.c |   10 +++++++++-
 1 files changed, 9 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/omap-thermal/omap-bandgap.c b/drivers/staging/omap-thermal/omap-bandgap.c
index aa60b7b..d0db361 100644
--- a/drivers/staging/omap-thermal/omap-bandgap.c
+++ b/drivers/staging/omap-thermal/omap-bandgap.c
@@ -207,7 +207,15 @@ static irqreturn_t omap_bandgap_talert_irq_handler(int irq, void *data)
 	return IRQ_HANDLED;
 }
 
-/* This is the Tshut handler. Call it only if HAS(TSHUT) is set */
+/**
+ * omap_bandgap_tshut_irq_handler() - handles Temperature shutdown signal
+ * @irq: IRQ number
+ * @data: private data (unused)
+ *
+ * This is the Tshut handler. Use it only if bandgap device features
+ * HAS(TSHUT). If any sensor fires the Tshut signal, we simply shutdown
+ * the system.
+ */
 static irqreturn_t omap_bandgap_tshut_irq_handler(int irq, void *data)
 {
 	pr_emerg("%s: TSHUT temperature reached. Needs shut down...\n",
-- 
1.7.7.1.488.ge8e1c

