Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752715AbaBWVnE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Feb 2014 16:43:04 -0500
Received: from www.linutronix.de ([62.245.132.108]:52323 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752345AbaBWVkM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Feb 2014 16:40:12 -0500
Message-Id: <20140223212738.808648133@linutronix.de>
User-Agent: quilt/0.60-1
Date: Sun, 23 Feb 2014 21:40:21 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Xen <xen-devel@lists.xenproject.org>
Subject: [patch 23/26] xen: Add proper irq accounting for HYPERCALL vector
References: <20140223212703.511977310@linutronix.de>
Content-Disposition: inline; filename=xen-use-vector-accounting.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Xen <xen-devel@lists.xenproject.org>
---
 drivers/xen/events/events_base.c |    1 +
 1 file changed, 1 insertion(+)

Index: tip/drivers/xen/events/events_base.c
===================================================================
--- tip.orig/drivers/xen/events/events_base.c
+++ tip/drivers/xen/events/events_base.c
@@ -1239,6 +1239,7 @@ void xen_evtchn_do_upcall(struct pt_regs
 #ifdef CONFIG_X86
 	exit_idle();
 #endif
+	inc_irq_stat(irq_hv_callback_count);
 
 	__xen_evtchn_do_upcall();
 


