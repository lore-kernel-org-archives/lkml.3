Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754655Ab3CAT6o (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 14:58:44 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:51892 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754005Ab3CATqY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 14:46:24 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Felix Fietkau <nbd@openwrt.org>,
        "John W. Linville" <linville@tuxdriver.com>,
        CAI Qian <caiqian@redhat.com>
Subject: [ 33/46] ath9k_hw: fix calibration issues on chainmask that dont include chain 0
Date: Fri,  1 Mar 2013 11:45:21 -0800
Message-Id: <20130301194435.757582177@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130301194432.263409302@linuxfoundation.org>
References: <20130301194432.263409302@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Felix Fietkau <nbd@openwrt.org>

commit 4a8f199508d79ff8a7d1e22f47b912baaf225336 upstream.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: CAI Qian <caiqian@redhat.com>
Reviewed-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/ath/ath9k/ar9003_calib.c |    2 ++
 drivers/net/wireless/ath/ath9k/ar9003_phy.c   |    2 +-
 drivers/net/wireless/ath/ath9k/hw.h           |    1 +
 3 files changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/net/wireless/ath/ath9k/ar9003_calib.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_calib.c
@@ -938,6 +938,8 @@ static bool ar9003_hw_init_cal(struct at
 					  AR_PHY_CL_TAB_1,
 					  AR_PHY_CL_TAB_2 };
 
+	ar9003_hw_set_chain_masks(ah, ah->caps.rx_chainmask, ah->caps.tx_chainmask);
+
 	if (rtt) {
 		if (!ar9003_hw_rtt_restore(ah, chan))
 			run_rtt_cal = true;
--- a/drivers/net/wireless/ath/ath9k/ar9003_phy.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_phy.c
@@ -543,7 +543,7 @@ static void ar9003_hw_init_bb(struct ath
 	udelay(synthDelay + BASE_ACTIVATE_DELAY);
 }
 
-static void ar9003_hw_set_chain_masks(struct ath_hw *ah, u8 rx, u8 tx)
+void ar9003_hw_set_chain_masks(struct ath_hw *ah, u8 rx, u8 tx)
 {
 	switch (rx) {
 	case 0x5:
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -1014,6 +1014,7 @@ int ar9003_paprd_setup_gain_table(struct
 int ar9003_paprd_init_table(struct ath_hw *ah);
 bool ar9003_paprd_is_done(struct ath_hw *ah);
 void ar9003_hw_set_paprd_txdesc(struct ath_hw *ah, void *ds, u8 chains);
+void ar9003_hw_set_chain_masks(struct ath_hw *ah, u8 rx, u8 tx);
 
 /* Hardware family op attach helpers */
 void ar5008_hw_attach_phy_ops(struct ath_hw *ah);


