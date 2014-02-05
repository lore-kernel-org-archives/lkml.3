Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754461AbaBEUFT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 15:05:19 -0500
Received: from mail1.windriver.com ([147.11.146.13]:48062 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754343AbaBEUFF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 15:05:05 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Eric Dumazet <edumazt@google.com>, Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [v2.6.34-stable 057/213] net: reduce net_rx_action() latency to 2 HZ
Date: Wed, 5 Feb 2014 15:00:12 -0500
Message-ID: <1391630568-49251-58-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.8.5.2
In-Reply-To: <1391630568-49251-1-git-send-email-paul.gortmaker@windriver.com>
References: <1391630568-49251-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Dumazet <edumazt@google.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit d1f41b67ff7735193bc8b418b98ac99a448833e2 upstream.

We should use time_after_eq() to get maximum latency of two ticks,
instead of three.

Bug added in commit 24f8b2385 (net: increase receive packet quantum)

Signed-off-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 net/core/dev.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index 2aaf2e610f92..253b409fe3ab 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -3045,7 +3045,7 @@ static void net_rx_action(struct softirq_action *h)
 		 * Allow this to run for 2 jiffies since which will allow
 		 * an average latency of 1.5/HZ.
 		 */
-		if (unlikely(budget <= 0 || time_after(jiffies, time_limit)))
+		if (unlikely(budget <= 0 || time_after_eq(jiffies, time_limit)))
 			goto softnet_break;
 
 		local_irq_enable();
-- 
1.8.5.2

