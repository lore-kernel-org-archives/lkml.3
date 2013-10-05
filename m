Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752860Ab3JEViL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Oct 2013 17:38:11 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:40187 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752610Ab3JEViJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Oct 2013 17:38:09 -0400
X-Sasl-enc: 7ExebRv/pahfuZJUVQnoN+4b7b0YK+ZTMS16lONM2ltP 1381009086
From: Alan Ott <alan@signal11.us>
To: Alexander Smirnov <alex.bluesman.smirnov@gmail.com>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Cc: linux-zigbee-devel@lists.sourceforge.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Alan Ott <alan@signal11.us>
Subject: [PATCH] 6lowpan: Sync default hardware address of lowpan links to their wpan
Date: Sat,  5 Oct 2013 17:38:00 -0400
Message-Id: <1381009080-15945-1-git-send-email-alan@signal11.us>
X-Mailer: git-send-email 1.8.1.2
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
index c85e71e..fb89133 100644
--- a/net/ieee802154/6lowpan.c
+++ b/net/ieee802154/6lowpan.c
@@ -1386,6 +1386,9 @@ static int lowpan_newlink(struct net *src_net, struct net_device *dev,
 
 	entry->ldev = dev;
 
+	BUG_ON(IEEE802154_ADDR_LEN != dev->addr_len);
+	memcpy(dev->dev_addr, real_dev->dev_addr, IEEE802154_ADDR_LEN);
+
 	mutex_lock(&lowpan_dev_info(dev)->dev_list_mtx);
 	INIT_LIST_HEAD(&entry->list);
 	list_add_tail(&entry->list, &lowpan_devices);
-- 
1.8.1.2

