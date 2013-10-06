Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753696Ab3JFDQA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Oct 2013 23:16:00 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:46712 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753322Ab3JFDPg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Oct 2013 23:15:36 -0400
X-Sasl-enc: NIrmBNUiBmm6ZK4BwRavRJlkDy5YxsgMD/Yrw2F6gfnL 1381029335
From: Alan Ott <alan@signal11.us>
To: Alexander Smirnov <alex.bluesman.smirnov@gmail.com>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Cc: Alexander Aring <alex.aring@gmail.com>,
        linux-zigbee-devel@lists.sourceforge.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Alan Ott <alan@signal11.us>
Subject: [PATCH v2 2/2] 6lowpan: Sync default hardware address of lowpan links to their wpan
Date: Sat,  5 Oct 2013 23:15:19 -0400
Message-Id: <1381029319-6835-3-git-send-email-alan@signal11.us>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1381029319-6835-1-git-send-email-alan@signal11.us>
References: <1381029319-6835-1-git-send-email-alan@signal11.us>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When a lowpan link to a wpan device is created, set the hardware address
of the lowpan link to that of the wpan device.

Signed-off-by: Alan Ott <alan@signal11.us>
---
 net/ieee802154/6lowpan.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/ieee802154/6lowpan.c b/net/ieee802154/6lowpan.c
index 8f56b2b..ff41b4d 100644
--- a/net/ieee802154/6lowpan.c
+++ b/net/ieee802154/6lowpan.c
@@ -1388,6 +1388,9 @@ static int lowpan_newlink(struct net *src_net, struct net_device *dev,
 
 	entry->ldev = dev;
 
+	/* Set the lowpan harware address to the wpan hardware address. */
+	memcpy(dev->dev_addr, real_dev->dev_addr, IEEE802154_ADDR_LEN);
+
 	mutex_lock(&lowpan_dev_info(dev)->dev_list_mtx);
 	INIT_LIST_HEAD(&entry->list);
 	list_add_tail(&entry->list, &lowpan_devices);
-- 
1.8.1.2

