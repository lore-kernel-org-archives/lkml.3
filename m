Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754381AbaBEUFK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 15:05:10 -0500
Received: from mail.windriver.com ([147.11.1.11]:54471 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754273AbaBEUEx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 15:04:53 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Stefan Hasko <hasko.stevo@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [v2.6.34-stable 047/213] net: sched: integer overflow fix
Date: Wed, 5 Feb 2014 15:00:02 -0500
Message-ID: <1391630568-49251-48-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.8.5.2
In-Reply-To: <1391630568-49251-1-git-send-email-paul.gortmaker@windriver.com>
References: <1391630568-49251-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stefan Hasko <hasko.stevo@gmail.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit d2fe85da52e89b8012ffad010ef352a964725d5f upstream.

Fixed integer overflow in function htb_dequeue

Signed-off-by: Stefan Hasko <hasko.stevo@gmail.com>
Acked-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 net/sched/sch_htb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/sched/sch_htb.c b/net/sched/sch_htb.c
index 0b52b8de562c..efabd30425ec 100644
--- a/net/sched/sch_htb.c
+++ b/net/sched/sch_htb.c
@@ -866,7 +866,7 @@ static struct sk_buff *htb_dequeue(struct Qdisc *sch)
 	q->now = psched_get_time();
 	start_at = jiffies;
 
-	next_event = q->now + 5 * PSCHED_TICKS_PER_SEC;
+	next_event = q->now + 5LLU * PSCHED_TICKS_PER_SEC;
 
 	for (level = 0; level < TC_HTB_MAXDEPTH; level++) {
 		/* common case optimization - skip event handler quickly */
-- 
1.8.5.2

