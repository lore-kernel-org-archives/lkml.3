Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753987Ab3FRC0r (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 22:26:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:8714 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753803Ab3FRC0q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 22:26:46 -0400
Date: Mon, 17 Jun 2013 22:26:35 -0400
Message-Id: <201306180226.r5I2QZS2010802@gelk.kernelslacker.org>
From: Dave Jones <davej@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: linville@tuxdriver.com
Cc: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 2/7] ipw2200: Convert __list_for_each usage to list_for_each
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Dave Jones <davej@redhat.com>
---
 drivers/net/wireless/ipw2x00/ipw2200.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ipw2x00/ipw2200.c b/drivers/net/wireless/ipw2x00/ipw2200.c
index d96257b..4ed5e45 100644
--- a/drivers/net/wireless/ipw2x00/ipw2200.c
+++ b/drivers/net/wireless/ipw2x00/ipw2200.c
@@ -8256,7 +8256,7 @@ static  int is_duplicate_packet(struct ipw_priv *priv,
 			u8 *mac = header->addr2;
 			int index = mac[5] % IPW_IBSS_MAC_HASH_SIZE;
 
-			__list_for_each(p, &priv->ibss_mac_hash[index]) {
+			list_for_each(p, &priv->ibss_mac_hash[index]) {
 				entry =
 				    list_entry(p, struct ipw_ibss_seq, list);
 				if (!memcmp(entry->mac, mac, ETH_ALEN))
-- 
1.8.1.4

