Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755458Ab3IYAMd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 20:12:33 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:38606 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755432Ab3IYAM3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 20:12:29 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Felix Fietkau <nbd@openwrt.org>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [ 19/40] ath9k: always clear ps filter bit on new assoc
Date: Tue, 24 Sep 2013 17:11:51 -0700
Message-Id: <20130925001044.052415131@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20130925001041.939335518@linuxfoundation.org>
References: <20130925001041.939335518@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Felix Fietkau <nbd@openwrt.org>

commit 026d5b07c03458f9c0ccd19c3850564a5409c325 upstream.

Otherwise in some cases, EAPOL frames might be filtered during the
initial handshake, causing delays and assoc failures.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/ath/ath9k/xmit.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -2479,6 +2479,7 @@ void ath_tx_node_init(struct ath_softc *
 	for (acno = 0, ac = &an->ac[acno];
 	     acno < WME_NUM_AC; acno++, ac++) {
 		ac->sched    = false;
+		ac->clear_ps_filter = true;
 		ac->txq = sc->tx.txq_map[acno];
 		INIT_LIST_HEAD(&ac->tid_q);
 	}


