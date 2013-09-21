Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752726Ab3IURXU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Sep 2013 13:23:20 -0400
Received: from smtprelay0056.hostedemail.com ([216.40.44.56]:50946 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752471Ab3IURXC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Sep 2013 13:23:02 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::,RULES_HIT:41:355:379:541:800:960:973:988:989:1260:1345:1359:1437:1534:1541:1711:1730:1747:1777:1792:2393:2559:2562:3138:3139:3140:3141:3142:3352:3865:3866:3867:3868:3870:3871:4321:5007:6261:7903:10004:10026:10848:11658:11914:12296:12517:12519:12555:13161:13229:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: day88_1a0fc83efd429
X-Filterd-Recvd-Size: 2418
From: Joe Perches <joe@perches.com>
To: netdev@vger.kernel.org
Cc: "David S. Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org
Subject: [PATCH 03/12] ipx.h: Remove extern from function prototypes
Date: Sat, 21 Sep 2013 10:22:43 -0700
Message-Id: <aed828a0b08b947467bf8009e8225c3abdfe78c0.1379783995.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
In-Reply-To: <005f102eb1322058f9e797a7268ae8be01ecfaae.1379783995.git.joe@perches.com>
References: <005f102eb1322058f9e797a7268ae8be01ecfaae.1379783995.git.joe@perches.com>
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
 include/net/ipx.h | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/include/net/ipx.h b/include/net/ipx.h
index c1fec6b..9e9e354 100644
--- a/include/net/ipx.h
+++ b/include/net/ipx.h
@@ -123,23 +123,23 @@ extern struct list_head ipx_routes;
 extern rwlock_t ipx_routes_lock;
 
 extern struct list_head ipx_interfaces;
-extern struct ipx_interface *ipx_interfaces_head(void);
+struct ipx_interface *ipx_interfaces_head(void);
 extern spinlock_t ipx_interfaces_lock;
 
 extern struct ipx_interface *ipx_primary_net;
 
-extern int ipx_proc_init(void);
-extern void ipx_proc_exit(void);
+int ipx_proc_init(void);
+void ipx_proc_exit(void);
 
-extern const char *ipx_frame_name(__be16);
-extern const char *ipx_device_name(struct ipx_interface *intrfc);
+const char *ipx_frame_name(__be16);
+const char *ipx_device_name(struct ipx_interface *intrfc);
 
 static __inline__ void ipxitf_hold(struct ipx_interface *intrfc)
 {
 	atomic_inc(&intrfc->refcnt);
 }
 
-extern void ipxitf_down(struct ipx_interface *intrfc);
+void ipxitf_down(struct ipx_interface *intrfc);
 
 static __inline__ void ipxitf_put(struct ipx_interface *intrfc)
 {
-- 
1.8.1.2.459.gbcd45b4.dirty

