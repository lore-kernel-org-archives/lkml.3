Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758510AbaDJDXs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 23:23:48 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:41034 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758434AbaDJDWE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 23:22:04 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Paul Stewart <pstew@chromium.org>,
        Rajkumar Manoharan <rmanohar@qca.qualcomm.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        Ben Hutchings <ben@decadent.org.uk>, Jianguo Wu <wujianguo@huawei.com>
Subject: [PATCH 3.4 045/134] ath9k_hw: Enable hw PLL power save for AR9462
Date: Wed,  9 Apr 2014 20:22:41 -0700
Message-Id: <20140410032305.854366586@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140410032259.587501440@linuxfoundation.org>
References: <20140410032259.587501440@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>

commit 1680260226a8fd2aab590319da83ad8e610da9bd upstream.

This reduced the power consumption to half in full and network sleep.

Cc: Paul Stewart <pstew@chromium.org>
Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
[bwh: Backported to 3.2:
 - INIT_INI_ARRAY macro requires an explicit size argument
 - Remove the now-redundant macro PCIE_PLL_ON_CREQ_DIS_L1_2P0]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Cc: Jianguo Wu <wujianguo@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/ath/ath9k/ar9003_hw.c |   11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

--- a/drivers/net/wireless/ath/ath9k/ar9003_hw.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_hw.c
@@ -33,9 +33,6 @@
  */
 static void ar9003_hw_init_mode_regs(struct ath_hw *ah)
 {
-#define PCIE_PLL_ON_CREQ_DIS_L1_2P0 \
-		ar9462_pciephy_pll_on_clkreq_disable_L1_2p0
-
 #define AR9462_BB_CTX_COEFJ(x)	\
 		ar9462_##x##_baseband_core_txfir_coeff_japan_2484
 
@@ -312,13 +309,13 @@ static void ar9003_hw_init_mode_regs(str
 
 		/* Awake -> Sleep Setting */
 		INIT_INI_ARRAY(&ah->iniPcieSerdes,
-				PCIE_PLL_ON_CREQ_DIS_L1_2P0,
-				ARRAY_SIZE(PCIE_PLL_ON_CREQ_DIS_L1_2P0),
+				ar9462_pciephy_clkreq_disable_L1_2p0,
+				ARRAY_SIZE(ar9462_pciephy_clkreq_disable_L1_2p0),
 				2);
 		/* Sleep -> Awake Setting */
 		INIT_INI_ARRAY(&ah->iniPcieSerdesLowPower,
-				PCIE_PLL_ON_CREQ_DIS_L1_2P0,
-				ARRAY_SIZE(PCIE_PLL_ON_CREQ_DIS_L1_2P0),
+				ar9462_pciephy_clkreq_disable_L1_2p0,
+				ARRAY_SIZE(ar9462_pciephy_clkreq_disable_L1_2p0),
 				2);
 
 		/* Fast clock modal settings */


