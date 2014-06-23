Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754900AbaFWV70 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 17:59:26 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:45212 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754633AbaFWV7X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 17:59:23 -0400
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Larry Finger <Larry.Finger@lwfinger.net>,
        Chaoming Li <chaoming_li@realsil.com.cn>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        "John W. Linville" <linville@tuxdriver.com>,
        Ben Hutchings <ben@decadent.org.uk>, Peter Wu <peter@lekensteyn.nl>,
        Mark Cave-Ayland <mark.cave-ayland@ilande.co.uk>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCHv3 3/6] rtlwifi/rtl8188ee: Fix media status register mask
Date: Tue, 24 Jun 2014 00:00:22 +0200
Message-Id: <1403560822-7778-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

bt_msr & 0xfc will never match 0x3. Fix this by using a mask that actually matches the available types.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Reviewed-by: Peter Wu <peter@lekensteyn.nl>
---
 drivers/net/wireless/rtlwifi/rtl8188ee/hw.c  |    2 +-
 drivers/net/wireless/rtlwifi/rtl8188ee/reg.h |    1 +
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/rtlwifi/rtl8188ee/hw.c b/drivers/net/wireless/rtlwifi/rtl8188ee/hw.c
index 94cd9df..9bdac68 100644
--- a/drivers/net/wireless/rtlwifi/rtl8188ee/hw.c
+++ b/drivers/net/wireless/rtlwifi/rtl8188ee/hw.c
@@ -1231,7 +1231,7 @@ static int _rtl88ee_set_media_status(struct ieee80211_hw *hw,
 
 	rtl_write_byte(rtlpriv, (MSR), bt_msr);
 	rtlpriv->cfg->ops->led_control(hw, ledaction);
-	if ((bt_msr & 0xfc) == MSR_AP)
+	if ((bt_msr & MSR_MASK) == MSR_AP)
 		rtl_write_byte(rtlpriv, REG_BCNTCFG + 1, 0x00);
 	else
 		rtl_write_byte(rtlpriv, REG_BCNTCFG + 1, 0x66);
diff --git a/drivers/net/wireless/rtlwifi/rtl8188ee/reg.h b/drivers/net/wireless/rtlwifi/rtl8188ee/reg.h
index 7af85cf..cd7e7a5 100644
--- a/drivers/net/wireless/rtlwifi/rtl8188ee/reg.h
+++ b/drivers/net/wireless/rtlwifi/rtl8188ee/reg.h
@@ -411,6 +411,7 @@
 #define	MSR_ADHOC				0x01
 #define	MSR_INFRA				0x02
 #define	MSR_AP					0x03
+#define	MSR_MASK				0x03
 
 #define	RRSR_RSC_OFFSET				21
 #define	RRSR_SHORT_OFFSET			23
-- 
1.7.10.4

