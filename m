Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753244Ab3IVRdk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Sep 2013 13:33:40 -0400
Received: from smtprelay0071.hostedemail.com ([216.40.44.71]:35180 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752924Ab3IVRcp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Sep 2013 13:32:45 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::,RULES_HIT:41:69:355:379:541:800:960:973:988:989:1260:1345:1359:1437:1534:1542:1711:1730:1747:1777:1792:2194:2199:2393:2559:2562:3138:3139:3140:3141:3142:3353:3865:3866:3867:3868:3870:3871:4321:4605:5007:6261:7903:10004:10026:10848:11026:11233:11473:11658:11914:12043:12438:12517:12519:12555:13161:13229,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: order32_17d09014e8508
X-Filterd-Recvd-Size: 3073
From: Joe Perches <joe@perches.com>
To: netdev@vger.kernel.org
Cc: "David S. Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org
Subject: [PATCH 10/12] secure_seq.h: Remove extern from function prototypes
Date: Sun, 22 Sep 2013 10:32:25 -0700
Message-Id: <08f707d15513cc60b0ba0e5b877badcd1ac4e875.1379870986.git.joe@perches.com>
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
 include/net/secure_seq.h | 28 ++++++++++++++--------------
 1 file changed, 14 insertions(+), 14 deletions(-)

diff --git a/include/net/secure_seq.h b/include/net/secure_seq.h
index 6ca975b..52c1a90 100644
--- a/include/net/secure_seq.h
+++ b/include/net/secure_seq.h
@@ -3,19 +3,19 @@
 
 #include <linux/types.h>
 
-extern void net_secret_init(void);
-extern __u32 secure_ip_id(__be32 daddr);
-extern __u32 secure_ipv6_id(const __be32 daddr[4]);
-extern u32 secure_ipv4_port_ephemeral(__be32 saddr, __be32 daddr, __be16 dport);
-extern u32 secure_ipv6_port_ephemeral(const __be32 *saddr, const __be32 *daddr,
-				      __be16 dport);
-extern __u32 secure_tcp_sequence_number(__be32 saddr, __be32 daddr,
-					__be16 sport, __be16 dport);
-extern __u32 secure_tcpv6_sequence_number(const __be32 *saddr, const __be32 *daddr,
-					  __be16 sport, __be16 dport);
-extern u64 secure_dccp_sequence_number(__be32 saddr, __be32 daddr,
-				       __be16 sport, __be16 dport);
-extern u64 secure_dccpv6_sequence_number(__be32 *saddr, __be32 *daddr,
-					 __be16 sport, __be16 dport);
+void net_secret_init(void);
+__u32 secure_ip_id(__be32 daddr);
+__u32 secure_ipv6_id(const __be32 daddr[4]);
+u32 secure_ipv4_port_ephemeral(__be32 saddr, __be32 daddr, __be16 dport);
+u32 secure_ipv6_port_ephemeral(const __be32 *saddr, const __be32 *daddr,
+			       __be16 dport);
+__u32 secure_tcp_sequence_number(__be32 saddr, __be32 daddr,
+				 __be16 sport, __be16 dport);
+__u32 secure_tcpv6_sequence_number(const __be32 *saddr, const __be32 *daddr,
+				   __be16 sport, __be16 dport);
+u64 secure_dccp_sequence_number(__be32 saddr, __be32 daddr,
+				__be16 sport, __be16 dport);
+u64 secure_dccpv6_sequence_number(__be32 *saddr, __be32 *daddr,
+				  __be16 sport, __be16 dport);
 
 #endif /* _NET_SECURE_SEQ */
-- 
1.8.1.2.459.gbcd45b4.dirty

