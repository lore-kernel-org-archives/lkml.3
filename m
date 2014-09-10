Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752046AbaIJESk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 00:18:40 -0400
Received: from smtprelay0137.hostedemail.com ([216.40.44.137]:35637 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751882AbaIJERq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 00:17:46 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::,RULES_HIT:41:69:355:379:541:800:960:968:973:988:989:1260:1345:1359:1437:1534:1542:1711:1730:1747:1777:1792:2393:2559:2562:3138:3139:3140:3141:3142:3352:3865:3867:3871:3872:5007:6117:6119:6261:10004:10026:10848:11026:11658:11914:12043:12294:12296:12438:12517:12519:12555:14394:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: hot73_6090940bc180a
X-Filterd-Recvd-Size: 3686
From: Joe Perches <joe@perches.com>
To: netdev@vger.kernel.org
Cc: "David S. Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 3/5] pktgen: Convert pr_warning to pr_warn
Date: Tue,  9 Sep 2014 21:17:30 -0700
Message-Id: <dedab28c56667eb9829df99fb7d22ad83a58e52e.1410322181.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
In-Reply-To: <cover.1410322181.git.joe@perches.com>
References: <cover.1410322181.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the more common pr_warn.
Realign arguments.

Signed-off-by: Joe Perches <joe@perches.com>
---
 net/core/pktgen.c | 24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/net/core/pktgen.c b/net/core/pktgen.c
index 21cb483..5c728aa 100644
--- a/net/core/pktgen.c
+++ b/net/core/pktgen.c
@@ -506,7 +506,7 @@ static ssize_t pgctrl_write(struct file *file, const char __user *buf,
 		pktgen_reset_all_threads(pn);
 
 	else
-		pr_warning("Unknown command: %s\n", data);
+		pr_warn("Unknown command: %s\n", data);
 
 	return count;
 }
@@ -861,14 +861,14 @@ static ssize_t pktgen_if_write(struct file *file,
 	pg_result = &(pkt_dev->result[0]);
 
 	if (count < 1) {
-		pr_warning("wrong command format\n");
+		pr_warn("wrong command format\n");
 		return -EINVAL;
 	}
 
 	max = count;
 	tmp = count_trail_chars(user_buffer, max);
 	if (tmp < 0) {
-		pr_warning("illegal format\n");
+		pr_warn("illegal format\n");
 		return tmp;
 	}
 	i = tmp;
@@ -2056,15 +2056,15 @@ static void pktgen_setup_inject(struct pktgen_dev *pkt_dev)
 	ntxq = pkt_dev->odev->real_num_tx_queues;
 
 	if (ntxq <= pkt_dev->queue_map_min) {
-		pr_warning("WARNING: Requested queue_map_min (zero-based) (%d) exceeds valid range [0 - %d] for (%d) queues on %s, resetting\n",
-			   pkt_dev->queue_map_min, (ntxq ?: 1) - 1, ntxq,
-			   pkt_dev->odevname);
+		pr_warn("WARNING: Requested queue_map_min (zero-based) (%d) exceeds valid range [0 - %d] for (%d) queues on %s, resetting\n",
+			pkt_dev->queue_map_min, (ntxq ?: 1) - 1, ntxq,
+			pkt_dev->odevname);
 		pkt_dev->queue_map_min = (ntxq ?: 1) - 1;
 	}
 	if (pkt_dev->queue_map_max >= ntxq) {
-		pr_warning("WARNING: Requested queue_map_max (zero-based) (%d) exceeds valid range [0 - %d] for (%d) queues on %s, resetting\n",
-			   pkt_dev->queue_map_max, (ntxq ?: 1) - 1, ntxq,
-			   pkt_dev->odevname);
+		pr_warn("WARNING: Requested queue_map_max (zero-based) (%d) exceeds valid range [0 - %d] for (%d) queues on %s, resetting\n",
+			pkt_dev->queue_map_max, (ntxq ?: 1) - 1, ntxq,
+			pkt_dev->odevname);
 		pkt_dev->queue_map_max = (ntxq ?: 1) - 1;
 	}
 
@@ -3173,8 +3173,8 @@ static int pktgen_stop_device(struct pktgen_dev *pkt_dev)
 	int nr_frags = pkt_dev->skb ? skb_shinfo(pkt_dev->skb)->nr_frags : -1;
 
 	if (!pkt_dev->running) {
-		pr_warning("interface: %s is already stopped\n",
-			   pkt_dev->odevname);
+		pr_warn("interface: %s is already stopped\n",
+			pkt_dev->odevname);
 		return -EINVAL;
 	}
 
@@ -3692,7 +3692,7 @@ static int pktgen_remove_device(struct pktgen_thread *t,
 	pr_debug("remove_device pkt_dev=%p\n", pkt_dev);
 
 	if (pkt_dev->running) {
-		pr_warning("WARNING: trying to remove a running interface, stopping it now\n");
+		pr_warn("WARNING: trying to remove a running interface, stopping it now\n");
 		pktgen_stop_device(pkt_dev);
 	}
 
-- 
1.8.1.2.459.gbcd45b4.dirty

