Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755621Ab3JRUsj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Oct 2013 16:48:39 -0400
Received: from smtprelay0072.hostedemail.com ([216.40.44.72]:51548 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755172Ab3JRUsf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Oct 2013 16:48:35 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::,RULES_HIT:2:41:69:355:379:541:800:960:973:988:989:1260:1345:1359:1437:1535:1605:1730:1747:1777:1792:2198:2199:2393:2559:2562:2731:3138:3139:3140:3141:3142:3865:3866:3867:3868:3870:3871:4051:4120:4250:4321:4605:5007:6119:6261:7903:8603:10004:10026:10848:11026:11233:11473:11658:11914:12043:12291:12296:12438:12517:12519:12555:12683:13161:13229,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: sheet47_2da1d47521c2b
X-Filterd-Recvd-Size: 9504
From: Joe Perches <joe@perches.com>
To: netdev@vger.kernel.org
Cc: "David S. Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org
Subject: [PATCH 3/4] net: ipv4/ipv6: Remove extern from function prototypes
Date: Fri, 18 Oct 2013 13:48:24 -0700
Message-Id: <aba4218f77bc1a69d5483f6294d18f074d5eae3b.1382129045.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
In-Reply-To: <cover.1382129045.git.joe@perches.com>
References: <cover.1382129045.git.joe@perches.com>
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
 net/ipv4/fib_lookup.h | 26 +++++++++++---------------
 net/ipv4/tcp_vegas.h  | 10 +++++-----
 net/ipv4/udp_impl.h   | 36 ++++++++++++++++++------------------
 net/ipv6/udp_impl.h   | 41 ++++++++++++++++++++---------------------
 4 files changed, 54 insertions(+), 59 deletions(-)

diff --git a/net/ipv4/fib_lookup.h b/net/ipv4/fib_lookup.h
index 50cfb3e..388d113 100644
--- a/net/ipv4/fib_lookup.h
+++ b/net/ipv4/fib_lookup.h
@@ -24,21 +24,17 @@ static inline void fib_alias_accessed(struct fib_alias *fa)
 }
 
 /* Exported by fib_semantics.c */
-extern void fib_release_info(struct fib_info *);
-extern struct fib_info *fib_create_info(struct fib_config *cfg);
-extern int fib_nh_match(struct fib_config *cfg, struct fib_info *fi);
-extern int fib_dump_info(struct sk_buff *skb, u32 pid, u32 seq, int event,
-			 u32 tb_id, u8 type, __be32 dst,
-			 int dst_len, u8 tos, struct fib_info *fi,
-			 unsigned int);
-extern void rtmsg_fib(int event, __be32 key, struct fib_alias *fa,
-		      int dst_len, u32 tb_id, const struct nl_info *info,
-		      unsigned int nlm_flags);
-extern struct fib_alias *fib_find_alias(struct list_head *fah,
-					u8 tos, u32 prio);
-extern int fib_detect_death(struct fib_info *fi, int order,
-			    struct fib_info **last_resort,
-			    int *last_idx, int dflt);
+void fib_release_info(struct fib_info *);
+struct fib_info *fib_create_info(struct fib_config *cfg);
+int fib_nh_match(struct fib_config *cfg, struct fib_info *fi);
+int fib_dump_info(struct sk_buff *skb, u32 pid, u32 seq, int event, u32 tb_id,
+		  u8 type, __be32 dst, int dst_len, u8 tos, struct fib_info *fi,
+		  unsigned int);
+void rtmsg_fib(int event, __be32 key, struct fib_alias *fa, int dst_len,
+	       u32 tb_id, const struct nl_info *info, unsigned int nlm_flags);
+struct fib_alias *fib_find_alias(struct list_head *fah, u8 tos, u32 prio);
+int fib_detect_death(struct fib_info *fi, int order,
+		     struct fib_info **last_resort, int *last_idx, int dflt);
 
 static inline void fib_result_assign(struct fib_result *res,
 				     struct fib_info *fi)
