Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934723Ab3GWW1j (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 18:27:39 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:41719 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934684Ab3GWW1f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 18:27:35 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Sujith Manoharan <c_manoha@qca.qualcomm.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [ 057/103] ath9k_hw: Assign default xlna config for AR9485
Date: Tue, 23 Jul 2013 15:26:08 -0700
Message-Id: <20130723220424.948279874@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130723220418.532514378@linuxfoundation.org>
References: <20130723220418.532514378@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

commit 30d5b709da23f4ab9836c7f66d2d2e780a69cf12 upstream.

For AR9485 boards with XLNA, the default gpio config
is not set correctly, fix this.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/ath/ath9k/ar9003_eeprom.c |    8 ++++++--
 drivers/net/wireless/ath/ath9k/ar9003_phy.h    |    2 ++
 2 files changed, 8 insertions(+), 2 deletions(-)

--- a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
@@ -3563,14 +3563,18 @@ static void ar9003_hw_ant_ctrl_apply(str
 {
 	struct ath9k_hw_capabilities *pCap = &ah->caps;
 	int chain;
-	u32 regval;
+	u32 regval, value;
 	static const u32 switch_chain_reg[AR9300_MAX_CHAINS] = {
 			AR_PHY_SWITCH_CHAIN_0,
 			AR_PHY_SWITCH_CHAIN_1,
 			AR_PHY_SWITCH_CHAIN_2,
 	};
 
-	u32 value = ar9003_hw_ant_ctrl_common_get(ah, is2ghz);
+	if (AR_SREV_9485(ah) && (ar9003_hw_get_rx_gain_idx(ah) == 0))
+		ath9k_hw_cfg_output(ah, AR9300_EXT_LNA_CTL_GPIO_AR9485,
+				    AR_GPIO_OUTPUT_MUX_AS_PCIE_ATTENTION_LED);
+
+	value = ar9003_hw_ant_ctrl_common_get(ah, is2ghz);
 
 	if (AR_SREV_9462(ah) || AR_SREV_9565(ah)) {
 		REG_RMW_FIELD(ah, AR_PHY_SWITCH_COM,
--- a/drivers/net/wireless/ath/ath9k/ar9003_phy.h
+++ b/drivers/net/wireless/ath/ath9k/ar9003_phy.h
@@ -351,6 +351,8 @@
 
 #define AR_PHY_CCA_NOM_VAL_9330_2GHZ          -118
 
+#define AR9300_EXT_LNA_CTL_GPIO_AR9485 9
+
 /*
  * AGC Field Definitions
  */


