Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755181Ab3ITUcn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Sep 2013 16:32:43 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:41382 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753452Ab3ITUKC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Sep 2013 16:10:02 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Felix Fietkau <nbd@openwrt.org>,
        "John W. Linville" <linville@tuxdriver.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 07/93] ath9k: always clear ps filter bit on new assoc
Date: Fri, 20 Sep 2013 13:08:02 -0700
Message-Id: <1379707768-1804-8-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1379707768-1804-1-git-send-email-kamal@canonical.com>
References: <1379707768-1804-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.10 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Felix Fietkau <nbd@openwrt.org>

commit 026d5b07c03458f9c0ccd19c3850564a5409c325 upstream.

Otherwise in some cases, EAPOL frames might be filtered during the
initial handshake, causing delays and assoc failures.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/net/wireless/ath/ath9k/xmit.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index 90e48a0..e28f453 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -2467,6 +2467,7 @@ void ath_tx_node_init(struct ath_softc *sc, struct ath_node *an)
 	for (acno = 0, ac = &an->ac[acno];
 	     acno < IEEE80211_NUM_ACS; acno++, ac++) {
 		ac->sched    = false;
+		ac->clear_ps_filter = true;
 		ac->txq = sc->tx.txq_map[acno];
 		INIT_LIST_HEAD(&ac->tid_q);
 	}
-- 
1.8.1.2

