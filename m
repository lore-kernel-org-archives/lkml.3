Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752990Ab3IVRcr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Sep 2013 13:32:47 -0400
Received: from smtprelay0216.hostedemail.com ([216.40.44.216]:52671 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752803Ab3IVRcn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Sep 2013 13:32:43 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::,RULES_HIT:41:355:379:541:800:960:973:988:989:1260:1345:1359:1437:1534:1541:1711:1730:1747:1777:1792:2393:2559:2562:3138:3139:3140:3141:3142:3352:3865:3866:3867:3868:3870:3871:5007:6261:7903:10004:10026:10848:11026:11473:11658:11914:12438:12517:12519:12555:13161:13229:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: pull18_1790c225e3300
X-Filterd-Recvd-Size: 2322
From: Joe Perches <joe@perches.com>
To: netdev@vger.kernel.org
Cc: "David S. Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org
Subject: [PATCH 09/12] scm.h: Remove extern from function prototypes
Date: Sun, 22 Sep 2013 10:32:24 -0700
Message-Id: <3abdad0f2a5221b8cc5fb0084d5c221451d2071a.1379870986.git.joe@perches.com>
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
 include/net/scm.h | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/include/net/scm.h b/include/net/scm.h
index 8de2d37..262532d 100644
--- a/include/net/scm.h
+++ b/include/net/scm.h
@@ -33,11 +33,11 @@ struct scm_cookie {
 #endif
 };
 
-extern void scm_detach_fds(struct msghdr *msg, struct scm_cookie *scm);
-extern void scm_detach_fds_compat(struct msghdr *msg, struct scm_cookie *scm);
-extern int __scm_send(struct socket *sock, struct msghdr *msg, struct scm_cookie *scm);
-extern void __scm_destroy(struct scm_cookie *scm);
-extern struct scm_fp_list * scm_fp_dup(struct scm_fp_list *fpl);
+void scm_detach_fds(struct msghdr *msg, struct scm_cookie *scm);
+void scm_detach_fds_compat(struct msghdr *msg, struct scm_cookie *scm);
+int __scm_send(struct socket *sock, struct msghdr *msg, struct scm_cookie *scm);
+void __scm_destroy(struct scm_cookie *scm);
+struct scm_fp_list *scm_fp_dup(struct scm_fp_list *fpl);
 
 #ifdef CONFIG_SECURITY_NETWORK
 static __inline__ void unix_get_peersec_dgram(struct socket *sock, struct scm_cookie *scm)
-- 
1.8.1.2.459.gbcd45b4.dirty

