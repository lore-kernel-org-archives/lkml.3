Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753726Ab3LHIqg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Dec 2013 03:46:36 -0500
Received: from mail-ea0-f169.google.com ([209.85.215.169]:62511 "EHLO
	mail-ea0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751578Ab3LHIqe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Dec 2013 03:46:34 -0500
From: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali.rohar@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        "David S. Miller" <davem@davemloft.net>
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, David Gnedt <david.gnedt@davizone.at>
Subject: [PATCH] mac80211: fix TX device statistics for monitor interfaces
Date: Sun,  8 Dec 2013 09:45:57 +0100
Message-Id: <1386492357-20826-1-git-send-email-pali.rohar@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <87iowiszyu.fsf@purkki.adurom.net>
References: <87iowiszyu.fsf@purkki.adurom.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Gnedt <david.gnedt@davizone.at>

Count TX packets and bytes also for monitor interfaces.

Signed-off-by: David Gnedt <david.gnedt@davizone.at>
---
 net/mac80211/tx.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index c558b24..37b38fb 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -1623,6 +1623,9 @@ netdev_tx_t ieee80211_monitor_start_xmit(struct sk_buff *skb,
 	if (unlikely(skb->len < len_rthdr))
 		goto fail; /* skb too short for claimed rt header extent */
 
+	dev->stats.tx_packets++;
+	dev->stats.tx_bytes += skb->len;
+
 	/*
 	 * fix up the pointers accounting for the radiotap
 	 * header still being in there.  We are being given
-- 
1.7.9.5

