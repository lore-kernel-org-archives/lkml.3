Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754085Ab3FDW64 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 18:58:56 -0400
Received: from 1wt.eu ([62.212.114.60]:35718 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753745Ab3FDWnW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 18:43:22 -0400
Message-Id: <20130604172136.601001234@1wt.eu>
User-Agent: quilt/0.48-1
Date: Tue, 04 Jun 2013 19:24:02 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Stefan Hasko <hasko.stevo@gmail.com>, Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Willy Tarreau <w@1wt.eu>
Subject: [ 152/184] net: sched: integer overflow fix
In-Reply-To: <58df134a4b98edf5b0073e2e1e988fe6@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: Stefan Hasko <hasko.stevo@gmail.com>

[ Upstream commit d2fe85da52e89b8012ffad010ef352a964725d5f ]

Fixed integer overflow in function htb_dequeue

Signed-off-by: Stefan Hasko <hasko.stevo@gmail.com>
Acked-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 net/sched/sch_htb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/sched/sch_htb.c b/net/sched/sch_htb.c
index 85acab9..2f074d6 100644
--- a/net/sched/sch_htb.c
+++ b/net/sched/sch_htb.c
@@ -865,7 +865,7 @@ static struct sk_buff *htb_dequeue(struct Qdisc *sch)
 	q->now = psched_get_time();
 	start_at = jiffies;
 
-	next_event = q->now + 5 * PSCHED_TICKS_PER_SEC;
+	next_event = q->now + 5LLU * PSCHED_TICKS_PER_SEC;
 
 	for (level = 0; level < TC_HTB_MAXDEPTH; level++) {
 		/* common case optimization - skip event handler quickly */
-- 
1.7.12.2.21.g234cd45.dirty



