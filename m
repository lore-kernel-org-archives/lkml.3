Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754793Ab3BCPIB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2013 10:08:01 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:34459 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754294Ab3BCO5b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2013 09:57:31 -0500
Message-Id: <20130203144651.626168423@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 03 Feb 2013 15:48:09 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, Felix Fietkau <nbd@openwrt.org>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [ 085/128] ath9k_hw: fix calibration issues on chainmask that dont include
 chain 0
In-Reply-To: <20130203144644.035172954@decadent.org.uk>
X-SA-Exim-Connect-IP: 151.216.67.5
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Felix Fietkau <nbd@openwrt.org>

commit 4a8f199508d79ff8a7d1e22f47b912baaf225336 upstream.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
[bwh: Backported to 3.2: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/net/wireless/ath/ath9k/ar9003_calib.c |    2 ++
 drivers/net/wireless/ath/ath9k/ar9003_phy.c   |    2 +-
 drivers/net/wireless/ath/ath9k/hw.h           |    1 +
 3 files changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/net/wireless/ath/ath9k/ar9003_calib.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_calib.c
@@ -946,6 +946,8 @@ static bool ar9003_hw_init_cal(struct at
 					  AR_PHY_CL_TAB_1,
 					  AR_PHY_CL_TAB_2 };
 
+	ar9003_hw_set_chain_masks(ah, ah->caps.rx_chainmask, ah->caps.tx_chainmask);
+
 	if (rtt) {
 		if (!ar9003_hw_rtt_restore(ah, chan))
 			run_rtt_cal = true;
--- a/drivers/net/wireless/ath/ath9k/ar9003_phy.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_phy.c
@@ -541,7 +541,7 @@ static void ar9003_hw_init_bb(struct ath
 	udelay(synthDelay + BASE_ACTIVATE_DELAY);
 }
 
-static void ar9003_hw_set_chain_masks(struct ath_hw *ah, u8 rx, u8 tx)
+void ar9003_hw_set_chain_masks(struct ath_hw *ah, u8 rx, u8 tx)
 {
 	switch (rx) {
 	case 0x5:
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -1016,6 +1016,7 @@ int ar9003_paprd_setup_gain_table(struct
 int ar9003_paprd_init_table(struct ath_hw *ah);
 bool ar9003_paprd_is_done(struct ath_hw *ah);
 void ar9003_hw_set_paprd_txdesc(struct ath_hw *ah, void *ds, u8 chains);
+void ar9003_hw_set_chain_masks(struct ath_hw *ah, u8 rx, u8 tx);
 
 /* Hardware family op attach helpers */
 void ar5008_hw_attach_phy_ops(struct ath_hw *ah);


