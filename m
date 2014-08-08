Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758603AbaHHVgA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 17:36:00 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:60336 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758511AbaHHVfy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 17:35:54 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Vlad Yasevich <vyasevic@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.4 07/23] macvlan: Initialize vlan_features to turn on offload support.
Date: Fri,  8 Aug 2014 14:34:52 -0700
Message-Id: <20140808213316.077926487@linuxfoundation.org>
X-Mailer: git-send-email 2.0.4
In-Reply-To: <20140808213315.769217722@linuxfoundation.org>
References: <20140808213315.769217722@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vlad Yasevich <vyasevic@redhat.com>

[ Upstream commit 081e83a78db9b0ae1f5eabc2dedecc865f509b98 ]

Macvlan devices do not initialize vlan_features.  As a result,
any vlan devices configured on top of macvlans perform very poorly.
Initialize vlan_features based on the vlan features of the lower-level
device.

Signed-off-by: Vlad Yasevich <vyasevic@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/macvlan.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/net/macvlan.c
+++ b/drivers/net/macvlan.c
@@ -455,6 +455,7 @@ static int macvlan_init(struct net_devic
 				  (lowerdev->state & MACVLAN_STATE_MASK);
 	dev->features 		= lowerdev->features & MACVLAN_FEATURES;
 	dev->features		|= NETIF_F_LLTX;
+	dev->vlan_features	= lowerdev->vlan_features & MACVLAN_FEATURES;
 	dev->gso_max_size	= lowerdev->gso_max_size;
 	dev->iflink		= lowerdev->ifindex;
 	dev->hard_header_len	= lowerdev->hard_header_len;


