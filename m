Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757064Ab3LWFLC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Dec 2013 00:11:02 -0500
Received: from szxga02-in.huawei.com ([119.145.14.65]:41771 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757039Ab3LWFLA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Dec 2013 00:11:00 -0500
Message-ID: <52B7C5C5.2050304@huawei.com>
Date: Mon, 23 Dec 2013 13:10:29 +0800
From: Ding Tianhong <dingtianhong@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
MIME-Version: 1.0
To: Marek Lindner <mareklindner@neomailbox.ch>,
        Simon Wunderlich <sw@simonwunderlich.de>,
        Antonio Quartulli <antonio@meshcoding.com>,
        "David S. Miller" <davem@davemloft.net>,
        <b.a.t.m.a.n@lists.open-mesh.org>, Netdev <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH 09/21] batman-adv: slight optimization of addr compare
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.72.199]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the recently added and possibly more efficient
ether_addr_equal_unaligned to instead of memcmp.

Cc: Marek Lindner <mareklindner@neomailbox.ch>
Cc: Simon Wunderlich <sw@simonwunderlich.de>
Cc: Antonio Quartulli <antonio@meshcoding.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: b.a.t.m.a.n@lists.open-mesh.org
Cc: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Tan Xiaojun <tanxiaojun@huawei.com>
Signed-off-by: Ding Tianhong <dingtianhong@huawei.com>
---
 net/batman-adv/originator.c        | 2 +-
 net/batman-adv/translation-table.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/batman-adv/originator.c b/net/batman-adv/originator.c
index 8ab1434..0490a26 100644
--- a/net/batman-adv/originator.c
+++ b/net/batman-adv/originator.c
@@ -41,7 +41,7 @@ int batadv_compare_orig(const struct hlist_node *node, const void *data2)
 	const void *data1 = container_of(node, struct batadv_orig_node,
 					 hash_entry);
 
-	return (memcmp(data1, data2, ETH_ALEN) == 0 ? 1 : 0);
+	return ether_addr_equal_unaligned(data1, data2) ? 1 : 0;
 }
 
 /**
diff --git a/net/batman-adv/translation-table.c b/net/batman-adv/translation-table.c
index 4add57d..5e66d4b 100644
--- a/net/batman-adv/translation-table.c
+++ b/net/batman-adv/translation-table.c
@@ -51,7 +51,7 @@ static int batadv_compare_tt(const struct hlist_node *node, const void *data2)
 	const void *data1 = container_of(node, struct batadv_tt_common_entry,
 					 hash_entry);
 
-	return (memcmp(data1, data2, ETH_ALEN) == 0 ? 1 : 0);
+	return ether_addr_equal_unaligned(data1, data2) ? 1 : 0;
 }
 
 /**
-- 
1.8.0


