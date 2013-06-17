Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754155Ab3FQRe3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 13:34:29 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:50553 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754109Ab3FQReZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 13:34:25 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Sujith Manoharan <c_manoha@qca.qualcomm.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 68/84] ath9k: Disable PowerSave by default
Date: Mon, 17 Jun 2013 10:31:12 -0700
Message-Id: <1371490288-23167-69-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1371490288-23167-1-git-send-email-kamal@canonical.com>
References: <1371490288-23167-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

commit 531671cb17af07281e6f28c1425f754346e65c41 upstream.

Almost all the DMA issues which have plagued ath9k (in station mode)
for years are related to PS. Disabling PS usually "fixes" the user's
connection stablility. Reports of DMA problems are still trickling in
and are sitting in the kernel bugzilla. Until the PS code in ath9k is
given a thorough review, disbale it by default. The slight increase
in chip power consumption is a small price to pay for improved link
stability.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/net/wireless/ath/ath9k/init.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/init.c b/drivers/net/wireless/ath/ath9k/init.c
index f69ef5d..c4ef015 100644
--- a/drivers/net/wireless/ath/ath9k/init.c
+++ b/drivers/net/wireless/ath/ath9k/init.c
@@ -774,8 +774,7 @@ void ath9k_set_hw_capab(struct ath_softc *sc, struct ieee80211_hw *hw)
 	hw->wiphy->iface_combinations = &if_comb;
 	hw->wiphy->n_iface_combinations = 1;
 
-	if (AR_SREV_5416(sc->sc_ah))
-		hw->wiphy->flags &= ~WIPHY_FLAG_PS_ON_BY_DEFAULT;
+	hw->wiphy->flags &= ~WIPHY_FLAG_PS_ON_BY_DEFAULT;
 
 	hw->wiphy->flags |= WIPHY_FLAG_IBSS_RSN;
 	hw->wiphy->flags |= WIPHY_FLAG_SUPPORTS_TDLS;
-- 
1.8.1.2

