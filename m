Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933377AbaEKTX5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2014 15:23:57 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:48246 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933323AbaEKTXy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2014 15:23:54 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Felix Fietkau <nbd@openwrt.org>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 3.14 47/83] ath9k: fix ready time of the multicast buffer queue
Date: Sun, 11 May 2014 21:19:48 +0200
Message-Id: <20140511191913.309947557@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140511191907.024339448@linuxfoundation.org>
References: <20140511191907.024339448@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Felix Fietkau <nbd@openwrt.org>

commit 3b3e0efb5c72c4fc940af50b33626b8a78a907dc upstream.

qi->tqi_readyTime is written directly to registers that expect
microseconds as unit instead of TU.
When setting the CABQ ready time, cur_conf->beacon_interval is in TU, so
convert it to microseconds before passing it to ath9k_hw.

This should hopefully fix some Tx DMA issues with buffered multicast
frames in AP mode.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/ath/ath9k/xmit.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -1698,7 +1698,7 @@ int ath_cabq_update(struct ath_softc *sc
 
 	ath9k_hw_get_txq_props(sc->sc_ah, qnum, &qi);
 
-	qi.tqi_readyTime = (cur_conf->beacon_interval *
+	qi.tqi_readyTime = (TU_TO_USEC(cur_conf->beacon_interval) *
 			    ATH_CABQ_READY_TIME) / 100;
 	ath_txq_update(sc, qnum, &qi);
 


