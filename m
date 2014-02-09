Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751918AbaBIQ4o (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Feb 2014 11:56:44 -0500
Received: from mail-pa0-f50.google.com ([209.85.220.50]:42078 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751488AbaBIQ4m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Feb 2014 11:56:42 -0500
From: Rashika Kheria <rashika.kheria@gmail.com>
To: linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        James Morris <jmorris@namei.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Patrick McHardy <kaber@trash.net>, netdev@vger.kernel.org,
        josh@joshtriplett.org
Subject: =?UTF-8?q?=5BPATCH=20v2=2009/13=5D=20net=3A=20Move=20prototype=20declaration=20to=20header=20file=20include/net/ipx=2Eh=20from=20net/ipx/af=5Fipx=2Ec?=
Date: Sun,  9 Feb 2014 22:26:32 +0530
Message-Id: <820c61ec008de281d921d375bf6984acc74e1bf9.1391955925.git.rashika.kheria@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <6f029c895035908595957fb16ab445c82793c77d.1391955924.git.rashika.kheria@gmail.com>
References: <6f029c895035908595957fb16ab445c82793c77d.1391955924.git.rashika.kheria@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move prototype declaration of functions to header file include/net/ipx.h
from net/ipx/af_ipx.c because they are used by more than one file.

This eliminates the following warning in
net/ipx/ipx_route.c:33:19: warning: no previous prototype for ‘ipxrtr_lookup’ [-Wmissing-prototypes]
net/ipx/ipx_route.c:52:5: warning: no previous prototype for ‘ipxrtr_add_route’ [-Wmissing-prototypes]
net/ipx/ipx_route.c:94:6: warning: no previous prototype for ‘ipxrtr_del_routes’ [-Wmissing-prototypes]
net/ipx/ipx_route.c:149:5: warning: no previous prototype for ‘ipxrtr_route_skb’ [-Wmissing-prototypes]
net/ipx/ipx_route.c:171:5: warning: no previous prototype for ‘ipxrtr_route_packet’ [-Wmissing-prototypes]
net/ipx/ipx_route.c:261:5: warning: no previous prototype for ‘ipxrtr_ioctl’ [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 include/net/ipx.h |    8 ++++++++
 net/ipx/af_ipx.c  |    9 ---------
 2 files changed, 8 insertions(+), 9 deletions(-)

diff --git a/include/net/ipx.h b/include/net/ipx.h
index 75466ac..0143180 100644
--- a/include/net/ipx.h
+++ b/include/net/ipx.h
@@ -143,6 +143,14 @@ void ipxitf_down(struct ipx_interface *intrfc);
 struct ipx_interface *ipxitf_find_using_net(__be32 net);
 int ipxitf_send(struct ipx_interface *intrfc, struct sk_buff *skb, char *node);
 __be16 ipx_cksum(struct ipxhdr *packet, int length);
+int ipxrtr_add_route(__be32 network, struct ipx_interface *intrfc,
+		     unsigned char *node);
+void ipxrtr_del_routes(struct ipx_interface *intrfc);
+int ipxrtr_route_packet(struct sock *sk, struct sockaddr_ipx *usipx,
+			struct iovec *iov, size_t len, int noblock);
+int ipxrtr_route_skb(struct sk_buff *skb);
+struct ipx_route *ipxrtr_lookup(__be32 net);
+int ipxrtr_ioctl(unsigned int cmd, void __user *arg);
 
 static __inline__ void ipxitf_put(struct ipx_interface *intrfc)
 {
diff --git a/net/ipx/af_ipx.c b/net/ipx/af_ipx.c
index 994e28b..e5a00a9 100644
--- a/net/ipx/af_ipx.c
+++ b/net/ipx/af_ipx.c
@@ -84,15 +84,6 @@ DEFINE_SPINLOCK(ipx_interfaces_lock);
 struct ipx_interface *ipx_primary_net;
 struct ipx_interface *ipx_internal_net;
 
-extern int ipxrtr_add_route(__be32 network, struct ipx_interface *intrfc,
-			    unsigned char *node);
-extern void ipxrtr_del_routes(struct ipx_interface *intrfc);
-extern int ipxrtr_route_packet(struct sock *sk, struct sockaddr_ipx *usipx,
-			       struct iovec *iov, size_t len, int noblock);
-extern int ipxrtr_route_skb(struct sk_buff *skb);
-extern struct ipx_route *ipxrtr_lookup(__be32 net);
-extern int ipxrtr_ioctl(unsigned int cmd, void __user *arg);
-
 struct ipx_interface *ipx_interfaces_head(void)
 {
 	struct ipx_interface *rc = NULL;
-- 
1.7.9.5

