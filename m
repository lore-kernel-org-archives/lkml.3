Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933127Ab3GKOcI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 10:32:08 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:43245 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933071Ab3GKO1C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 10:27:02 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
        "John W. Linville" <linville@tuxdriver.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 82/98] rtlwifi: rtl8192cu: Fix duplicate if test
Date: Thu, 11 Jul 2013 15:24:52 +0100
Message-Id: <1373552708-15235-83-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1373552708-15235-1-git-send-email-luis.henriques@canonical.com>
References: <1373552708-15235-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.17 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Larry Finger <Larry.Finger@lwfinger.net>

commit 10d0b9030a3f86e1e26c710c7580524d7787d688 upstream.

A typo causes routine rtl92cu_phy_rf6052_set_cck_txpower() to test the
same condition twice. The problem was found using cppcheck-1.49, and the
proper fix was verified against the pre-mac80211 version of the code.

This patch was originally included as commit 1288aa4, but was accidentally
reverted in a later patch.

Reported-by: David Binderman <dcb314@hotmail.com> [original report]
Reported-by: Andrea Morello <andrea.merello@gmail.com> [report of accidental reversion]
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/net/wireless/rtlwifi/rtl8192cu/rf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/rtlwifi/rtl8192cu/rf.c b/drivers/net/wireless/rtlwifi/rtl8192cu/rf.c
index 506b9a0..4763426 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192cu/rf.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192cu/rf.c
@@ -104,7 +104,7 @@ void rtl92cu_phy_rf6052_set_cck_txpower(struct ieee80211_hw *hw,
 			tx_agc[RF90_PATH_A] = 0x10101010;
 			tx_agc[RF90_PATH_B] = 0x10101010;
 		} else if (rtlpriv->dm.dynamic_txhighpower_lvl ==
-			   TXHIGHPWRLEVEL_LEVEL1) {
+			   TXHIGHPWRLEVEL_LEVEL2) {
 			tx_agc[RF90_PATH_A] = 0x00000000;
 			tx_agc[RF90_PATH_B] = 0x00000000;
 		} else{
-- 
1.8.1.2

