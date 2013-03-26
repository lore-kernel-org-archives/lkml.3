Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934047Ab3CZQOI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 12:14:08 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:53662 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964841Ab3CZPWN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 11:22:13 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: "David S. Miller" <davem@davemloft.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 042/150] macvlan: Set IFF_UNICAST_FLT flag to prevent unnecessary promisc mode.
Date: Tue, 26 Mar 2013 15:19:01 +0000
Message-Id: <1364311249-14454-43-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1364311249-14454-1-git-send-email-luis.henriques@canonical.com>
References: <1364311249-14454-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.9 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vlad Yasevich <vyasevic@redhat.com>

commit 87ab7f6f2874f1115817e394a7ed2dea1c72549e upstream.

Macvlan already supports hw address filters.  Set the IFF_UNICAST_FLT
so that it doesn't needlesly enter PROMISC mode when macvlans are
stacked.

Signed-of-by: Vlad Yasevich <vyasevic@redhat.com>

Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/net/macvlan.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/macvlan.c b/drivers/net/macvlan.c
index 62ce7b8..666fc20 100644
--- a/drivers/net/macvlan.c
+++ b/drivers/net/macvlan.c
@@ -628,6 +628,7 @@ void macvlan_common_setup(struct net_device *dev)
 	ether_setup(dev);
 
 	dev->priv_flags	       &= ~(IFF_XMIT_DST_RELEASE | IFF_TX_SKB_SHARING);
+	dev->priv_flags	       |= IFF_UNICAST_FLT;
 	dev->netdev_ops		= &macvlan_netdev_ops;
 	dev->destructor		= free_netdev;
 	dev->header_ops		= &macvlan_hard_header_ops,
-- 
1.8.1.2

