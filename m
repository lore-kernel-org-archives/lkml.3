Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753251AbaBJTmF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 14:42:05 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:34581 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752729AbaBJTlj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 14:41:39 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
        "John W. Linville" <linville@tuxdriver.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 008/124] rtlwifi: rtl8192cu: Fix some code in RF handling
Date: Mon, 10 Feb 2014 11:39:08 -0800
Message-Id: <1392061264-28124-9-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1392061264-28124-1-git-send-email-kamal@canonical.com>
References: <1392061264-28124-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.18 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Larry Finger <Larry.Finger@lwfinger.net>

commit e9b0784bb9de3152e787ee779868c626b137fb3b upstream.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/net/wireless/rtlwifi/rtl8192cu/rf.c | 29 ++++++++++++++++-------------
 1 file changed, 16 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/rtlwifi/rtl8192cu/rf.c b/drivers/net/wireless/rtlwifi/rtl8192cu/rf.c
index 2119313..b878d56 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192cu/rf.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192cu/rf.c
@@ -85,17 +85,15 @@ void rtl92cu_phy_rf6052_set_cck_txpower(struct ieee80211_hw *hw,
 	if (mac->act_scanning) {
 		tx_agc[RF90_PATH_A] = 0x3f3f3f3f;
 		tx_agc[RF90_PATH_B] = 0x3f3f3f3f;
-		if (turbo_scanoff) {
-			for (idx1 = RF90_PATH_A; idx1 <= RF90_PATH_B; idx1++) {
-				tx_agc[idx1] = ppowerlevel[idx1] |
-				    (ppowerlevel[idx1] << 8) |
-				    (ppowerlevel[idx1] << 16) |
-				    (ppowerlevel[idx1] << 24);
-				if (rtlhal->interface == INTF_USB) {
-					if (tx_agc[idx1] > 0x20 &&
-					    rtlefuse->external_pa)
-						tx_agc[idx1] = 0x20;
-				}
+		for (idx1 = RF90_PATH_A; idx1 <= RF90_PATH_B; idx1++) {
+			tx_agc[idx1] = ppowerlevel[idx1] |
+			    (ppowerlevel[idx1] << 8) |
+			    (ppowerlevel[idx1] << 16) |
+			    (ppowerlevel[idx1] << 24);
+			if (rtlhal->interface == INTF_USB) {
+				if (tx_agc[idx1] > 0x20 &&
+				    rtlefuse->external_pa)
+					tx_agc[idx1] = 0x20;
 			}
 		}
 	} else {
@@ -107,7 +105,7 @@ void rtl92cu_phy_rf6052_set_cck_txpower(struct ieee80211_hw *hw,
 			   TXHIGHPWRLEVEL_LEVEL2) {
 			tx_agc[RF90_PATH_A] = 0x00000000;
 			tx_agc[RF90_PATH_B] = 0x00000000;
-		} else{
+		} else {
 			for (idx1 = RF90_PATH_A; idx1 <= RF90_PATH_B; idx1++) {
 				tx_agc[idx1] = ppowerlevel[idx1] |
 				    (ppowerlevel[idx1] << 8) |
@@ -373,7 +371,12 @@ static void _rtl92c_write_ofdm_power_reg(struct ieee80211_hw *hw,
 			    regoffset == RTXAGC_B_MCS07_MCS04)
 				regoffset = 0xc98;
 			for (i = 0; i < 3; i++) {
-				writeVal = (writeVal > 6) ? (writeVal - 6) : 0;
+				if (i != 2)
+					writeVal = (writeVal > 8) ?
+						   (writeVal - 8) : 0;
+				else
+					writeVal = (writeVal > 6) ?
+						   (writeVal - 6) : 0;
 				rtl_write_byte(rtlpriv, (u32)(regoffset + i),
 					      (u8)writeVal);
 			}
-- 
1.8.3.2