diff --git a/net/ipv4/tcp_vegas.h b/net/ipv4/tcp_vegas.h
index 6c0eea2..0531b99 100644
--- a/net/ipv4/tcp_vegas.h
+++ b/net/ipv4/tcp_vegas.h
@@ -15,10 +15,10 @@ struct vegas {
 	u32	baseRTT;	/* the min of all Vegas RTT measurements seen (in usec) */
 };
 
-extern void tcp_vegas_init(struct sock *sk);
-extern void tcp_vegas_state(struct sock *sk, u8 ca_state);
-extern void tcp_vegas_pkts_acked(struct sock *sk, u32 cnt, s32 rtt_us);
-extern void tcp_vegas_cwnd_event(struct sock *sk, enum tcp_ca_event event);
-extern void tcp_vegas_get_info(struct sock *sk, u32 ext, struct sk_buff *skb);
+void tcp_vegas_init(struct sock *sk);
+void tcp_vegas_state(struct sock *sk, u8 ca_state);
+void tcp_vegas_pkts_acked(struct sock *sk, u32 cnt, s32 rtt_us);
+void tcp_vegas_cwnd_event(struct sock *sk, enum tcp_ca_event event);
+void tcp_vegas_get_info(struct sock *sk, u32 ext, struct sk_buff *skb);
 
 #endif	/* __TCP_VEGAS_H */
diff --git a/net/ipv4/udp_impl.h b/net/ipv4/udp_impl.h
index 5a681e2..f3c2789 100644
--- a/net/ipv4/udp_impl.h
+++ b/net/ipv4/udp_impl.h
@@ -5,30 +5,30 @@
 #include <net/protocol.h>
 #include <net/inet_common.h>
 
-extern int  	__udp4_lib_rcv(struct sk_buff *, struct udp_table *, int );
-extern void 	__udp4_lib_err(struct sk_buff *, u32, struct udp_table *);
+int __udp4_lib_rcv(struct sk_buff *, struct udp_table *, int);
+void __udp4_lib_err(struct sk_buff *, u32, struct udp_table *);
 
-extern int	udp_v4_get_port(struct sock *sk, unsigned short snum);
+int udp_v4_get_port(struct sock *sk, unsigned short snum);
 
-extern int	udp_setsockopt(struct sock *sk, int level, int optname,
-			       char __user *optval, unsigned int optlen);
-extern int	udp_getsockopt(struct sock *sk, int level, int optname,
-			       char __user *optval, int __user *optlen);
+int udp_setsockopt(struct sock *sk, int level, int optname,
+		   char __user *optval, unsigned int optlen);
+int udp_getsockopt(struct sock *sk, int level, int optname,
+		   char __user *optval, int __user *optlen);
 
 #ifdef CONFIG_COMPAT
-extern int	compat_udp_setsockopt(struct sock *sk, int level, int optname,
-				      char __user *optval, unsigned int optlen);
-extern int	compat_udp_getsockopt(struct sock *sk, int level, int optname,
-				      char __user *optval, int __user *optlen);
+int compat_udp_setsockopt(struct sock *sk, int level, int optname,
+			  char __user *optval, unsigned int optlen);
+int compat_udp_getsockopt(struct sock *sk, int level, int optname,
+			  char __user *optval, int __user *optlen);
 #endif
-extern int	udp_recvmsg(struct kiocb *iocb, struct sock *sk, struct msghdr *msg,
-			    size_t len, int noblock, int flags, int *addr_len);
-extern int	udp_sendpage(struct sock *sk, struct page *page, int offset,
-			     size_t size, int flags);
-extern int	udp_queue_rcv_skb(struct sock *sk, struct sk_buff *skb);
-extern void	udp_destroy_sock(struct sock *sk);
+int udp_recvmsg(struct kiocb *iocb, struct sock *sk, struct msghdr *msg,
+		size_t len, int noblock, int flags, int *addr_len);
+int udp_sendpage(struct sock *sk, struct page *page, int offset, size_t size,
+		 int flags);
+int udp_queue_rcv_skb(struct sock *sk, struct sk_buff *skb);
+void udp_destroy_sock(struct sock *sk);
 
 #ifdef CONFIG_PROC_FS
