Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753172Ab3LZLlv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Dec 2013 06:41:51 -0500
Received: from szxga02-in.huawei.com ([119.145.14.65]:4145 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753101Ab3LZLlt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Dec 2013 06:41:49 -0500
Message-ID: <52BC15C8.2080400@huawei.com>
Date: Thu, 26 Dec 2013 19:40:56 +0800
From: Ding Tianhong <dingtianhong@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>,
        "John W. Linville" <linville@tuxdriver.com>,
        "David S. Miller" <davem@davemloft.net>,
        <linux-wireless@vger.kernel.org>, Netdev <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH v3.5 10/19] mac8011: slight optimization of addr compare
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.72.199]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the possibly more efficient ether_addr_equal
to instead of memcmp.

Cc: Johannes Berg <johannes@sipsolutions.net>
Cc: John W. Linville <linville@tuxdriver.com>
Cc: David Miller <davem@davemloft.net>
Cc: linux-wireless@vger.kernel.org
Cc: netdev@vger.kernel.org
Signed-off-by: Wang Weidong <wangweidong1@huawei.com>
Signed-off-by: Ding Tianhong <dingtianhong@huawei.com>
---
 net/mac80211/iface.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index 7aa9f9d..a4f9812 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -1497,8 +1497,8 @@ static void ieee80211_assign_perm_addr(struct ieee80211_local *local,
 			bool used = false;
 
 			list_for_each_entry(sdata, &local->interfaces, list) {
-				if (memcmp(local->hw.wiphy->addresses[i].addr,
-					   sdata->vif.addr, ETH_ALEN) == 0) {
+				if (ether_addr_equal(local->hw.wiphy->addresses[i].addr,
+						     sdata->vif.addr)) {
 					used = true;
 					break;
 				}
@@ -1558,8 +1558,7 @@ static void ieee80211_assign_perm_addr(struct ieee80211_local *local,
 			val += inc;
 
 			list_for_each_entry(sdata, &local->interfaces, list) {
-				if (memcmp(tmp_addr, sdata->vif.addr,
-							ETH_ALEN) == 0) {
+				if (ether_addr_equal(tmp_addr, sdata->vif.addr)) {
 					used = true;
 					break;
 				}
-- 
1.8.0


