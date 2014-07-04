Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760388AbaGDXkn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 19:40:43 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:43802 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753715AbaGDXkm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2014 19:40:42 -0400
From: Andrey Utkin <andrey.krieger.utkin@gmail.com>
To: kernel-janitors@vger.kernel.org, Larry.Finger@lwfinger.net,
        linux-kernel@vger.kernel.org, drivers_staging@kernel-bugs.osdl.org
Cc: Andrey Utkin <andrey.krieger.utkin@gmail.com>
Subject: [PATCH] staging: rtl8192ee: Correct bitmask in comparsion
Date: Sat,  5 Jul 2014 02:40:13 +0300
Message-Id: <1404517213-4067-1-git-send-email-andrey.krieger.utkin@gmail.com>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

See https://bugzilla.kernel.org/show_bug.cgi?id=78041
---8<---
Reported-by: David Binderman <dcb314@hotmail.com>
Signed-off-by: Andrey Utkin <andrey.krieger.utkin@gmail.com>
---
 drivers/staging/rtl8192ee/base.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/rtl8192ee/base.c b/drivers/staging/rtl8192ee/base.c
index a7c69f7..71ed12e 100644
--- a/drivers/staging/rtl8192ee/base.c
+++ b/drivers/staging/rtl8192ee/base.c
@@ -827,7 +827,7 @@ static u8 _rtl_get_vht_highest_n_rate(struct ieee80211_hw *hw,
 	u16 map = le16_to_cpu(sta->vht_cap.vht_mcs.tx_mcs_map);
 
 	if ((get_rf_type(rtlphy) == RF_2T2R) &&
-	    (map & 0x000c) != 0x000c0) {
+	    (map & 0x000c) != 0x000c) {
 		if ((map & 0x000c) >> 2 == IEEE80211_VHT_MCS_SUPPORT_0_7)
 			hw_rate =
 			rtlpriv->cfg->maps[RTL_RC_VHT_RATE_2SS_MCS7];
-- 
1.8.3.2

