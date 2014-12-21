Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753287AbaLUAb2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Dec 2014 19:31:28 -0500
Received: from mail-wg0-f50.google.com ([74.125.82.50]:39472 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753003AbaLUAb0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Dec 2014 19:31:26 -0500
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Brett Rudley <brudley@broadcom.com>, Arend van Spriel <arend@broadcom.com>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Hante Meuleman <meuleman@broadcom.com>, Kalle Valo <kvalo@adurom.com>,
        Fabian Frederick <fabf@skynet.be>, linux-wireless@vger.kernel.org,
        brcm80211-dev-list@broadcom.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] net: wireless: brcm80211: brcmsmac: phy: phy_lcn.c:  Remove unused function
Date: Sun, 21 Dec 2014 01:34:13 +0100
Message-Id: <1419122053-14613-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the function wlc_lcnphy_crsuprs() that is not used anywhere.

This was partially found by using a static code analysis program called cppcheck.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 .../net/wireless/brcm80211/brcmsmac/phy/phy_int.h  |    1 -
 .../net/wireless/brcm80211/brcmsmac/phy/phy_lcn.c  |   31 --------------------
 2 files changed, 32 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmsmac/phy/phy_int.h b/drivers/net/wireless/brcm80211/brcmsmac/phy/phy_int.h
index 4960f7d..a05dbde 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/phy/phy_int.h
+++ b/drivers/net/wireless/brcm80211/brcmsmac/phy/phy_int.h
@@ -1002,7 +1002,6 @@ s16 wlc_lcnphy_tempsense_new(struct brcms_phy *pi, bool mode);
 s8 wlc_lcnphy_tempsense_degree(struct brcms_phy *pi, bool mode);
 s8 wlc_lcnphy_vbatsense(struct brcms_phy *pi, bool mode);
 void wlc_phy_carrier_suppress_lcnphy(struct brcms_phy *pi);
-void wlc_lcnphy_crsuprs(struct brcms_phy *pi, int channel);
 void wlc_lcnphy_epa_switch(struct brcms_phy *pi, bool mode);
 void wlc_2064_vco_cal(struct brcms_phy *pi);
 
diff --git a/drivers/net/wireless/brcm80211/brcmsmac/phy/phy_lcn.c b/drivers/net/wireless/brcm80211/brcmsmac/phy/phy_lcn.c
index 5f13662..d2adb2d 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/phy/phy_lcn.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/phy/phy_lcn.c
@@ -1546,37 +1546,6 @@ s8 wlc_lcnphy_get_current_tx_pwr_idx(struct brcms_phy *pi)
 	return index;
 }
 
-void wlc_lcnphy_crsuprs(struct brcms_phy *pi, int channel)
-{
-	u16 afectrlovr, afectrlovrval;
-	afectrlovr = read_phy_reg(pi, 0x43b);
-	afectrlovrval = read_phy_reg(pi, 0x43c);
-	if (channel != 0) {
-		mod_phy_reg(pi, 0x43b, (0x1 << 1), (1) << 1);
-
-		mod_phy_reg(pi, 0x43c, (0x1 << 1), (0) << 1);
-
-		mod_phy_reg(pi, 0x43b, (0x1 << 4), (1) << 4);
-
-		mod_phy_reg(pi, 0x43c, (0x1 << 6), (0) << 6);
-
-		write_phy_reg(pi, 0x44b, 0xffff);
-		wlc_lcnphy_tx_pu(pi, 1);
-
-		mod_phy_reg(pi, 0x634, (0xff << 8), (0) << 8);
-
-		or_phy_reg(pi, 0x6da, 0x0080);
-
-		or_phy_reg(pi, 0x00a, 0x228);
-	} else {
-		and_phy_reg(pi, 0x00a, ~(0x228));
-
-		and_phy_reg(pi, 0x6da, 0xFF7F);
-		write_phy_reg(pi, 0x43b, afectrlovr);
-		write_phy_reg(pi, 0x43c, afectrlovrval);
-	}
-}
-
 static void wlc_lcnphy_toggle_afe_pwdn(struct brcms_phy *pi)
 {
 	u16 save_AfeCtrlOvrVal, save_AfeCtrlOvr;
-- 
1.7.10.4

