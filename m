Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754780Ab3JZUqa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Oct 2013 16:46:30 -0400
Received: from mail-ee0-f53.google.com ([74.125.83.53]:53108 "EHLO
	mail-ee0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753382Ab3JZUkZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Oct 2013 16:40:25 -0400
From: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali.rohar@gmail.com>
To: Luciano Coelho <luca@coelho.fi>,
        "John W. Linville" <linville@tuxdriver.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        "David S. Miller" <davem@davemloft.net>
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, freemangordon@abv.bg,
        aaro.koskinen@iki.fi, pavel@ucw.cz, sre@ring0.de,
        joni.lapilainen@gmail.com, pali.rohar@gmail.com,
        David Gnedt <david.gnedt@davizone.at>
Subject: [PATCH 01/16] mac80211: fix TX device statistics for monitor interfaces
Date: Sat, 26 Oct 2013 22:34:00 +0200
Message-Id: <1382819655-30430-2-git-send-email-pali.rohar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1382819655-30430-1-git-send-email-pali.rohar@gmail.com>
References: <1382819655-30430-1-git-send-email-pali.rohar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Gnedt <david.gnedt@davizone.at>

Count TX packets and bytes also for monitor interfaces.

Signed-of-by: David Gnedt <david.gnedt@davizone.at>
---
 net/mac80211/tx.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 3456c04..674db8e 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -1593,6 +1593,9 @@ netdev_tx_t ieee80211_monitor_start_xmit(struct sk_buff *skb,
 	if (unlikely(skb->len < len_rthdr))
 		goto fail; /* skb too short for claimed rt header extent */
 
+	dev->stats.tx_packets++;
+	dev->stats.tx_bytes += skb->len;
+
 	/*
 	 * fix up the pointers accounting for the radiotap
 	 * header still being in there.  We are being given
-- 
1.7.10.4

