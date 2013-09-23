Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754341Ab3IWSiH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 14:38:07 -0400
Received: from smtprelay0197.hostedemail.com ([216.40.44.197]:50646 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754319Ab3IWSiD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 14:38:03 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::,RULES_HIT:41:355:379:541:800:960:966:973:988:989:1260:1345:1359:1437:1534:1541:1711:1730:1747:1777:1792:2196:2199:2393:2559:2562:3138:3139:3140:3141:3142:3352:3865:3866:3867:3868:3870:3871:4321:4385:4605:5007:6261:7903:10004:10026:10848:11026:11657:11658:11914:12043:12296:12438:12517:12519:12555:13161:13229:13311:13357:13972,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: stem14_45f756075d950
X-Filterd-Recvd-Size: 2721
From: Joe Perches <joe@perches.com>
To: netdev@vger.kernel.org
Cc: "David S. Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org,
        Vlad Yasevich <vyasevich@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>, linux-sctp@vger.kernel.org
Subject: [PATCH 12/12] sctp: Remove extern from function prototypes
Date: Mon, 23 Sep 2013 11:37:59 -0700
Message-Id: <6738b115d30d40f33c688863f5421d84d2aa706c.1379961014.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
In-Reply-To: <445209f8885ccd8234fa787c30d63e63fc7917d7.1379961014.git.joe@perches.com>
References: <445209f8885ccd8234fa787c30d63e63fc7917d7.1379961014.git.joe@perches.com>
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
 include/net/sctp/sctp.h | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/include/net/sctp/sctp.h b/include/net/sctp/sctp.h
index 3794c5a..c5fe806 100644
--- a/include/net/sctp/sctp.h
+++ b/include/net/sctp/sctp.h
@@ -90,12 +90,11 @@
 /*
  * sctp/protocol.c
  */
-extern int sctp_copy_local_addr_list(struct net *, struct sctp_bind_addr *,
-				     sctp_scope_t, gfp_t gfp,
-				     int flags);
-extern struct sctp_pf *sctp_get_pf_specific(sa_family_t family);
-extern int sctp_register_pf(struct sctp_pf *, sa_family_t);
-extern void sctp_addr_wq_mgmt(struct net *, struct sctp_sockaddr_entry *, int);
+int sctp_copy_local_addr_list(struct net *, struct sctp_bind_addr *,
+			      sctp_scope_t, gfp_t gfp, int flags);
+struct sctp_pf *sctp_get_pf_specific(sa_family_t family);
+int sctp_register_pf(struct sctp_pf *, sa_family_t);
+void sctp_addr_wq_mgmt(struct net *, struct sctp_sockaddr_entry *, int);
 
 /*
  * sctp/socket.c
@@ -110,7 +109,7 @@ void sctp_sock_rfree(struct sk_buff *skb);
 void sctp_copy_sock(struct sock *newsk, struct sock *sk,
 		    struct sctp_association *asoc);
 extern struct percpu_counter sctp_sockets_allocated;
-extern int sctp_asconf_mgmt(struct sctp_sock *, struct sctp_sockaddr_entry *);
+int sctp_asconf_mgmt(struct sctp_sock *, struct sctp_sockaddr_entry *);
 
 /*
  * sctp/primitive.c
-- 
1.8.1.2.459.gbcd45b4.dirty

