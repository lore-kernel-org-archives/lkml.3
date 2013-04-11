Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422698Ab3DKV0r (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 17:26:47 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:5406 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935309Ab3DKUsp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 16:48:45 -0400
X-Authority-Analysis: v=2.0 cv=F+XVh9dN c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=QKemBh85TsEA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=evslkJG6AhUA:10 a=pGLkceISAAAA:8 a=1XWaLZrsAAAA:8 a=J1Y8HTJGAAAA:8 a=jmWCE8W1go-RpaolMxwA:9 a=MSl-tDqOz04A:10 a=UTB_XpHje0EA:10 a=4N9Db7Z2_RYA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130411202613.768257644@goodmis.org>
User-Agent: quilt/0.60-1
Date: Thu, 11 Apr 2013 16:27:51 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Vijay Subramanian <subramanian.vijay@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 168/171 ] net: fq_codel: Fix off-by-one error
References: <20130411202503.783159048@goodmis.org>
Content-Disposition: inline; filename=0168-net-fq_codel-Fix-off-by-one-error.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.2 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Vijay Subramanian <subramanian.vijay@gmail.com>

[ Upstream commit cd68ddd4c29ab523440299f24ff2417fe7a0dca6 ]

Currently, we hold a max of sch->limit -1 number of packets instead of
sch->limit packets. Fix this off-by-one error.

Signed-off-by: Vijay Subramanian <subramanian.vijay@gmail.com>
Acked-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 net/sched/sch_fq_codel.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/sched/sch_fq_codel.c b/net/sched/sch_fq_codel.c
index 4e606fc..5578628 100644
--- a/net/sched/sch_fq_codel.c
+++ b/net/sched/sch_fq_codel.c
@@ -195,7 +195,7 @@ static int fq_codel_enqueue(struct sk_buff *skb, struct Qdisc *sch)
 		flow->deficit = q->quantum;
 		flow->dropped = 0;
 	}
-	if (++sch->q.qlen < sch->limit)
+	if (++sch->q.qlen <= sch->limit)
 		return NET_XMIT_SUCCESS;
 
 	q->drop_overlimit++;
-- 
1.7.10.4


