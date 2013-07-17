Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751848Ab3GQFXm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 01:23:42 -0400
Received: from p3plsmtps2ded01.prod.phx3.secureserver.net ([208.109.80.58]:36671
	"EHLO p3plsmtps2ded01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751370Ab3GQFXl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 01:23:41 -0400
x-originating-ip: 72.167.245.219
From: Haiyang Zhang <haiyangz@microsoft.com>
To: davem@davemloft.net, netdev@vger.kernel.org
Cc: haiyangz@microsoft.com, kys@microsoft.com, olaf@aepfle.de,
        jasowang@redhat.com, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org
Subject: [PATCH net] hyperv: Fix the NETIF_F_SG flag setting in netvsc
Date: Tue, 16 Jul 2013 23:01:20 -0700
Message-Id: <1374040880-20468-1-git-send-email-haiyangz@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

SG mode is not currently supported by netvsc, so remove this flag for now.
Otherwise, it will be unconditionally enabled by commit ec5f0615642
    "Kill link between CSUM and SG features"
Previously, the SG feature is disabled because CSUM is not set here.

Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Reviewed-by: K. Y. Srinivasan <kys@microsoft.com>
---
 drivers/net/hyperv/netvsc_drv.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/hyperv/netvsc_drv.c b/drivers/net/hyperv/netvsc_drv.c
index 4dccead..23a0fff 100644
--- a/drivers/net/hyperv/netvsc_drv.c
+++ b/drivers/net/hyperv/netvsc_drv.c
@@ -431,8 +431,8 @@ static int netvsc_probe(struct hv_device *dev,
 	net->netdev_ops = &device_ops;
 
 	/* TODO: Add GSO and Checksum offload */
-	net->hw_features = NETIF_F_SG;
-	net->features = NETIF_F_SG | NETIF_F_HW_VLAN_CTAG_TX;
+	net->hw_features = 0;
+	net->features = NETIF_F_HW_VLAN_CTAG_TX;
 
 	SET_ETHTOOL_OPS(net, &ethtool_ops);
 	SET_NETDEV_DEV(net, &dev->device);
-- 
1.7.4.1

