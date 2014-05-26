Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752098AbaEZUTx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 16:19:53 -0400
Received: from cpsmtpb-ews07.kpnxchange.com ([213.75.39.10]:56318 "EHLO
	cpsmtpb-ews07.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752052AbaEZUTw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 16:19:52 -0400
Message-ID: <1401135591.6068.38.camel@x220>
Subject: [PATCH] staging: rtl8192u: rename CONFIG_IEEE80211_CRYPT_TKIP
From: Paul Bolle <pebolle@tiscali.nl>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Date: Mon, 26 May 2014 22:19:51 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 26 May 2014 20:19:51.0004 (UTC) FILETIME=[D91569C0:01CF791F]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Kconfig symbol IEEE80211_CRYPT_TKIP was renamed to
LIB80211_CRYPT_TKIP in commit 274bfb8dc5ff ("lib80211: absorb crypto
bits from net/ieee80211"). So when rtl8192u was added as a staging
driver in v2.6.33 its checks for CONFIG_IEEE80211_CRYPT_TKIP were
already outdated. Use CONFIG_LIB80211_CRYPT_TKIP instead, as was clearly
intended.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
Compile tested only. Done on top of next-20140526.

 drivers/staging/rtl8192u/ieee80211/ieee80211_rx.c | 2 +-
 drivers/staging/rtl8192u/ieee80211/ieee80211_tx.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/rtl8192u/ieee80211/ieee80211_rx.c b/drivers/staging/rtl8192u/ieee80211/ieee80211_rx.c
index 0cd6a001bcc5..dc89b43d9fea 100644
--- a/drivers/staging/rtl8192u/ieee80211/ieee80211_rx.c
+++ b/drivers/staging/rtl8192u/ieee80211/ieee80211_rx.c
@@ -352,7 +352,7 @@ ieee80211_rx_frame_decrypt(struct ieee80211_device *ieee, struct sk_buff *skb,
 	hdr = (struct ieee80211_hdr_4addr *) skb->data;
 	hdrlen = ieee80211_get_hdrlen(le16_to_cpu(hdr->frame_ctl));
 
-#ifdef CONFIG_IEEE80211_CRYPT_TKIP
+#ifdef CONFIG_LIB80211_CRYPT_TKIP
 	if (ieee->tkip_countermeasures &&
 	    strcmp(crypt->ops->name, "TKIP") == 0) {
 		if (net_ratelimit()) {
diff --git a/drivers/staging/rtl8192u/ieee80211/ieee80211_tx.c b/drivers/staging/rtl8192u/ieee80211/ieee80211_tx.c
index 029a97651797..0bb474a193e6 100644
--- a/drivers/staging/rtl8192u/ieee80211/ieee80211_tx.c
+++ b/drivers/staging/rtl8192u/ieee80211/ieee80211_tx.c
@@ -191,7 +191,7 @@ int ieee80211_encrypt_fragment(
 		printk("=========>%s(), crypt is null\n", __func__);
 		return -1;
 	}
-#ifdef CONFIG_IEEE80211_CRYPT_TKIP
+#ifdef CONFIG_LIB80211_CRYPT_TKIP
 	struct ieee80211_hdr *header;
 
 	if (ieee->tkip_countermeasures &&
-- 
1.9.0

