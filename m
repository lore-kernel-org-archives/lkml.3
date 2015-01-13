Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752057AbbAMOIo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 09:08:44 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:35309 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751133AbbAMOIm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 09:08:42 -0500
From: Colin King <colin.king@canonical.com>
To: Larry Finger <Larry.Finger@lwfinger.net>,
        Chaoming Li <chaoming_li@realsil.com.cn>,
        Kalle Valo <kvalo@codeaurora.org>,
        "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] rtlwifi/rtl8192de: remove redundant else if check
Date: Tue, 13 Jan 2015 14:07:34 +0000
Message-Id: <1421158054-22566-1-git-send-email-colin.king@canonical.com>
X-Mailer: git-send-email 2.1.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

The else if check condition checks for the opposite of the
if check, hence the else if check is redundant and can be
replaced with a simple else:

if (rtlpriv->rtlhal.macphymode == SINGLEMAC_SINGLEPHY) {
	..
} else if (rtlpriv->rtlhal.macphymode != SINGLEMAC_SINGLEPHY) {
	..
}

replaced with:

if (rtlpriv->rtlhal.macphymode == SINGLEMAC_SINGLEPHY) {
	..
} else {
	..
}

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/net/wireless/rtlwifi/rtl8192de/hw.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/rtlwifi/rtl8192de/hw.c b/drivers/net/wireless/rtlwifi/rtl8192de/hw.c
index 280c3da..01bcc2d 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192de/hw.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192de/hw.c
@@ -546,7 +546,7 @@ static bool _rtl92de_llt_table_init(struct ieee80211_hw *hw)
 		txpktbuf_bndy = 246;
 		value8 = 0;
 		value32 = 0x80bf0d29;
-	} else if (rtlpriv->rtlhal.macphymode != SINGLEMAC_SINGLEPHY) {
+	} else {
 		maxPage = 127;
 		txpktbuf_bndy = 123;
 		value8 = 0;
-- 
2.1.4

