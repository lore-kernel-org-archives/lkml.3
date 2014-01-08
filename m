Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755070AbaAHCyD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 21:54:03 -0500
Received: from szxga01-in.huawei.com ([119.145.14.64]:40069 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754935AbaAHCxh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 21:53:37 -0500
Message-ID: <52CCBDA6.3020901@huawei.com>
Date: Wed, 8 Jan 2014 10:53:26 +0800
From: Ding Tianhong <dingtianhong@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
MIME-Version: 1.0
To: Michal Ostrowski <mostrows@earthlink.net>, Netdev <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH v3.6 05/19] ppp: slight optimization of addr compare
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.22.246]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use possibly more efficient ether_addr_equal
to instead of memcmp.

Cc: Michal Ostrowski <mostrows@earthlink.net>
Cc: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Ding Tianhong <dingtianhong@huawei.com>
---
 drivers/net/ppp/pppoe.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ppp/pppoe.c b/drivers/net/ppp/pppoe.c
index 82ee6ed..2ea7efd 100644
--- a/drivers/net/ppp/pppoe.c
+++ b/drivers/net/ppp/pppoe.c
@@ -131,12 +131,12 @@ static inline struct pppoe_net *pppoe_pernet(struct net *net)
 
 static inline int cmp_2_addr(struct pppoe_addr *a, struct pppoe_addr *b)
 {
-	return a->sid == b->sid && !memcmp(a->remote, b->remote, ETH_ALEN);
+	return a->sid == b->sid && ether_addr_equal(a->remote, b->remote);
 }
 
 static inline int cmp_addr(struct pppoe_addr *a, __be16 sid, char *addr)
 {
-	return a->sid == sid && !memcmp(a->remote, addr, ETH_ALEN);
+	return a->sid == sid && ether_addr_equal(a->remote, addr);
 }
 
 #if 8 % PPPOE_HASH_BITS
-- 
1.8.0


