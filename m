Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751802AbaBHT6N (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Feb 2014 14:58:13 -0500
Received: from mail-pa0-f54.google.com ([209.85.220.54]:37769 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751370AbaBHT6L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Feb 2014 14:58:11 -0500
Date: Sun, 9 Feb 2014 01:28:07 +0530
From: Rashika Kheria <rashika.kheria@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: "David S. Miller" <davem@davemloft.net>,
        Rashika Kheria <rashika.kheria@gmail.com>,
        Gao feng <gaofeng@cn.fujitsu.com>,
        Sasha Levin <sasha.levin@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Steffen Hurrle <steffen@hurrle.net>, Jiri Pirko <jiri@resnulli.us>,
        netdev@vger.kernel.org, linux-decnet-user@lists.sourceforge.net,
        josh@joshtriplett.org
Subject: [PATCH 06/13] net: Move prototype declaration to appropriate header
 file from decnet/af_decnet.c
Message-ID: <46f32476c8361e104aa27cebb3425b4926f5ad57.1391888654.git.rashika.kheria@gmail.com>
References: <6f029c895035908595957fb16ab445c82793c77d.1391888654.git.rashika.kheria@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <6f029c895035908595957fb16ab445c82793c77d.1391888654.git.rashika.kheria@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move prototype declaration of functions to header file include/net/dn_route.h
from net/decnet/af_decnet.c because it is used by more than one file.

This eliminates the following warning in net/decnet/dn_route.c:
net/decnet/dn_route.c:629:5: warning: no previous prototype for ‘dn_route_rcv’ [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
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

