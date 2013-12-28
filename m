Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755376Ab3L1GTO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Dec 2013 01:19:14 -0500
Received: from szxga02-in.huawei.com ([119.145.14.65]:25621 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755338Ab3L1GTL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Dec 2013 01:19:11 -0500
Message-ID: <52BE6D50.9000308@huawei.com>
Date: Sat, 28 Dec 2013 14:18:56 +0800
From: Ding Tianhong <dingtianhong@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
MIME-Version: 1.0
To: Dmitry Tarnyagin <dmitry.tarnyagin@lockless.no>,
        "David S. Miller" <davem@davemloft.net>,
        Netdev <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH net-next v2 20/20] net: caif: slight optimization of addr
 compare
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


