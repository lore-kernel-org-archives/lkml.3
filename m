Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752896AbaFGO32 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jun 2014 10:29:28 -0400
Received: from mail-la0-f51.google.com ([209.85.215.51]:65115 "EHLO
	mail-la0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752837AbaFGO31 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jun 2014 10:29:27 -0400
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Larry Finger <Larry.Finger@lwfinger.net>,
        Chaoming Li <chaoming_li@realsil.com.cn>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        "John W. Linville" <linville@tuxdriver.com>,
        Peter Wu <lekensteyn@gmail.com>, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] net: wireless: rtlwifi: rtl8192de: hw.c:  Cleaning up conjunction always evaluates to false
Date: Sat,  7 Jun 2014 16:30:19 +0200
Message-Id: <1402151419-18296-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Expression '(X & 0xfc) == 0x3' is always false

I chose to remove this code, because it will not make any difference.
But obviously it is rather a properly designed if statement that is needed.

This was partly found using a static code analysis program called cppcheck.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 drivers/net/wireless/rtlwifi/rtl8192de/hw.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/net/wireless/rtlwifi/rtl8192de/hw.c b/drivers/net/wireless/rtlwifi/rtl8192de/hw.c
index 2b08671..a1520d5 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192de/hw.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192de/hw.c
@@ -1128,10 +1128,7 @@ static int _rtl92de_set_media_status(struct ieee80211_hw *hw,
 	}
 	rtl_write_byte(rtlpriv, REG_CR + 2, bt_msr);
 	rtlpriv->cfg->ops->led_control(hw, ledaction);
-	if ((bt_msr & 0xfc) == MSR_AP)
-		rtl_write_byte(rtlpriv, REG_BCNTCFG + 1, 0x00);
-	else
-		rtl_write_byte(rtlpriv, REG_BCNTCFG + 1, 0x66);
+	rtl_write_byte(rtlpriv, REG_BCNTCFG + 1, 0x66);
 	return 0;
 }
 
-- 
1.7.10.4

