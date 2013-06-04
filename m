Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752884Ab3FDW76 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 18:59:58 -0400
Received: from 1wt.eu ([62.212.114.60]:35699 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753680Ab3FDWnS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 18:43:18 -0400
Message-Id: <20130604172136.313574799@1wt.eu>
User-Agent: quilt/0.48-1
Date: Tue, 04 Jun 2013 19:23:55 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>, Willy Tarreau <w@1wt.eu>
Subject: [ 145/184] net: reduce net_rx_action() latency to 2 HZ
In-Reply-To: <58df134a4b98edf5b0073e2e1e988fe6@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazt@google.com>

We should use time_after_eq() to get maximum latency of two ticks,
instead of three.

Bug added in commit 24f8b2385 (net: increase receive packet quantum)

Signed-off-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
(cherry picked from commit d1f41b67ff7735193bc8b418b98ac99a448833e2)
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 net/core/dev.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index f4a6e14..d775563 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -2848,7 +2848,7 @@ static void net_rx_action(struct softirq_action *h)
 		 * Allow this to run for 2 jiffies since which will allow
 		 * an average latency of 1.5/HZ.
 		 */
-		if (unlikely(budget <= 0 || time_after(jiffies, time_limit)))
+		if (unlikely(budget <= 0 || time_after_eq(jiffies, time_limit)))
 			goto softnet_break;
 
 		local_irq_enable();
-- 
1.7.12.2.21.g234cd45.dirty



