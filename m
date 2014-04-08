Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758019AbaDHSzY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 14:55:24 -0400
Received: from p3plsmtps2ded01.prod.phx3.secureserver.net ([208.109.80.58]:34315
	"EHLO p3plsmtps2ded01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757584AbaDHSvx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 14:51:53 -0400
x-originating-ip: 72.167.245.219
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: davem@davemloft.net, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, olaf@aepfle.de, apw@canonical.com,
        jasowang@redhat.com
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH net 1/3] Drivers: net: hyperv: Allocate memory for all possible per-pecket information
Date: Tue,  8 Apr 2014 12:46:09 -0700
Message-Id: <1396986371-12137-2-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1396986371-12137-1-git-send-email-kys@microsoft.com>
References: <1396986332-12098-1-git-send-email-kys@microsoft.com>
 <1396986371-12137-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

An outgoing packet can potentially need per-packet information for
all the offloads and VLAN tagging. Fix this issue.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Reviewed-by: Haiyang Zhang <haiyangz@microsoft.com>
---
 drivers/net/hyperv/netvsc_drv.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/net/hyperv/netvsc_drv.c b/drivers/net/hyperv/netvsc_drv.c
index 4e4cf9e..6f39baa 100644
--- a/drivers/net/hyperv/netvsc_drv.c
+++ b/drivers/net/hyperv/netvsc_drv.c
@@ -319,7 +319,9 @@ static int netvsc_start_xmit(struct sk_buff *skb, struct net_device *net)
 	packet = kzalloc(sizeof(struct hv_netvsc_packet) +
 			 (num_data_pgs * sizeof(struct hv_page_buffer)) +
 			 sizeof(struct rndis_message) +
-			 NDIS_VLAN_PPI_SIZE, GFP_ATOMIC);
+			 NDIS_VLAN_PPI_SIZE +
+			 NDIS_CSUM_PPI_SIZE +
+			 NDIS_LSO_PPI_SIZE, GFP_ATOMIC);
 	if (!packet) {
 		/* out of memory, drop packet */
 		netdev_err(net, "unable to allocate hv_netvsc_packet\n");
-- 
1.7.4.1

