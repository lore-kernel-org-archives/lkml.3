Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757244Ab3CZRwg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 13:52:36 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:19974 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754115Ab3CZRgS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 13:36:18 -0400
X-Authority-Analysis: v=2.0 cv=adbjbGUt c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=XY_mKlObOv8A:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=PGGIfaL_V7wA:10 a=20KFwNOVAAAA:8 a=J1Y8HTJGAAAA:8 a=yPCof4ZbAAAA:8 a=rlM5k4joIV07hRHhbZUA:9 a=jEp0ucaQiEUA:10 a=4N9Db7Z2_RYA:10 a=7DSvI1NPTFQA:10 a=IS8BmV_1iA_GHX23:21 a=ty65u-AFVYq9tcgi:21 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130326173607.477574704@goodmis.org>
User-Agent: quilt/0.60-1
Date: Tue, 26 Mar 2013 13:21:46 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Dave Jones <davej@redhat.com>, "David S. Miller" <davem@davemloft.net>,
        Venkat Venkatsubra <venkat.x.venkatsubra@oracle.com>,
        Cong Wang <amwang@redhat.com>
Subject: [PATCH 47/86] rds: limit the size allocated by rds_message_alloc()
References: <20130326172059.136127374@goodmis.org>
Content-Disposition: inline; filename=0047-rds-limit-the-size-allocated-by-rds_message_alloc.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.1 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Cong Wang <amwang@redhat.com>

[ Upstream commit ece6b0a2b25652d684a7ced4ae680a863af041e0 ]

Dave Jones reported the following bug:

"When fed mangled socket data, rds will trust what userspace gives it,
and tries to allocate enormous amounts of memory larger than what
kmalloc can satisfy."

WARNING: at mm/page_alloc.c:2393 __alloc_pages_nodemask+0xa0d/0xbe0()
Hardware name: GA-MA78GM-S2H
Modules linked in: vmw_vsock_vmci_transport vmw_vmci vsock fuse bnep dlci bridge 8021q garp stp mrp binfmt_misc l2tp_ppp l2tp_core rfcomm s
Pid: 24652, comm: trinity-child2 Not tainted 3.8.0+ #65
Call Trace:
 [<ffffffff81044155>] warn_slowpath_common+0x75/0xa0
 [<ffffffff8104419a>] warn_slowpath_null+0x1a/0x20
 [<ffffffff811444ad>] __alloc_pages_nodemask+0xa0d/0xbe0
 [<ffffffff8100a196>] ? native_sched_clock+0x26/0x90
 [<ffffffff810b2128>] ? trace_hardirqs_off_caller+0x28/0xc0
 [<ffffffff810b21cd>] ? trace_hardirqs_off+0xd/0x10
 [<ffffffff811861f8>] alloc_pages_current+0xb8/0x180
 [<ffffffff8113eaaa>] __get_free_pages+0x2a/0x80
 [<ffffffff811934fe>] kmalloc_order_trace+0x3e/0x1a0
 [<ffffffff81193955>] __kmalloc+0x2f5/0x3a0
 [<ffffffff8104df0c>] ? local_bh_enable_ip+0x7c/0xf0
 [<ffffffffa0401ab3>] rds_message_alloc+0x23/0xb0 [rds]
 [<ffffffffa04043a1>] rds_sendmsg+0x2b1/0x990 [rds]
 [<ffffffff810b21cd>] ? trace_hardirqs_off+0xd/0x10
 [<ffffffff81564620>] sock_sendmsg+0xb0/0xe0
 [<ffffffff810b2052>] ? get_lock_stats+0x22/0x70
 [<ffffffff810b24be>] ? put_lock_stats.isra.23+0xe/0x40
 [<ffffffff81567f30>] sys_sendto+0x130/0x180
 [<ffffffff810b872d>] ? trace_hardirqs_on+0xd/0x10
 [<ffffffff816c547b>] ? _raw_spin_unlock_irq+0x3b/0x60
 [<ffffffff816cd767>] ? sysret_check+0x1b/0x56
 [<ffffffff810b8695>] ? trace_hardirqs_on_caller+0x115/0x1a0
 [<ffffffff81341d8e>] ? trace_hardirqs_on_thunk+0x3a/0x3f
 [<ffffffff816cd742>] system_call_fastpath+0x16/0x1b
---[ end trace eed6ae990d018c8b ]---

Reported-by: Dave Jones <davej@redhat.com>
Cc: Dave Jones <davej@redhat.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Venkat Venkatsubra <venkat.x.venkatsubra@oracle.com>
Signed-off-by: Cong Wang <amwang@redhat.com>
Acked-by: Venkat Venkatsubra <venkat.x.venkatsubra@oracle.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
---
 net/rds/message.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/rds/message.c b/net/rds/message.c
index f0a4658..aff589c 100644
--- a/net/rds/message.c
+++ b/net/rds/message.c
@@ -197,6 +197,9 @@ struct rds_message *rds_message_alloc(unsigned int extra_len, gfp_t gfp)
 {
 	struct rds_message *rm;
 
+	if (extra_len > KMALLOC_MAX_SIZE - sizeof(struct rds_message))
+		return NULL;
+
 	rm = kzalloc(sizeof(struct rds_message) + extra_len, gfp);
 	if (!rm)
 		goto out;
-- 
1.7.10.4


