Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753693Ab3IWSdr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 14:33:47 -0400
Received: from smtprelay0091.hostedemail.com ([216.40.44.91]:57106 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753643Ab3IWSdp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 14:33:45 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::,RULES_HIT:41:355:379:541:800:960:973:988:989:1260:1345:1359:1437:1534:1541:1711:1730:1747:1777:1792:2393:2559:2562:3138:3139:3140:3141:3142:3353:3865:3866:3867:3868:3870:3871:4321:4605:5007:6261:7903:10004:10026:10848:11026:11473:11658:11914:12043:12438:12517:12519:12555:13161:13229:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: slip00_208ecf321a116
X-Filterd-Recvd-Size: 2689
From: Joe Perches <joe@perches.com>
To: netdev@vger.kernel.org
Cc: "David S. Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org
Subject: [PATCH 04/12] wext.h: Remove extern from function prototypes
Date: Mon, 23 Sep 2013 11:33:42 -0700
Message-Id: <1a1b8a5b4611f667d321fbc722625f8e6caf2c9e.1379961014.git.joe@perches.com>
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
 include/net/wext.h | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/include/net/wext.h b/include/net/wext.h
index 4f6e742..3459119 100644
--- a/include/net/wext.h
+++ b/include/net/wext.h
@@ -6,13 +6,13 @@
 struct net;
 
 #ifdef CONFIG_WEXT_CORE
-extern int wext_handle_ioctl(struct net *net, struct ifreq *ifr, unsigned int cmd,
-			     void __user *arg);
-extern int compat_wext_handle_ioctl(struct net *net, unsigned int cmd,
-				    unsigned long arg);
+int wext_handle_ioctl(struct net *net, struct ifreq *ifr, unsigned int cmd,
+		      void __user *arg);
+int compat_wext_handle_ioctl(struct net *net, unsigned int cmd,
+			     unsigned long arg);
 
-extern struct iw_statistics *get_wireless_stats(struct net_device *dev);
-extern int call_commit_handler(struct net_device *dev);
+struct iw_statistics *get_wireless_stats(struct net_device *dev);
+int call_commit_handler(struct net_device *dev);
 #else
 static inline int wext_handle_ioctl(struct net *net, struct ifreq *ifr, unsigned int cmd,
 				    void __user *arg)
@@ -27,8 +27,8 @@ static inline int compat_wext_handle_ioctl(struct net *net, unsigned int cmd,
 #endif
 
 #ifdef CONFIG_WEXT_PROC
-extern int wext_proc_init(struct net *net);
-extern void wext_proc_exit(struct net *net);
+int wext_proc_init(struct net *net);
+void wext_proc_exit(struct net *net);
 #else
 static inline int wext_proc_init(struct net *net)
 {
-- 
1.8.1.2.459.gbcd45b4.dirty

