Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932494AbaEPNfo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 09:35:44 -0400
Received: from terminus.zytor.com ([198.137.202.10]:54220 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932470AbaEPNfl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 09:35:41 -0400
Date: Fri, 16 May 2014 06:34:45 -0700
From: tip-bot for Thomas Gleixner <tipbot@zytor.com>
Message-ID: <tip-094e873c2a0bd54ced4e98f1f6f612b1fc60f426@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, grant.likely@linaro.org, hpa@zytor.com,
        mingo@kernel.org, peterz@infradead.org, cmetcalf@tilera.com,
        tony.luck@intel.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, grant.likely@linaro.org,
        linux-kernel@vger.kernel.org, peterz@infradead.org,
        cmetcalf@tilera.com, tony.luck@intel.com, tglx@linutronix.de
In-Reply-To: <20140507154337.410843062@linutronix.de>
References: <20140507154337.410843062@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:irq/core] tile: net: Use irq_alloc/free_hwirq
Git-Commit-ID: 094e873c2a0bd54ced4e98f1f6f612b1fc60f426
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  094e873c2a0bd54ced4e98f1f6f612b1fc60f426
Gitweb:     http://git.kernel.org/tip/094e873c2a0bd54ced4e98f1f6f612b1fc60f426
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Wed, 7 May 2014 15:44:14 +0000
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Fri, 16 May 2014 14:05:20 +0200

tile: net: Use irq_alloc/free_hwirq

No functional change. Just convert to the new interface.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Grant Likely <grant.likely@linaro.org>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Acked-by: Chris Metcalf <cmetcalf@tilera.com>
Link: http://lkml.kernel.org/r/20140507154337.410843062@linutronix.de
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 drivers/net/ethernet/tile/tilegx.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/tile/tilegx.c b/drivers/net/ethernet/tile/tilegx.c
index 7e1c91d..449011b 100644
--- a/drivers/net/ethernet/tile/tilegx.c
+++ b/drivers/net/ethernet/tile/tilegx.c
@@ -1208,8 +1208,8 @@ static int tile_net_setup_interrupts(struct net_device *dev)
 
 	irq = md->ingress_irq;
 	if (irq < 0) {
-		irq = create_irq();
-		if (irq < 0) {
+		irq = irq_alloc_hwirq(-1);
+		if (!irq) {
 			netdev_err(dev,
 				   "create_irq failed: mpipe[%d] %d\n",
 				   instance, irq);
@@ -1223,7 +1223,7 @@ static int tile_net_setup_interrupts(struct net_device *dev)
 		if (rc != 0) {
 			netdev_err(dev, "request_irq failed: mpipe[%d] %d\n",
 				   instance, rc);
-			destroy_irq(irq);
+			irq_free_hwirq(irq);
 			return rc;
 		}
 		md->ingress_irq = irq;
