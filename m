Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933582AbaFLL41 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 07:56:27 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:58205 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933545AbaFLL4V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 07:56:21 -0400
From: Sricharan R <r.sricharan@ti.com>
To: <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: <tony@atomide.com>, <santosh.shilimkar@ti.com>, <nm@ti.com>,
        <rnayak@ti.com>, <linux@arm.linux.org.uk>, <r.sricharan@ti.com>,
        <tglx@linutronix.de>, <jason@lakedaemon.net>
Subject: [PATCH V2 05/19] irqchip: crossbar: Change allocation logic by reversing search for free irqs
Date: Thu, 12 Jun 2014 17:23:13 +0530
Message-ID: <1402574007-13987-6-git-send-email-r.sricharan@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1402574007-13987-1-git-send-email-r.sricharan@ti.com>
References: <1402574007-13987-1-git-send-email-r.sricharan@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nishanth Menon <nm@ti.com>

Reverse the search algorithm to ensure that address mapping and IRQ
allocation logics are proper. This can open up new bugs which are
easily fixable rather than wait till allocation logic approaches
the limit to find new bugs.

Signed-off-by: Nishanth Menon <nm@ti.com>
Signed-off-by: Sricharan R <r.sricharan@ti.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
---
 drivers/irqchip/irq-crossbar.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/irqchip/irq-crossbar.c b/drivers/irqchip/irq-crossbar.c
index 287d3ce..de021638 100644
--- a/drivers/irqchip/irq-crossbar.c
+++ b/drivers/irqchip/irq-crossbar.c
@@ -68,7 +68,7 @@ static inline int get_prev_map_irq(int cb_no)
 {
 	int i;
 
-	for (i = 0; i < cb->int_max; i++)
+	for (i = cb->int_max - 1; i >= 0; i--)
 		if (cb->irq_map[i] == cb_no)
 			return i;
 
@@ -79,7 +79,7 @@ static inline int allocate_free_irq(int cb_no)
 {
 	int i;
 
-	for (i = 0; i < cb->int_max; i++) {
+	for (i = cb->int_max - 1; i >= 0; i--) {
 		if (cb->irq_map[i] == IRQ_FREE) {
 			cb->irq_map[i] = cb_no;
 			return i;
-- 
1.7.9.5

