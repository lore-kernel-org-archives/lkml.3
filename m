Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932314AbaBUMuf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 07:50:35 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:47006 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932269AbaBUMu2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 07:50:28 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Oleksij Rempel <linux@rempel-privat.de>,
        "John W. Linville" <linville@tuxdriver.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 057/121] ath9k_htc: Do not support PowerSave by default
Date: Fri, 21 Feb 2014 12:48:01 +0000
Message-Id: <1392986945-9693-58-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1392986945-9693-1-git-send-email-luis.henriques@canonical.com>
References: <1392986945-9693-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.5 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Oleksij Rempel <linux@rempel-privat.de>

commit 6bca610d97b6139a1d7598b8009da9d339daa50f upstream.

It is a copy/paste of patch provided by Sujith for ath9k.

"Even though we make sure PowerSave is not enabled by default
by disabling the flag, WIPHY_FLAG_PS_ON_BY_DEFAULT on init,
PS could be enabled by userspace based on various factors
like battery usage etc. Since PS in ath9k is just broken
and has been untested for years, remove support for it, but
allow a user to explicitly enable it using a module parameter."

Signed-off-by: Oleksij Rempel <linux@rempel-privat.de>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/net/wireless/ath/ath9k/htc_drv_init.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_init.c b/drivers/net/wireless/ath/ath9k/htc_drv_init.c
index c3676bf..50f991c 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_init.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_init.c
@@ -34,6 +34,10 @@ static int ath9k_htc_btcoex_enable;
 module_param_named(btcoex_enable, ath9k_htc_btcoex_enable, int, 0444);
 MODULE_PARM_DESC(btcoex_enable, "Enable wifi-BT coexistence");
 
+static int ath9k_ps_enable;
+module_param_named(ps_enable, ath9k_ps_enable, int, 0444);
+MODULE_PARM_DESC(ps_enable, "Enable WLAN PowerSave");
+
 #define CHAN2G(_freq, _idx)  { \
 	.center_freq = (_freq), \
 	.hw_value = (_idx), \
@@ -725,12 +729,14 @@ static void ath9k_set_hw_capab(struct ath9k_htc_priv *priv,
 		IEEE80211_HW_SPECTRUM_MGMT |
 		IEEE80211_HW_HAS_RATE_CONTROL |
 		IEEE80211_HW_RX_INCLUDES_FCS |
-		IEEE80211_HW_SUPPORTS_PS |
 		IEEE80211_HW_PS_NULLFUNC_STACK |
 		IEEE80211_HW_REPORTS_TX_ACK_STATUS |
 		IEEE80211_HW_MFP_CAPABLE |
 		IEEE80211_HW_HOST_BROADCAST_PS_BUFFERING;
 
+	if (ath9k_ps_enable)
+		hw->flags |= IEEE80211_HW_SUPPORTS_PS;
+
 	hw->wiphy->interface_modes =
 		BIT(NL80211_IFTYPE_STATION) |
 		BIT(NL80211_IFTYPE_ADHOC) |
-- 
1.9.0

