Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932306Ab3CRVJs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 17:09:48 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45973 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756401Ab3CRVIM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 17:08:12 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 42/48] macvlan: Set IFF_UNICAST_FLT flag to prevent unnecessary promisc mode.
Date: Mon, 18 Mar 2013 14:08:50 -0700
Message-Id: <20130318210813.221690642@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.2.434.g9a6c84e.dirty
In-Reply-To: <20130318210810.247845918@linuxfoundation.org>
References: <20130318210810.247845918@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------


From: Vlad Yasevich <vyasevic@redhat.com>

[ Upstream commit 87ab7f6f2874f1115817e394a7ed2dea1c72549e ]

Macvlan already supports hw address filters.  Set the IFF_UNICAST_FLT
so that it doesn't needlesly enter PROMISC mode when macvlans are
stacked.

Signed-of-by: Vlad Yasevich <vyasevic@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/macvlan.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/net/macvlan.c
+++ b/drivers/net/macvlan.c
@@ -584,6 +584,7 @@ void macvlan_common_setup(struct net_dev
 	ether_setup(dev);
 
 	dev->priv_flags	       &= ~(IFF_XMIT_DST_RELEASE | IFF_TX_SKB_SHARING);
+	dev->priv_flags	       |= IFF_UNICAST_FLT;
 	dev->netdev_ops		= &macvlan_netdev_ops;
 	dev->destructor		= free_netdev;
 	dev->header_ops		= &macvlan_hard_header_ops,


