Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757524Ab3KZQMv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 11:12:51 -0500
Received: from merlin.infradead.org ([205.233.59.134]:51457 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757176Ab3KZQL4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 11:11:56 -0500
Message-Id: <20131126160815.225776365@infradead.org>
User-Agent: quilt/0.60-1
Date: Tue, 26 Nov 2013 16:57:49 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Arjan van de Ven <arjan@linux.intel.com>, lenb@kernel.org,
        rjw@rjwysocki.net, Eliezer Tamir <eliezer.tamir@linux.intel.com>,
        David Miller <davem@davemloft.net>, rui.zhang@intel.com,
        jacob.jun.pan@linux.intel.com, Mike Galbraith <bitbucket@online.de>,
        Ingo Molnar <mingo@kernel.org>, hpa@zytor.com,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org
Subject: [PATCH 6/8] sched, net: Clean up preempt_enable_no_resched() abuse
References: <20131126155743.116756708@infradead.org>
Content-Disposition: inline; filename=peterz-fixup-weird-preempt_enable_no_resched-usage.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The only valid use of preempt_enable_no_resched() is if the very next
line is schedule() or if we know preemption cannot actually be enabled
by that statement due to known more preempt_count 'refs'.

Cc: rjw@rjwysocki.net
Cc: Eliezer Tamir <eliezer.tamir@linux.intel.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: rui.zhang@intel.com
Cc: jacob.jun.pan@linux.intel.com
Cc: Mike Galbraith <bitbucket@online.de>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: hpa@zytor.com
Cc: Arjan van de Ven <arjan@linux.intel.com>
Cc: lenb@kernel.org
Reviewed-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
---
 net/ipv4/tcp.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -1623,11 +1623,11 @@ int tcp_recvmsg(struct kiocb *iocb, stru
 		    (len > sysctl_tcp_dma_copybreak) && !(flags & MSG_PEEK) &&
 		    !sysctl_tcp_low_latency &&
 		    net_dma_find_channel()) {
-			preempt_enable_no_resched();
+			preempt_enable();
 			tp->ucopy.pinned_list =
 					dma_pin_iovec_pages(msg->msg_iov, len);
 		} else {
-			preempt_enable_no_resched();
+			preempt_enable();
 		}
 	}
 #endif


