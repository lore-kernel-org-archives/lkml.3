Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932831Ab3JOMEI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 08:04:08 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:5109 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754203Ab3JOL6E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 07:58:04 -0400
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
Subject: [PATCH 09/18] block: aoe: use wrapper functions of net_ratelimit() to simplify code
Date: Tue, 15 Oct 2013 19:45:05 +0800
Message-ID: <1381837514-50660-10-git-send-email-wangkefeng.wang@huawei.com>
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

net_err_ratelimited() is called to simplify code.

Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
---
 drivers/block/aoe/aoenet.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/block/aoe/aoenet.c b/drivers/block/aoe/aoenet.c
index 63773a9..25e8764 100644
--- a/drivers/block/aoe/aoenet.c
+++ b/drivers/block/aoe/aoenet.c
@@ -159,9 +159,7 @@ aoenet_rcv(struct sk_buff *skb, struct net_device *ifp, struct packet_type *pt,
 		n = h->err;
 		if (n > NECODES)
 			n = 0;
-		if (net_ratelimit())
-			printk(KERN_ERR
-				"%s%d.%d@%s; ecode=%d '%s'\n",
+		net_err_ratelimited("%s%d.%d@%s; ecode=%d '%s'\n",
 				"aoe: error packet from ",
 				get_unaligned_be16(&h->major),
 				h->minor, skb->dev->name,
-- 
1.8.2.1


