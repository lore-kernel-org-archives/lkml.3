Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756410AbaELCEs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2014 22:04:48 -0400
Received: from 1wt.eu ([62.212.114.60]:34575 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753069AbaELBmf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2014 21:42:35 -0400
Message-Id: <20140512003203.170756834@1wt.eu>
User-Agent: quilt/0.48-1
Date: Mon, 12 May 2014 02:33:01 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: "David S. Miller" <davem@davemloft.net>, Willy Tarreau <w@1wt.eu>
Subject: [ 061/143] net_sched: Fix stack info leak in cbq_dump_wrr().
In-Reply-To: <f07e5fe6d87f172fc73580b9c86ba9a2@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: "David S. Miller" <davem@davemloft.net>

[ Upstream commit a0db856a95a29efb1c23db55c02d9f0ff4f0db48 ]

Make sure the reserved fields, and padding (if any), are
fully initialized.

Based upon a patch by Dan Carpenter and feedback from
Joe Perches.

Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 net/sched/sch_cbq.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/sched/sch_cbq.c b/net/sched/sch_cbq.c
index 5b132c4..8b6f05d 100644
--- a/net/sched/sch_cbq.c
+++ b/net/sched/sch_cbq.c
@@ -1458,6 +1458,7 @@ static __inline__ int cbq_dump_wrr(struct sk_buff *skb, struct cbq_class *cl)
 	unsigned char *b = skb_tail_pointer(skb);
 	struct tc_cbq_wrropt opt;
 
+	memset(&opt, 0, sizeof(opt));
 	opt.flags = 0;
 	opt.allot = cl->allot;
 	opt.priority = cl->priority+1;
-- 
1.7.12.2.21.g234cd45.dirty



