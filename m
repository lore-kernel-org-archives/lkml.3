Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753721Ab3GXOVr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 10:21:47 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:45715 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751064Ab3GXOGo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 10:06:44 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Sujith Manoharan" <c_manoha@qca.qualcomm.com>,
        "John W. Linville" <linville@tuxdriver.com>
Date: Wed, 24 Jul 2013 15:02:45 +0100
Message-ID: <lsq.1374674565.66822618@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [17/85] ath9k_hw: Assign default xlna config for AR9485
In-Reply-To: <lsq.1374674564.753305150@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.101
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.49-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

commit 30d5b709da23f4ab9836c7f66d2d2e780a69cf12 upstream.

For AR9485 boards with XLNA, the default gpio config
is not set correctly, fix this.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
[bwh: Backported to 3.2: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/net/wireless/ath/ath9k/ar9003_eeprom.c | 8 ++++++--
 drivers/net/wireless/ath/ath9k/ar9003_phy.h    | 2 ++
 2 files changed, 8 insertions(+), 2 deletions(-)

--- a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
@@ -3625,7 +3625,7 @@ static u16 ar9003_hw_ant_ctrl_chain_get(
 static void ar9003_hw_ant_ctrl_apply(struct ath_hw *ah, bool is2ghz)
 {
 	int chain;
-	u32 regval;
+	u32 regval, value;
 	u32 ant_div_ctl1;
 	static const u32 switch_chain_reg[AR9300_MAX_CHAINS] = {
 			AR_PHY_SWITCH_CHAIN_0,
@@ -3633,7 +3633,11 @@ static void ar9003_hw_ant_ctrl_apply(str
 			AR_PHY_SWITCH_CHAIN_2,
 	};
 
-	u32 value = ar9003_hw_ant_ctrl_common_get(ah, is2ghz);
+	if (AR_SREV_9485(ah) && (ar9003_hw_get_rx_gain_idx(ah) == 0))
+		ath9k_hw_cfg_output(ah, AR9300_EXT_LNA_CTL_GPIO_AR9485,
+				    AR_GPIO_OUTPUT_MUX_AS_PCIE_ATTENTION_LED);
+
+	value = ar9003_hw_ant_ctrl_common_get(ah, is2ghz);
 
 	if (AR_SREV_9462(ah)) {
 		if (AR_SREV_9462_10(ah)) {
--- a/drivers/net/wireless/ath/ath9k/ar9003_phy.h
+++ b/drivers/net/wireless/ath/ath9k/ar9003_phy.h
@@ -334,6 +334,8 @@
 
 #define AR_PHY_CCA_NOM_VAL_9330_2GHZ          -118
 
+#define AR9300_EXT_LNA_CTL_GPIO_AR9485 9
+
 /*
  * AGC Field Definitions
  */

