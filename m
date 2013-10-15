Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932581Ab3JOL62 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 07:58:28 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:5453 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932408Ab3JOL6V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 07:58:21 -0400
From: Kefeng Wang <wangkefeng.wang@huawei.com>
To: <linux-kernel@vger.kernel.org>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        "Stephen Hemminger" <stephen@networkplumber.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        "John W. Linville" <linville@tuxdriver.com>,
        Stanislaw Gruszka <sgruszka@redhat.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Francois Romieu <romieu@fr.zoreil.com>,
        "Ben Hutchings" <bhutchings@solarflare.com>,
        Chas Williams <chas@cmf.nrl.navy.mil>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Samuel Ortiz <samuel@sortiz.org>, Paul Mackerras <paulus@samba.org>,
        Oliver Neukum <oneukum@suse.de>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "Boris Ostrovsky" <boris.ostrovsky@oracle.com>,
        David Vrabel <david.vrabel@citrix.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        "Michael S. Tsirkin" <mst@redhat.com>, <netfilter@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-wireless@vger.kernel.org>,
        <guohanjun@huawei.com>
Subject: [PATCH 16/18] net: virtio: use wrapper functions of net_ratelimit() to simplify code
Date: Tue, 15 Oct 2013 19:45:12 +0800
Message-ID: <1381837514-50660-17-git-send-email-wangkefeng.wang@huawei.com>
X-Mailer: git-send-email 1.8.3.msysgit.0
In-Reply-To: <1381837514-50660-1-git-send-email-wangkefeng.wang@huawei.com>
References: <1381837514-50660-1-git-send-email-wangkefeng.wang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.135.68.221]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

net_ratelimited_function() is called to simplify code.

Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
---
 drivers/net/virtio_net.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index defec2b..4f63c12 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -753,8 +753,7 @@ static netdev_tx_t start_xmit(struct sk_buff *skb, struct net_device *dev)
 	/* This should not happen! */
 	if (unlikely(err)) {
 		dev->stats.tx_fifo_errors++;
-		if (net_ratelimit())
-			dev_warn(&dev->dev,
+		net_ratelimited_function(dev_warn, &dev->dev,
 				 "Unexpected TXQ (%d) queue failure: %d\n", qnum, err);
 		dev->stats.tx_dropped++;
 		kfree_skb(skb);
-- 
1.8.2.1


