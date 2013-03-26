Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932349Ab3CZSDO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 14:03:14 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:19020 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753864Ab3CZRgE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 13:36:04 -0400
X-Authority-Analysis: v=2.0 cv=H5hZMpki c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=5ZE14NXf7Z8A:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=YtEFkIHGzRcA:10 a=pGLkceISAAAA:8 a=1XWaLZrsAAAA:8 a=J1Y8HTJGAAAA:8 a=AqJ00D3vZjHJZuhkqGEA:9 a=MSl-tDqOz04A:10 a=UTB_XpHje0EA:10 a=4N9Db7Z2_RYA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130326173600.516165568@goodmis.org>
User-Agent: quilt/0.60-1
Date: Tue, 26 Mar 2013 13:21:03 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Stefan Hasko <hasko.stevo@gmail.com>, Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 04/86] net: sched: integer overflow fix
References: <20130326172059.136127374@goodmis.org>
Content-Disposition: inline; filename=0004-net-sched-integer-overflow-fix.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.1 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Stefan Hasko <hasko.stevo@gmail.com>

[ Upstream commit d2fe85da52e89b8012ffad010ef352a964725d5f ]

Fixed integer overflow in function htb_dequeue

Signed-off-by: Stefan Hasko <hasko.stevo@gmail.com>
Acked-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
---
 net/sched/sch_htb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/sched/sch_htb.c b/net/sched/sch_htb.c
index 9d75b77..e9ea2f3 100644
--- a/net/sched/sch_htb.c
+++ b/net/sched/sch_htb.c
@@ -874,7 +874,7 @@ ok:
 	q->now = psched_get_time();
 	start_at = jiffies;
 
-	next_event = q->now + 5 * PSCHED_TICKS_PER_SEC;
+	next_event = q->now + 5LLU * PSCHED_TICKS_PER_SEC;
 
 	for (level = 0; level < TC_HTB_MAXDEPTH; level++) {
 		/* common case optimization - skip event handler quickly */
-- 
1.7.10.4


