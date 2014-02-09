Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751697AbaBIQuV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Feb 2014 11:50:21 -0500
Received: from mail-pa0-f47.google.com ([209.85.220.47]:64220 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751438AbaBIQuU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Feb 2014 11:50:20 -0500
From: Rashika Kheria <rashika.kheria@gmail.com>
To: linux-kernel@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Gao feng <gaofeng@cn.fujitsu.com>,
        Sasha Levin <sasha.levin@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Steffen Hurrle <steffen@hurrle.net>, Jiri Pirko <jiri@resnulli.us>,
        netdev@vger.kernel.org, linux-decnet-user@lists.sourceforge.net,
        josh@joshtriplett.org
Subject: =?UTF-8?q?=5BPATCH=20v2=2006/13=5D=20net=3A=20Move=20prototype=20declaration=20to=20appropriate=20header=20file=20from=20decnet/af=5Fdecnet=2Ec?=
Date: Sun,  9 Feb 2014 22:20:09 +0530
Message-Id: <46a1a3d1431e13a5c253833cf44c869eb0d43993.1391955925.git.rashika.kheria@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <6f029c895035908595957fb16ab445c82793c77d.1391955924.git.rashika.kheria@gmail.com>
References: <6f029c895035908595957fb16ab445c82793c77d.1391955924.git.rashika.kheria@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move prototype declaration of functions to header file include/net/dn_route.h
from net/decnet/af_decnet.c because it is used by more than one file.

This eliminates the following warning in net/decnet/dn_route.c:
net/decnet/dn_route.c:629:5: warning: no previous prototype for ‘dn_route_rcv’ [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 include/net/dn_route.h |    2 ++
 net/decnet/af_decnet.c |    2 --
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/net/dn_route.h b/include/net/dn_route.h
index b409ad6..55df993 100644
--- a/include/net/dn_route.h
+++ b/include/net/dn_route.h
@@ -20,6 +20,8 @@ int dn_route_output_sock(struct dst_entry __rcu **pprt, struct flowidn *,
 			 struct sock *sk, int flags);
 int dn_cache_dump(struct sk_buff *skb, struct netlink_callback *cb);
 void dn_rt_cache_flush(int delay);
+int dn_route_rcv(struct sk_buff *skb, struct net_device *dev,
+		 struct packet_type *pt, struct net_device *orig_dev);
 
 /* Masks for flags field */
 #define DN_RT_F_PID 0x07 /* Mask for packet type                      */
diff --git a/net/decnet/af_decnet.c b/net/decnet/af_decnet.c
index 2954dcb..24d9193 100644
--- a/net/decnet/af_decnet.c
+++ b/net/decnet/af_decnet.c
@@ -2104,8 +2104,6 @@ static struct notifier_block dn_dev_notifier = {
 	.notifier_call = dn_device_event,
 };
 
-extern int dn_route_rcv(struct sk_buff *, struct net_device *, struct packet_type *, struct net_device *);
-
 static struct packet_type dn_dix_packet_type __read_mostly = {
 	.type =		cpu_to_be16(ETH_P_DNA_RT),
 	.func =		dn_route_rcv,
-- 
1.7.9.5

