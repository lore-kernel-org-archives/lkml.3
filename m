Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754071Ab3FRC1A (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 22:27:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:63987 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753803Ab3FRC06 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 22:26:58 -0400
Date: Mon, 17 Jun 2013 22:26:46 -0400
Message-Id: <201306180226.r5I2Qk6u010828@gelk.kernelslacker.org>
From: Dave Jones <davej@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: linville@tuxdriver.com, gregkh@linuxfoundation.org
Cc: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 4/7] staging/rtl8187se: Convert __list_for_each use to list_for_each
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Also remove commented out list manipulation

Signed-off-by: Dave Jones <davej@redhat.com>
---
 drivers/staging/rtl8187se/ieee80211/ieee80211_rx.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/rtl8187se/ieee80211/ieee80211_rx.c b/drivers/staging/rtl8187se/ieee80211/ieee80211_rx.c
index e303159..d5df0d6 100644
--- a/drivers/staging/rtl8187se/ieee80211/ieee80211_rx.c
+++ b/drivers/staging/rtl8187se/ieee80211/ieee80211_rx.c
@@ -399,8 +399,8 @@ static int is_duplicate_packet(struct ieee80211_device *ieee,
 		struct ieee_ibss_seq *entry = NULL;
 		u8 *mac = header->addr2;
 		int index = mac[5] % IEEE_IBSS_MAC_HASH_SIZE;
-		//for (pos = (head)->next; pos != (head); pos = pos->next)
-		__list_for_each(p, &ieee->ibss_mac_hash[index]) {
+
+		list_for_each(p, &ieee->ibss_mac_hash[index]) {
 			entry = list_entry(p, struct ieee_ibss_seq, list);
 			if (!memcmp(entry->mac, mac, ETH_ALEN))
 				break;
-- 
1.8.1.4

