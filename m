Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756043Ab3AMRv1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jan 2013 12:51:27 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:35061 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755488Ab3AMRph (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jan 2013 12:45:37 -0500
Message-Id: <20130113174303.964369586@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 13 Jan 2013 17:43:34 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Stefan Hasko <hasko.stevo@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 39/49] net: sched: integer overflow fix
In-Reply-To: <20130113174255.736888844@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stefan Hasko <hasko.stevo@gmail.com>

[ Upstream commit d2fe85da52e89b8012ffad010ef352a964725d5f ]

Fixed integer overflow in function htb_dequeue

Signed-off-by: Stefan Hasko <hasko.stevo@gmail.com>
Acked-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 net/sched/sch_htb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/sched/sch_htb.c b/net/sched/sch_htb.c
index 29b942c..f08b9166 100644
--- a/net/sched/sch_htb.c
+++ b/net/sched/sch_htb.c
@@ -876,7 +876,7 @@ ok:
 	q->now = psched_get_time();
 	start_at = jiffies;
 
-	next_event = q->now + 5 * PSCHED_TICKS_PER_SEC;
+	next_event = q->now + 5LLU * PSCHED_TICKS_PER_SEC;
 
 	for (level = 0; level < TC_HTB_MAXDEPTH; level++) {
 		/* common case optimization - skip event handler quickly */


