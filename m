Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754655Ab3L0Gty (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Dec 2013 01:49:54 -0500
Received: from szxga01-in.huawei.com ([119.145.14.64]:40519 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754599Ab3L0Gtw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Dec 2013 01:49:52 -0500
Message-ID: <52BD22F0.7080307@huawei.com>
Date: Fri, 27 Dec 2013 14:49:20 +0800
From: Ding Tianhong <dingtianhong@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
MIME-Version: 1.0
To: Dmitry Tarnyagin <dmitry.tarnyagin@lockless.no>,
        "David S. Miller" <davem@davemloft.net>,
        Netdev <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH net-next 20/20] net: caif: slight optimization of addr compare
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.72.199]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use possibly more efficient ether_addr_equal
to instead of memcmp.

Cc: Dmitry Tarnyagin <dmitry.tarnyagin@lockless.no>
Cc: "David S. Miller" <davem@davemloft.net>
Signed-off-by: Ding Tianhong <dingtianhong@huawei.com>
---
 net/caif/cfrfml.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/caif/cfrfml.c b/net/caif/cfrfml.c
index 61d7617..c680414 100644
--- a/net/caif/cfrfml.c
+++ b/net/caif/cfrfml.c
@@ -79,7 +79,7 @@ static struct cfpkt *rfm_append(struct cfrfml *rfml, char *seghead,
 		return NULL;
 
 	/* Verify correct header */
-	if (memcmp(seghead, rfml->seghead, 6) != 0)
+	if (!ether_addr_equal(seghead, rfml->seghead))
 		return NULL;
 
 	tmppkt = cfpkt_append(rfml->incomplete_frm, pkt,
-- 
1.8.0