-extern int	udp4_seq_show(struct seq_file *seq, void *v);
+int udp4_seq_show(struct seq_file *seq, void *v);
 #endif
 #endif	/* _UDP4_IMPL_H */
diff --git a/net/ipv6/udp_impl.h b/net/ipv6/udp_impl.h
index 4691ed5..c779c3c 100644
--- a/net/ipv6/udp_impl.h
+++ b/net/ipv6/udp_impl.h
@@ -7,33 +7,32 @@
 #include <net/inet_common.h>
 #include <net/transp_v6.h>
 
-extern int  	__udp6_lib_rcv(struct sk_buff *, struct udp_table *, int );
-extern void 	__udp6_lib_err(struct sk_buff *, struct inet6_skb_parm *,
-			       u8 , u8 , int , __be32 , struct udp_table *);
+int __udp6_lib_rcv(struct sk_buff *, struct udp_table *, int);
+void __udp6_lib_err(struct sk_buff *, struct inet6_skb_parm *, u8, u8, int,
+		    __be32, struct udp_table *);
 
-extern int	udp_v6_get_port(struct sock *sk, unsigned short snum);
+int udp_v6_get_port(struct sock *sk, unsigned short snum);
 
-extern int	udpv6_getsockopt(struct sock *sk, int level, int optname,
-				 char __user *optval, int __user *optlen);
-extern int	udpv6_setsockopt(struct sock *sk, int level, int optname,
-				 char __user *optval, unsigned int optlen);
+int udpv6_getsockopt(struct sock *sk, int level, int optname,
+		     char __user *optval, int __user *optlen);
+int udpv6_setsockopt(struct sock *sk, int level, int optname,
+		     char __user *optval, unsigned int optlen);
 #ifdef CONFIG_COMPAT
-extern int	compat_udpv6_setsockopt(struct sock *sk, int level, int optname,
-					char __user *optval, unsigned int optlen);
-extern int	compat_udpv6_getsockopt(struct sock *sk, int level, int optname,
-				       char __user *optval, int __user *optlen);
+int compat_udpv6_setsockopt(struct sock *sk, int level, int optname,
+			    char __user *optval, unsigned int optlen);
+int compat_udpv6_getsockopt(struct sock *sk, int level, int optname,
+			    char __user *optval, int __user *optlen);
 #endif
-extern int	udpv6_sendmsg(struct kiocb *iocb, struct sock *sk,
-			      struct msghdr *msg, size_t len);
-extern int	udpv6_recvmsg(struct kiocb *iocb, struct sock *sk,
-			      struct msghdr *msg, size_t len,
-			      int noblock, int flags, int *addr_len);
-extern int	udpv6_queue_rcv_skb(struct sock * sk, struct sk_buff *skb);
-extern void	udpv6_destroy_sock(struct sock *sk);
+int udpv6_sendmsg(struct kiocb *iocb, struct sock *sk, struct msghdr *msg,
+		  size_t len);
+int udpv6_recvmsg(struct kiocb *iocb, struct sock *sk, struct msghdr *msg,
+		  size_t len, int noblock, int flags, int *addr_len);
+int udpv6_queue_rcv_skb(struct sock *sk, struct sk_buff *skb);
+void udpv6_destroy_sock(struct sock *sk);
 
-extern void udp_v6_clear_sk(struct sock *sk, int size);
+void udp_v6_clear_sk(struct sock *sk, int size);
 
 #ifdef CONFIG_PROC_FS
-extern int	udp6_seq_show(struct seq_file *seq, void *v);
+int udp6_seq_show(struct seq_file *seq, void *v);
 #endif
 #endif	/* _UDP6_IMPL_H */
-- 
1.8.1.2.459.gbcd45b4.dirty

