Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932529Ab3JOL6P (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 07:58:15 -0400
Received: from szxga03-in.huawei.com ([119.145.14.66]:62891 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932408Ab3JOL6K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 07:58:10 -0400
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
Subject: [PATCH 18/18] net: wimax: use wrapper functions of net_ratelimit() to simplify code
Date: Tue, 15 Oct 2013 19:45:14 +0800
Message-ID: <1381837514-50660-19-git-send-email-wangkefeng.wang@huawei.com>
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
 drivers/net/wimax/i2400m/netdev.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/wimax/i2400m/netdev.c b/drivers/net/wimax/i2400m/netdev.c
index 4889613..678717a 100644
--- a/drivers/net/wimax/i2400m/netdev.c
+++ b/drivers/net/wimax/i2400m/netdev.c
@@ -305,8 +305,7 @@ int i2400m_net_wake_tx(struct i2400m *i2400m, struct net_device *net_dev,
 		 * queue -- blame the queue disciplines that
 		 * queue without looking -- I guess there is a reason
 		 * for that. */
-		if (net_ratelimit())
-			d_printf(1, dev, "NETTX: device exiting idle, "
+		net_ratelimited_function(d_printf, 1, dev, "NETTX: device exiting idle, "
 				 "dropping skb %p, queue running %d\n",
 				 skb, netif_queue_stopped(net_dev));
 		result = -EBUSY;
-- 
1.8.2.1


