Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755595Ab3I3KMy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 06:12:54 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:43616 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755523Ab3I3KMo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 06:12:44 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Felix Fietkau <nbd@openwrt.org>,
        "John W. Linville" <linville@tuxdriver.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 055/104] ath9k: always clear ps filter bit on new assoc
Date: Mon, 30 Sep 2013 11:10:32 +0100
Message-Id: <1380535881-9239-56-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1380535881-9239-1-git-send-email-luis.henriques@canonical.com>
References: <1380535881-9239-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.22 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Felix Fietkau <nbd@openwrt.org>

commit 026d5b07c03458f9c0ccd19c3850564a5409c325 upstream.

Otherwise in some cases, EAPOL frames might be filtered during the
initial handshake, causing delays and assoc failures.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
[ luis: backported to 3.5: adjusted context ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/net/wireless/ath/ath9k/xmit.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index 894ed0e..63ce4cf 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -2479,6 +2479,7 @@ void ath_tx_node_init(struct ath_softc *sc, struct ath_node *an)
 	for (acno = 0, ac = &an->ac[acno];
 	     acno < WME_NUM_AC; acno++, ac++) {
 		ac->sched    = false;
+		ac->clear_ps_filter = true;
 		ac->txq = sc->tx.txq_map[acno];
 		INIT_LIST_HEAD(&ac->tid_q);
 	}
-- 
1.8.3.2

