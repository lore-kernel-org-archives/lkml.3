Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758432AbaCEPgE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 10:36:04 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:40706 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755970AbaCEOY1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 09:24:27 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Jason Cooper <jason@lakedaemon.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 004/131] irqchip: orion: use handle_edge_irq on bridge irqs
Date: Wed,  5 Mar 2014 14:22:08 +0000
Message-Id: <1394029455-23128-5-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1394029455-23128-1-git-send-email-luis.henriques@canonical.com>
References: <1394029455-23128-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.6 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>

commit 5f40067fc86f0e49329ad4a852c278998ff4394e upstream.

Bridge irqs are edge-triggered, i.e. they get asserted on low-to-high
transitions and not on the level of the downstream interrupt line.
This replaces handle_level_irq by the more appropriate handle_edge_irq.

Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Tested-by: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
Signed-off-by: Jason Cooper <jason@lakedaemon.net>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/irqchip/irq-orion.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/irqchip/irq-orion.c b/drivers/irqchip/irq-orion.c
index 4137c3d..1f636f7 100644
--- a/drivers/irqchip/irq-orion.c
+++ b/drivers/irqchip/irq-orion.c
@@ -143,7 +143,7 @@ static int __init orion_bridge_irq_init(struct device_node *np,
 	}
 
 	ret = irq_alloc_domain_generic_chips(domain, nrirqs, 1, np->name,
-			     handle_level_irq, clr, 0, IRQ_GC_INIT_MASK_CACHE);
+			     handle_edge_irq, clr, 0, IRQ_GC_INIT_MASK_CACHE);
 	if (ret) {
 		pr_err("%s: unable to alloc irq domain gc\n", np->name);
 		return ret;
-- 
1.9.0

