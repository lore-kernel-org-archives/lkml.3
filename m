Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932196Ab3LWFLl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Dec 2013 00:11:41 -0500
Received: from szxga03-in.huawei.com ([119.145.14.66]:42429 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932122Ab3LWFLj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Dec 2013 00:11:39 -0500
Message-ID: <52B7C5DA.9090307@huawei.com>
Date: Mon, 23 Dec 2013 13:10:50 +0800
From: Ding Tianhong <dingtianhong@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>,
        "John W. Linville" <linville@tuxdriver.com>,
        "David S. Miller" <davem@davemloft.net>,
        <linux-wireless@vger.kernel.org>, Netdev <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH 13/21] mac8011: slight optimization of addr compare
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.72.199]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the recently added and possibly more efficient
ether_addr_equal_unaligned to instead of memcmp.

Cc: Johannes Berg <johannes@sipsolutions.net>
Cc: John W. Linville <linville@tuxdriver.com>
Cc: David Miller <davem@davemloft.net>
Cc: linux-wireless@vger.kernel.org
Cc: netdev@vger.kernel.org
Signed-off-by: Wang Weidong <wangweidong1@huawei.com>
Signed-off-by: Ding Tianhong <dingtianhong@huawei.com>
---
 net/mac80211/iface.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index 7aa9f9d..1773e17 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -1497,8 +1497,7 @@ static void ieee80211_assign_perm_addr(struct ieee80211_local *local,
 			bool used = false;
 
 			list_for_each_entry(sdata, &local->interfaces, list) {
-				if (memcmp(local->hw.wiphy->addresses[i].addr,
-					   sdata->vif.addr, ETH_ALEN) == 0) {
+				if (ether_addr_equal_unaligned(local->hw.wiphy->addresses[i].addr, sdata->vif.addr)) {
 					used = true;
 					break;
 				}
@@ -1558,8 +1557,7 @@ static void ieee80211_assign_perm_addr(struct ieee80211_local *local,
 			val += inc;
 
 			list_for_each_entry(sdata, &local->interfaces, list) {
-				if (memcmp(tmp_addr, sdata->vif.addr,
-							ETH_ALEN) == 0) {
+				if (ether_addr_equal_unaligned(tmp_addr, sdata->vif.addr)) {
 					used = true;
 					break;
 				}
-- 
1.8.0


