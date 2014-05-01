Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752998AbaEAAuK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 20:50:10 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.228]:61716 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751092AbaEAAuG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 20:50:06 -0400
Message-Id: <20140501005004.406079574@goodmis.org>
User-Agent: quilt/0.61-1
Date: Wed, 30 Apr 2014 20:47:59 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        John Kacur <jkacur@redhat.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [PATCH RT 2/3] net: gianfar: Fix missing return of gfar_clean_tx_ring()
References: <20140501004757.583708392@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline; filename=0002-net-gianfar-Fix-missing-return-of-gfar_clean_tx_ring.patch
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12.15-rt26-rc1 stable review patch.
If anyone has any objections, please let me know.

------------------

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

The patch "net: gianfar: do not try to cleanup TX packets if they are
not done" for 3.12-rt left out the return value for gfar_clean_tx_ring().
This would cause an error when building this module. Note, this module
does not build on x86 and was not tested because of that.

Reported-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/net/ethernet/freescale/gianfar.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/freescale/gianfar.c b/drivers/net/ethernet/freescale/gianfar.c
index 091945c..df27493 100644
--- a/drivers/net/ethernet/freescale/gianfar.c
+++ b/drivers/net/ethernet/freescale/gianfar.c
@@ -2615,6 +2615,7 @@ static int gfar_clean_tx_ring(struct gfar_priv_tx_q *tx_queue)
 	tx_queue->dirty_tx = bdp;
 
 	netdev_tx_completed_queue(txq, howmany, bytes_sent);
+	return howmany;
 }
 
 static void gfar_schedule_cleanup(struct gfar_priv_grp *gfargrp)
-- 
1.8.5.3


