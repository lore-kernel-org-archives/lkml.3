Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932105AbaEHVRx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 17:17:53 -0400
Received: from p3plsmtps2ded03.prod.phx3.secureserver.net ([208.109.80.60]:59997
	"EHLO p3plsmtps2ded03.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755752AbaEHVRw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 17:17:52 -0400
x-originating-ip: 72.167.245.219
From: Haiyang Zhang <haiyangz@microsoft.com>
To: davem@davemloft.net, netdev@vger.kernel.org
Cc: haiyangz@microsoft.com, kys@microsoft.com, olaf@aepfle.de,
        jasowang@redhat.com, linux-kernel@vger.kernel.org,
        driverdev-devel@linuxdriverproject.org
Subject: [PATCH net-next,v3] Add support for netvsc build without CONFIG_SYSFS flag
Date: Thu,  8 May 2014 15:14:10 -0700
Message-Id: <1399587250-27846-1-git-send-email-haiyangz@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This change ensures the driver can be built successfully without the
CONFIG_SYSFS flag.
MS-TFS: 182270

Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Reviewed-by: K. Y. Srinivasan <kys@microsoft.com>
---
 drivers/net/hyperv/netvsc_drv.c |    5 +----
 1 files changed, 1 insertions(+), 4 deletions(-)

diff --git a/drivers/net/hyperv/netvsc_drv.c b/drivers/net/hyperv/netvsc_drv.c
index 939e3af..083d084 100644
--- a/drivers/net/hyperv/netvsc_drv.c
+++ b/drivers/net/hyperv/netvsc_drv.c
@@ -640,8 +640,7 @@ int netvsc_recv_callback(struct hv_device *device_obj,
 				       packet->vlan_tci);
 
 	skb_record_rx_queue(skb, packet->channel->
-			    offermsg.offer.sub_channel_index %
-			    net->real_num_rx_queues);
+			    offermsg.offer.sub_channel_index);
 
 	net->stats.rx_packets++;
 	net->stats.rx_bytes += packet->total_data_buflen;
@@ -824,8 +823,6 @@ static int netvsc_probe(struct hv_device *dev,
 	nvdev = hv_get_drvdata(dev);
 	netif_set_real_num_tx_queues(net, nvdev->num_chn);
 	netif_set_real_num_rx_queues(net, nvdev->num_chn);
-	dev_info(&dev->device, "real num tx,rx queues:%u, %u\n",
-		 net->real_num_tx_queues, net->real_num_rx_queues);
 
 	ret = register_netdev(net);
 	if (ret != 0) {
-- 
1.7.4.1

