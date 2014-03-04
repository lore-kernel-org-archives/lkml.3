Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755574AbaCDQn1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 11:43:27 -0500
Received: from terminus.zytor.com ([198.137.202.10]:41626 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754350AbaCDQnX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 11:43:23 -0500
Date: Tue, 4 Mar 2014 08:42:48 -0800
From: tip-bot for Thomas Gleixner <tipbot@zytor.com>
Message-ID: <tip-99c8b79d3c165f8e2a6247c14bfa1429e7efe51f@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        konrad.wilk@oracle.com, peterz@infradead.org,
        xen-devel@lists.xenproject.org, tglx@linutronix.de,
        david.vrabel@citrix.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        konrad.wilk@oracle.com, peterz@infradead.org,
        xen-devel@lists.xenproject.org, tglx@linutronix.de,
        david.vrabel@citrix.com
In-Reply-To: <20140223212738.808648133@linutronix.de>
References: <20140223212738.808648133@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:irq/core] xen:
  Add proper irq accounting for HYPERCALL vector
Git-Commit-ID: 99c8b79d3c165f8e2a6247c14bfa1429e7efe51f
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

Commit-ID:  99c8b79d3c165f8e2a6247c14bfa1429e7efe51f
Gitweb:     http://git.kernel.org/tip/99c8b79d3c165f8e2a6247c14bfa1429e7efe51f
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Sun, 23 Feb 2014 21:40:21 +0000
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Tue, 4 Mar 2014 17:37:54 +0100

xen: Add proper irq accounting for HYPERCALL vector

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: David Vrabel <david.vrabel@citrix.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Xen <xen-devel@lists.xenproject.org>
Link: http://lkml.kernel.org/r/20140223212738.808648133@linutronix.de
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 drivers/xen/events/events_base.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/xen/events/events_base.c b/drivers/xen/events/events_base.c
index 5dd2ddf..8b91c256 100644
--- a/drivers/xen/events/events_base.c
+++ b/drivers/xen/events/events_base.c
@@ -1235,6 +1235,7 @@ void xen_evtchn_do_upcall(struct pt_regs *regs)
 #ifdef CONFIG_X86
 	exit_idle();
 #endif
+	inc_irq_stat(irq_hv_callback_count);
 
 	__xen_evtchn_do_upcall();
 
