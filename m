Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753572Ab3JFDPy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Oct 2013 23:15:54 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:38852 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753313Ab3JFDPf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Oct 2013 23:15:35 -0400
X-Sasl-enc: jITjxTzbbfQvqj8vCxuQWue1UcLmzYK0aOfAbgJ97FXx 1381029332
From: Alan Ott <alan@signal11.us>
To: Alexander Smirnov <alex.bluesman.smirnov@gmail.com>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Cc: Alexander Aring <alex.aring@gmail.com>,
        linux-zigbee-devel@lists.sourceforge.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Alan Ott <alan@signal11.us>
Subject: [PATCH v2 1/2] 6lowpan: Only make 6lowpan links to IEEE802154 devices
Date: Sat,  5 Oct 2013 23:15:18 -0400
Message-Id: <1381029319-6835-2-git-send-email-alan@signal11.us>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1381029319-6835-1-git-send-email-alan@signal11.us>
References: <1381029319-6835-1-git-send-email-alan@signal11.us>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Refuse to create 6lowpan links if the actual hardware interface is
of any type other than ARPHRD_IEEE802154.

Signed-off-by: Alan Ott <alan@signal11.us>
Suggested-by: Alexander Aring <alex.aring@gmail.com>
---
 net/ieee802154/6lowpan.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/ieee802154/6lowpan.c b/net/ieee802154/6lowpan.c
index c85e71e..8f56b2b 100644
--- a/net/ieee802154/6lowpan.c
+++ b/net/ieee802154/6lowpan.c
@@ -1372,6 +1372,8 @@ static int lowpan_newlink(struct net *src_net, struct net_device *dev,
 	real_dev = dev_get_by_index(src_net, nla_get_u32(tb[IFLA_LINK]));
 	if (!real_dev)
 		return -ENODEV;
+	if (real_dev->type != ARPHRD_IEEE802154)
+		return -EINVAL;
 
 	lowpan_dev_info(dev)->real_dev = real_dev;
 	lowpan_dev_info(dev)->fragment_tag = 0;
-- 
1.8.1.2

