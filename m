Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755774Ab3L3Hn2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Dec 2013 02:43:28 -0500
Received: from szxga01-in.huawei.com ([119.145.14.64]:26033 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754500Ab3L3Hle (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Dec 2013 02:41:34 -0500
Message-ID: <52C123AA.1050008@huawei.com>
Date: Mon, 30 Dec 2013 15:41:30 +0800
From: Ding Tianhong <dingtianhong@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
MIME-Version: 1.0
To: "David S. Miller" <davem@davemloft.net>, Netdev <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH net-next v3 18/19] net: fddi: slight optimization of addr
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

Cc: "David S. Miller" <davem@davemloft.net>
Signed-off-by: Ding Tianhong <dingtianhong@huawei.com>
---
 drivers/net/fddi/skfp/fplustm.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/fddi/skfp/fplustm.c b/drivers/net/fddi/skfp/fplustm.c
index d918d8a..7d3779a 100644
--- a/drivers/net/fddi/skfp/fplustm.c
+++ b/drivers/net/fddi/skfp/fplustm.c
@@ -23,6 +23,7 @@
 #include "h/smc.h"
 #include "h/supern_2.h"
 #include <linux/bitrev.h>
+#include <linux/etherdevice.h>
 
 #ifndef	lint
 static const char ID_sccs[] = "@(#)fplustm.c	1.32 99/02/23 (C) SK " ;
@@ -1082,7 +1083,7 @@ static struct s_fpmc* mac_get_mc_table(struct s_smc *smc,
 				slot = tb ;
 			continue ;
 		}
-		if (memcmp((char *)&tb->a,(char *)own,6))
+		if (!ether_addr_equal((char *)&tb->a, (char *)own))
 			continue ;
 		return tb;
 	}
-- 
1.8.0


