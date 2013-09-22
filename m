Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752808Ab3IVRck (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Sep 2013 13:32:40 -0400
Received: from smtprelay0069.hostedemail.com ([216.40.44.69]:41853 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752728Ab3IVRch (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Sep 2013 13:32:37 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::,RULES_HIT:41:355:379:541:800:960:968:973:988:989:1260:1345:1359:1437:1534:1541:1711:1730:1747:1777:1792:2393:2559:2562:3138:3139:3140:3141:3142:3352:3865:3866:3867:3868:3870:3871:4321:4605:5007:6261:7875:7903:10004:10026:10848:11026:11658:11914:12043:12438:12517:12519:12555:13161:13229:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: hands17_169323e525d46
X-Filterd-Recvd-Size: 2665
From: Joe Perches <joe@perches.com>
To: netdev@vger.kernel.org
Cc: "David S. Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org
Subject: [PATCH 05/12] request_sock.h: Remove extern from function prototypes
Date: Sun, 22 Sep 2013 10:32:20 -0700
Message-Id: <bec351fc6068b45ffff56683af1ebed6271843db.1379870986.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
In-Reply-To: <b692aba58032f629907ea2d462c99b87906645ca.1379870986.git.joe@perches.com>
References: <b692aba58032f629907ea2d462c99b87906645ca.1379870986.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are a mix of function prototypes with and without extern
in the kernel sources.  Standardize on not using extern for
function prototypes.

Function prototypes don't need to be written with extern.
extern is assumed by the compiler.  Its use is as unnecessary as
using auto to declare automatic/local variables in a block.

Signed-off-by: Joe Perches <joe@perches.com>
---
 include/net/request_sock.h | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/include/net/request_sock.h b/include/net/request_sock.h
index 59795e4..65c3e516 100644
--- a/include/net/request_sock.h
+++ b/include/net/request_sock.h
@@ -43,7 +43,7 @@ struct request_sock_ops {
 					   struct request_sock *req);
 };
 
-extern int inet_rtx_syn_ack(struct sock *parent, struct request_sock *req);
+int inet_rtx_syn_ack(struct sock *parent, struct request_sock *req);
 
 /* struct request_sock - mini sock to represent a connection request
  */
@@ -162,13 +162,13 @@ struct request_sock_queue {
 					     */
 };
 
-extern int reqsk_queue_alloc(struct request_sock_queue *queue,
-			     unsigned int nr_table_entries);
+int reqsk_queue_alloc(struct request_sock_queue *queue,
+		      unsigned int nr_table_entries);
 
-extern void __reqsk_queue_destroy(struct request_sock_queue *queue);
-extern void reqsk_queue_destroy(struct request_sock_queue *queue);
-extern void reqsk_fastopen_remove(struct sock *sk,
-				  struct request_sock *req, bool reset);
+void __reqsk_queue_destroy(struct request_sock_queue *queue);
+void reqsk_queue_destroy(struct request_sock_queue *queue);
+void reqsk_fastopen_remove(struct sock *sk, struct request_sock *req,
+			   bool reset);
 
 static inline struct request_sock *
 	reqsk_queue_yank_acceptq(struct request_sock_queue *queue)
-- 
1.8.1.2.459.gbcd45b4.dirty

