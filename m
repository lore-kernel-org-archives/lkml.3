Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753473Ab3ITSXe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Sep 2013 14:23:34 -0400
Received: from smtprelay0234.hostedemail.com ([216.40.44.234]:53879 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753314Ab3ITSXd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Sep 2013 14:23:33 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::,RULES_HIT:41:69:355:379:541:800:960:973:988:989:1260:1345:1437:1534:1543:1711:1730:1747:1777:1792:2393:2559:2562:3138:3139:3140:3141:3142:3355:3865:3866:3867:3868:3870:3871:4321:4605:5007:6261:7903:9592:10004:10026:10848:11026:11658:11914:12043:12291:12296:12438:12517:12519:12555:12683:13161:13229,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: fly82_3bdca9a402c1d
X-Filterd-Recvd-Size: 4421
From: Joe Perches <joe@perches.com>
To: netdev@vger.kernel.org
Cc: "David S. Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org
Subject: [PATCH 01/11] compat.h: Remove extern from function prototypes
Date: Fri, 20 Sep 2013 11:23:18 -0700
Message-Id: <597c1b62607f823af60dc4a99d59373dddfb7837.1379701322.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
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
 include/net/compat.h | 48 +++++++++++++++++++++++++++---------------------
 1 file changed, 27 insertions(+), 21 deletions(-)

diff --git a/include/net/compat.h b/include/net/compat.h
index 6e95653..3b603b1 100644
--- a/include/net/compat.h
+++ b/include/net/compat.h
@@ -29,8 +29,8 @@ struct compat_cmsghdr {
 	compat_int_t	cmsg_type;
 };
 
-extern int compat_sock_get_timestamp(struct sock *, struct timeval __user *);
-extern int compat_sock_get_timestampns(struct sock *, struct timespec __user *);
+int compat_sock_get_timestamp(struct sock *, struct timeval __user *);
+int compat_sock_get_timestampns(struct sock *, struct timespec __user *);
 
 #else /* defined(CONFIG_COMPAT) */
 /*
@@ -40,24 +40,30 @@ extern int compat_sock_get_timestampns(struct sock *, struct timespec __user *);
 #define compat_mmsghdr	mmsghdr
 #endif /* defined(CONFIG_COMPAT) */
 
-extern int get_compat_msghdr(struct msghdr *, struct compat_msghdr __user *);
-extern int verify_compat_iovec(struct msghdr *, struct iovec *, struct sockaddr_storage *, int);
-extern asmlinkage long compat_sys_sendmsg(int,struct compat_msghdr __user *,unsigned int);
-extern asmlinkage long compat_sys_sendmmsg(int, struct compat_mmsghdr __user *,
-					   unsigned int, unsigned int);
-extern asmlinkage long compat_sys_recvmsg(int,struct compat_msghdr __user *,unsigned int);
-extern asmlinkage long compat_sys_recvmmsg(int, struct compat_mmsghdr __user *,
-					   unsigned int, unsigned int,
-					   struct compat_timespec __user *);
-extern asmlinkage long compat_sys_getsockopt(int, int, int, char __user *, int __user *);
-extern int put_cmsg_compat(struct msghdr*, int, int, int, void *);
-
-extern int cmsghdr_from_user_compat_to_kern(struct msghdr *, struct sock *, unsigned char *, int);
-
-extern int compat_mc_setsockopt(struct sock *, int, int, char __user *, unsigned int,
-	int (*)(struct sock *, int, int, char __user *, unsigned int));
-extern int compat_mc_getsockopt(struct sock *, int, int, char __user *,
-	int __user *, int (*)(struct sock *, int, int, char __user *,
-				int __user *));
+int get_compat_msghdr(struct msghdr *, struct compat_msghdr __user *);
+int verify_compat_iovec(struct msghdr *, struct iovec *,
+			struct sockaddr_storage *, int);
+asmlinkage long compat_sys_sendmsg(int, struct compat_msghdr __user *,
+				   unsigned int);
+asmlinkage long compat_sys_sendmmsg(int, struct compat_mmsghdr __user *,
+				    unsigned int, unsigned int);
+asmlinkage long compat_sys_recvmsg(int, struct compat_msghdr __user *,
+				   unsigned int);
+asmlinkage long compat_sys_recvmmsg(int, struct compat_mmsghdr __user *,
+				    unsigned int, unsigned int,
+				    struct compat_timespec __user *);
+asmlinkage long compat_sys_getsockopt(int, int, int, char __user *,
+				      int __user *);
+int put_cmsg_compat(struct msghdr*, int, int, int, void *);
+
+int cmsghdr_from_user_compat_to_kern(struct msghdr *, struct sock *,
+				     unsigned char *, int);
+
+int compat_mc_setsockopt(struct sock *, int, int, char __user *, unsigned int,
+			 int (*)(struct sock *, int, int, char __user *,
+				 unsigned int));
+int compat_mc_getsockopt(struct sock *, int, int, char __user *, int __user *,
+			 int (*)(struct sock *, int, int, char __user *,
+				 int __user *));
 
 #endif /* NET_COMPAT_H */
-- 
1.8.1.2.459.gbcd45b4.dirty

