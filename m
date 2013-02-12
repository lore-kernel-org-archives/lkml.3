Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759644Ab3BLVIm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 16:08:42 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:53448 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752677Ab3BLUfq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 15:35:46 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Felix Fietkau <nbd@openwrt.org>,
        "John W. Linville" <linville@tuxdriver.com>,
        CAI Qian <caiqian@redhat.com>
Subject: [ 14/61] ath9k_hw: fix calibration issues on chainmask that dont include chain 0
Date: Tue, 12 Feb 2013 12:34:34 -0800
Message-Id: <20130212203420.142379376@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130212203417.890993903@linuxfoundation.org>
References: <20130212203417.890993903@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Felix Fietkau <nbd@openwrt.org>

commit 4a8f199508d79ff8a7d1e22f47b912baaf225336 upstream.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: CAI Qian <caiqian@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/ath/ath9k/ar9003_calib.c |    2 ++
 drivers/net/wireless/ath/ath9k/ar9003_phy.c   |    2 +-
 drivers/net/wireless/ath/ath9k/hw.h           |    1 +
 3 files changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/net/wireless/ath/ath9k/ar9003_calib.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_calib.c
@@ -903,6 +903,8 @@ static bool ar9003_hw_init_cal(struct at
 					  AR_PHY_CL_TAB_1,
 					  AR_PHY_CL_TAB_2 };
 
+	ar9003_hw_set_chain_masks(ah, ah->caps.rx_chainmask, ah->caps.tx_chainmask);
+
 	if (rtt) {
 		if (!ar9003_hw_rtt_restore(ah, chan))
 			run_rtt_cal = true;
--- a/drivers/net/wireless/ath/ath9k/ar9003_phy.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_phy.c
@@ -586,7 +586,7 @@ static void ar9003_hw_init_bb(struct ath
 	ath9k_hw_synth_delay(ah, chan, synthDelay);
 }
 
-static void ar9003_hw_set_chain_masks(struct ath_hw *ah, u8 rx, u8 tx)
+void ar9003_hw_set_chain_masks(struct ath_hw *ah, u8 rx, u8 tx)
 {
 	if (ah->caps.tx_chainmask == 5 || ah->caps.rx_chainmask == 5)
 		REG_SET_BIT(ah, AR_PHY_ANALOG_SWAP,
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -1063,6 +1063,7 @@ int ar9003_paprd_create_curve(struct ath
 int ar9003_paprd_setup_gain_table(struct ath_hw *ah, int chain);
 int ar9003_paprd_init_table(struct ath_hw *ah);
 bool ar9003_paprd_is_done(struct ath_hw *ah);
+void ar9003_hw_set_chain_masks(struct ath_hw *ah, u8 rx, u8 tx);
 
 /* Hardware family op attach helpers */
 void ar5008_hw_attach_phy_ops(struct ath_hw *ah);


