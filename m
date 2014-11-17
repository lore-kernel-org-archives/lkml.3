Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753169AbaKQVXX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 16:23:23 -0500
Received: from mailrelay008.isp.belgacom.be ([195.238.6.174]:24367 "EHLO
	mailrelay008.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753130AbaKQVXW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 16:23:22 -0500
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AtcNANVmalRXQyyZ/2dsb2JhbABbgw6BLrhwBQF1mhWBEhcBAQEBAX2EMC8jgRo3iEUBwjeQICyGPopkHYQ1BZAfji2NEologUcBgjU8MIJLAQEB
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Fabian Frederick <fabf@skynet.be>, "David S. Miller" <davem@davemloft.net>,
        netdev@vger.kernel.org
Subject: [PATCH 1/1 net-next] dev_ioctl: use sizeof(x) instead of sizeof x
Date: Mon, 17 Nov 2014 22:23:17 +0100
Message-Id: <1416259397-10954-1-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Also remove spaces after cast.

Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 net/core/dev_ioctl.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/net/core/dev_ioctl.c b/net/core/dev_ioctl.c
index 72e899a..b94b1d2 100644
--- a/net/core/dev_ioctl.c
+++ b/net/core/dev_ioctl.c
@@ -142,10 +142,12 @@ static int dev_ifsioc_locked(struct net *net, struct ifreq *ifr, unsigned int cm
 
 	case SIOCGIFHWADDR:
 		if (!dev->addr_len)
-			memset(ifr->ifr_hwaddr.sa_data, 0, sizeof ifr->ifr_hwaddr.sa_data);
+			memset(ifr->ifr_hwaddr.sa_data, 0,
+			       sizeof(ifr->ifr_hwaddr.sa_data));
 		else
 			memcpy(ifr->ifr_hwaddr.sa_data, dev->dev_addr,
-			       min(sizeof ifr->ifr_hwaddr.sa_data, (size_t) dev->addr_len));
+			       min(sizeof(ifr->ifr_hwaddr.sa_data),
+				   (size_t)dev->addr_len));
 		ifr->ifr_hwaddr.sa_family = dev->type;
 		return 0;
 
@@ -265,7 +267,8 @@ static int dev_ifsioc(struct net *net, struct ifreq *ifr, unsigned int cmd)
 		if (ifr->ifr_hwaddr.sa_family != dev->type)
 			return -EINVAL;
 		memcpy(dev->broadcast, ifr->ifr_hwaddr.sa_data,
-		       min(sizeof ifr->ifr_hwaddr.sa_data, (size_t) dev->addr_len));
+		       min(sizeof(ifr->ifr_hwaddr.sa_data),
+			   (size_t)dev->addr_len));
 		call_netdevice_notifiers(NETDEV_CHANGEADDR, dev);
 		return 0;
 
-- 
1.9.3

