Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932387AbaBUMuq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 07:50:46 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:47019 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932144AbaBUMub (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 07:50:31 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Sujith Manoharan <c_manoha@qca.qualcomm.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 059/121] ath9k: Do not support PowerSave by default
Date: Fri, 21 Feb 2014 12:48:03 +0000
Message-Id: <1392986945-9693-60-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1392986945-9693-1-git-send-email-luis.henriques@canonical.com>
References: <1392986945-9693-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.5 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

commit 8298383c2cd5a6d0639f1bb1781fba181bd20154 upstream.

Even though we make sure PowerSave is not enabled by default
by disabling the flag, WIPHY_FLAG_PS_ON_BY_DEFAULT on init,
PS could be enabled by userspace based on various factors
like battery usage etc. Since PS in ath9k is just broken
and has been untested for years, remove support for it, but
allow a user to explicitly enable it using a module parameter.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/net/wireless/ath/ath9k/init.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath9k/init.c b/drivers/net/wireless/ath/ath9k/init.c
index 026a2a0..70916d2 100644
--- a/drivers/net/wireless/ath/ath9k/init.c
+++ b/drivers/net/wireless/ath/ath9k/init.c
@@ -57,6 +57,10 @@ static int ath9k_enable_diversity;
 module_param_named(enable_diversity, ath9k_enable_diversity, int, 0444);
 MODULE_PARM_DESC(enable_diversity, "Enable Antenna diversity for AR9565");
 
+static int ath9k_ps_enable;
+module_param_named(ps_enable, ath9k_ps_enable, int, 0444);
+MODULE_PARM_DESC(ps_enable, "Enable WLAN PowerSave");
+
 bool is_ath9k_unloaded;
 /* We use the hw_value as an index into our private channel structure */
 
@@ -798,13 +802,15 @@ void ath9k_set_hw_capab(struct ath_softc *sc, struct ieee80211_hw *hw)
 	hw->flags = IEEE80211_HW_RX_INCLUDES_FCS |
 		IEEE80211_HW_HOST_BROADCAST_PS_BUFFERING |
 		IEEE80211_HW_SIGNAL_DBM |
-		IEEE80211_HW_SUPPORTS_PS |
 		IEEE80211_HW_PS_NULLFUNC_STACK |
 		IEEE80211_HW_SPECTRUM_MGMT |
 		IEEE80211_HW_REPORTS_TX_ACK_STATUS |
 		IEEE80211_HW_SUPPORTS_RC_TABLE |
 		IEEE80211_HW_SUPPORTS_HT_CCK_RATES;
 
+	if (ath9k_ps_enable)
+		hw->flags |= IEEE80211_HW_SUPPORTS_PS;
+
 	if (sc->sc_ah->caps.hw_caps & ATH9K_HW_CAP_HT) {
 		hw->flags |= IEEE80211_HW_AMPDU_AGGREGATION;
 
-- 
1.9.0

