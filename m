Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964864AbaCTT2m (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 15:28:42 -0400
Received: from lekensteyn.nl ([178.21.112.251]:45423 "EHLO lekensteyn.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759759AbaCTT1n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 15:27:43 -0400
From: Peter Wu <peter@lekensteyn.nl>
To: Larry Finger <Larry.Finger@lwfinger.net>,
        John W Linville <linville@tuxdriver.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Chaoming_Li <chaoming_li@realsil.com.cn>, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org, lekensteyn@gmail.com
Subject: [PATCH 2/3] staging/rtl8821ae: avoid accessing RCR directly
Date: Thu, 20 Mar 2014 19:52:23 +0100
Message-Id: <1395341544-21464-3-git-send-email-peter@lekensteyn.nl>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1395341544-21464-1-git-send-email-peter@lekensteyn.nl>
References: <1395341544-21464-1-git-send-email-peter@lekensteyn.nl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Similar to "rtlwifi: avoid accessing RCR directly", this patch avoids
accessing receive_config directly and uses get_hw_reg. There is no
functional change.

Signed-off-by: Peter Wu <peter@lekensteyn.nl>
---
 drivers/staging/rtl8821ae/rtl8821ae/hw.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/rtl8821ae/rtl8821ae/hw.c b/drivers/staging/rtl8821ae/rtl8821ae/hw.c
index 5ed7a11..e4dbf05 100644
--- a/drivers/staging/rtl8821ae/rtl8821ae/hw.c
+++ b/drivers/staging/rtl8821ae/rtl8821ae/hw.c
@@ -1633,12 +1633,13 @@ static int _rtl8821ae_set_media_status(struct ieee80211_hw *hw,
 void rtl8821ae_set_check_bssid(struct ieee80211_hw *hw, bool check_bssid)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
-	struct rtl_pci *rtlpci = rtl_pcidev(rtl_pcipriv(hw));
-	u32 reg_rcr = rtlpci->receive_config;
+	u32 reg_rcr;
 
 	if (rtlpriv->psc.rfpwr_state != ERFON)
 		return;
 
+	rtlpriv->cfg->ops->get_hw_reg(hw, HW_VAR_RCR, (u8 *)(&reg_rcr));
+
 	if (check_bssid == true) {
 		reg_rcr |= (RCR_CBSSID_DATA | RCR_CBSSID_BCN);
 		rtlpriv->cfg->ops->set_hw_reg(hw, HW_VAR_RCR,
-- 
1.9.1

