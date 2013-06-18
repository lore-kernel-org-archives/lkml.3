Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754023Ab3FRC0y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 22:26:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57392 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753803Ab3FRC0w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 22:26:52 -0400
Date: Mon, 17 Jun 2013 22:26:40 -0400
Message-Id: <201306180226.r5I2QeZl010822@gelk.kernelslacker.org>
From: Dave Jones <davej@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: linville@tuxdriver.com, gregkh@linuxfoundation.org
Cc: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 3/7] staging/rtl8192u: remove commented out __list_for_each usage
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Also remove another commented out open-coded list manipulation while we're there.

Signed-off-by: Dave Jones <davej@redhat.com>
---
 drivers/staging/rtl8192u/ieee80211/ieee80211_rx.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/staging/rtl8192u/ieee80211/ieee80211_rx.c b/drivers/staging/rtl8192u/ieee80211/ieee80211_rx.c
index ee7ce5f..8d0b6c5 100644
--- a/drivers/staging/rtl8192u/ieee80211/ieee80211_rx.c
+++ b/drivers/staging/rtl8192u/ieee80211/ieee80211_rx.c
@@ -454,8 +454,7 @@ static int is_duplicate_packet(struct ieee80211_device *ieee,
 		struct ieee_ibss_seq *entry = NULL;
 		u8 *mac = header->addr2;
 		int index = mac[5] % IEEE_IBSS_MAC_HASH_SIZE;
-		//for (pos = (head)->next; pos != (head); pos = pos->next)
-		//__list_for_each(p, &ieee->ibss_mac_hash[index]) {
+
 		list_for_each(p, &ieee->ibss_mac_hash[index]) {
 			entry = list_entry(p, struct ieee_ibss_seq, list);
 			if (!memcmp(entry->mac, mac, ETH_ALEN))
-- 
1.8.1.4

