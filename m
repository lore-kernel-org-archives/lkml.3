Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756626Ab3APP5w (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 10:57:52 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:35623 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756203Ab3APP5s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 10:57:48 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Paul Stewart <pstew@chromium.org>,
        Rajkumar Manoharan <rmanohar@qca.qualcomm.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 005/222] ath9k_hw: Enable hw PLL power save for AR9462
Date: Wed, 16 Jan 2013 13:53:25 -0200
Message-Id: <1358351822-7675-6-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1358351822-7675-1-git-send-email-herton.krzesinski@canonical.com>
References: <1358351822-7675-1-git-send-email-herton.krzesinski@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>

commit 1680260226a8fd2aab590319da83ad8e610da9bd upstream.

This reduced the power consumption to half in full and network sleep.

Cc: Paul Stewart <pstew@chromium.org>
Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
[ herton: backport for 3.5, PCIE_PLL_ON_CREQ_DIS_L1_2P0 macro
  corresponds to the ar9462_pciephy_pll_on_clkreq_disable_L1_2p0,
  INIT_INI_ARRAY macro still have rows and columns parameter ]
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_hw.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_hw.c b/drivers/net/wireless/ath/ath9k/ar9003_hw.c
index a0e3394..4f692b9 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_hw.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_hw.c
@@ -307,13 +307,13 @@ static void ar9003_hw_init_mode_regs(struct ath_hw *ah)
 
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
-- 
1.7.9.5

