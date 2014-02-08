Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751660AbaBHUCQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Feb 2014 15:02:16 -0500
Received: from mail-pb0-f45.google.com ([209.85.160.45]:62741 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751071AbaBHUCP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Feb 2014 15:02:15 -0500
Date: Sun, 9 Feb 2014 01:32:10 +0530
From: Rashika Kheria <rashika.kheria@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        James Morris <jmorris@namei.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Patrick McHardy <kaber@trash.net>, netdev@vger.kernel.org,
        josh@joshtriplett.org
Subject: [PATCH 08/13] net: Move prototype declaration to include/net/ipx.h
 from net/ipx/ipx_route.c
Message-ID: <762c7626d7226370952bf599b266b26e00dd04b2.1391888654.git.rashika.kheria@gmail.com>
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

Move prototype definition of function to header file include/net/ipx.h
from net/ipx/ipx_route.c because they are used by more than one file.

This eliminates the following warning from net/ipx/af_ipx.c:
net/ipx/af_ipx.c:193:23: warning: no previous prototype for ‘ipxitf_find_using_net’ [-Wmissing-prototypes]
net/ipx/af_ipx.c:577:5: warning: no previous prototype for ‘ipxitf_send’ [-Wmissing-prototypes]
net/ipx/af_ipx.c:1219:8: warning: no previous prototype for ‘ipx_cksum’ [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
---
 include/net/ipx.h   |    3 +++
 net/ipx/ipx_route.c |    4 ----
 2 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/include/net/ipx.h b/include/net/ipx.h
index 9e9e354..75466ac 100644
--- a/include/net/ipx.h
+++ b/include/net/ipx.h
@@ -140,6 +140,9 @@ static __inline__ void ipxitf_hold(struct ipx_interface *intrfc)
 }
 
 void ipxitf_down(struct ipx_interface *intrfc);
+struct ipx_interface *ipxitf_find_using_net(__be32 net);
+int ipxitf_send(struct ipx_interface *intrfc, struct sk_buff *skb, char *node);
+__be16 ipx_cksum(struct ipxhdr *packet, int length);
 
 static __inline__ void ipxitf_put(struct ipx_interface *intrfc)
 {
diff --git a/net/ipx/ipx_route.c b/net/ipx/ipx_route.c
index 30f4519..c1f0318 100644
--- a/net/ipx/ipx_route.c
+++ b/net/ipx/ipx_route.c
@@ -20,15 +20,11 @@ DEFINE_RWLOCK(ipx_routes_lock);
 
 extern struct ipx_interface *ipx_internal_net;
 
-extern __be16 ipx_cksum(struct ipxhdr *packet, int length);
 extern struct ipx_interface *ipxitf_find_using_net(__be32 net);
 extern int ipxitf_demux_socket(struct ipx_interface *intrfc,
 			       struct sk_buff *skb, int copy);
 extern int ipxitf_demux_socket(struct ipx_interface *intrfc,
 			       struct sk_buff *skb, int copy);
-extern int ipxitf_send(struct ipx_interface *intrfc, struct sk_buff *skb,
-		       char *node);
-extern struct ipx_interface *ipxitf_find_using_net(__be32 net);
 
 struct ipx_route *ipxrtr_lookup(__be32 net)
 {
-- 
1.7.9.5

