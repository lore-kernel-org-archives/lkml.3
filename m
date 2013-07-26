Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759962Ab3GZUso (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 16:48:44 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:50814 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759922Ab3GZUsb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 16:48:31 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Haiyang Zhang <haiyangz@microsoft.com>,
        "K. Y. Srinivasan" <kys@microsoft.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 37/79] hyperv: Fix the NETIF_F_SG flag setting in netvsc
Date: Fri, 26 Jul 2013 13:47:27 -0700
Message-Id: <20130726204725.808145355@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130726204721.849052763@linuxfoundation.org>
References: <20130726204721.849052763@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Haiyang Zhang <haiyangz@microsoft.com>

[ Upstream commit f45708209dc445bac0844f6ce86e315a2ffe8a29 ]

SG mode is not currently supported by netvsc, so remove this flag for now.
Otherwise, it will be unconditionally enabled by commit ec5f0615642
    "Kill link between CSUM and SG features"
Previously, the SG feature is disabled because CSUM is not set here.

Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Reviewed-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/hyperv/netvsc_drv.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/net/hyperv/netvsc_drv.c
+++ b/drivers/net/hyperv/netvsc_drv.c
@@ -431,8 +431,8 @@ static int netvsc_probe(struct hv_device
 	net->netdev_ops = &device_ops;
 
 	/* TODO: Add GSO and Checksum offload */
-	net->hw_features = NETIF_F_SG;
-	net->features = NETIF_F_SG | NETIF_F_HW_VLAN_CTAG_TX;
+	net->hw_features = 0;
+	net->features = NETIF_F_HW_VLAN_CTAG_TX;
 
 	SET_ETHTOOL_OPS(net, &ethtool_ops);
 	SET_NETDEV_DEV(net, &dev->device);


