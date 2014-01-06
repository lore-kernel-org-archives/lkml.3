Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933736AbaAFXUj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 18:20:39 -0500
Received: from mail-qc0-f178.google.com ([209.85.216.178]:45052 "EHLO
	mail-qc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932962AbaAFXUh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 18:20:37 -0500
From: Benjamin Poirier <bpoirier@suse.de>
To: "David S. Miller" <davem@davemloft.net>
Cc: Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Tom Herbert <therbert@google.com>
Subject: [PATCH] net: Do not enable tx-nocache-copy by default
Date: Mon,  6 Jan 2014 18:20:19 -0500
Message-Id: <1389050419-9060-1-git-send-email-bpoirier@suse.de>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1389041855.12212.210.camel@edumazet-glaptop2.roam.corp.google.com>
References: <1389041855.12212.210.camel@edumazet-glaptop2.roam.corp.google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are many cases where this feature does not improve performance or even
reduces it. See the following discussion for example perf numbers:
http://thread.gmane.org/gmane.linux.network/298345

CC: Tom Herbert <therbert@google.com>
Signed-off-by: Benjamin Poirier <bpoirier@suse.de>
---
 net/core/dev.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index 153ee2f..2e242583 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -5783,13 +5783,8 @@ int register_netdevice(struct net_device *dev)
 	dev->features |= NETIF_F_SOFT_FEATURES;
 	dev->wanted_features = dev->features & dev->hw_features;
 
-	/* Turn on no cache copy if HW is doing checksum */
 	if (!(dev->flags & IFF_LOOPBACK)) {
 		dev->hw_features |= NETIF_F_NOCACHE_COPY;
-		if (dev->features & NETIF_F_ALL_CSUM) {
-			dev->wanted_features |= NETIF_F_NOCACHE_COPY;
-			dev->features |= NETIF_F_NOCACHE_COPY;
-		}
 	}
 
 	/* Make NETIF_F_HIGHDMA inheritable to VLAN devices.
-- 
1.8.4

