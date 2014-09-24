Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753826AbaIXPc2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 11:32:28 -0400
Received: from mail-wi0-f181.google.com ([209.85.212.181]:42620 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750742AbaIXPc0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 11:32:26 -0400
From: Mathieu OTHACEHE <m.othacehe@gmail.com>
To: gregkh@linuxfoundation.org, standby24x7@gmail.com, hans@hanshq.net,
        anders.darander@gmail.com, joe@perches.com, sachin.kamat@linaro.org,
        linux@rasmusvillemoes.dk, gokul.linux@gmail.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Mathieu OTHACEHE <m.othacehe@gmail.com>
Subject: [PATCH] staging: rtl8821ae: fix sparse warning for static declarations
Date: Wed, 24 Sep 2014 17:32:04 +0200
Message-Id: <1411572724-11821-1-git-send-email-m.othacehe@gmail.com>
X-Mailer: git-send-email 2.1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes the following sparse warnings:

drivers/staging/rtl8821ae/pci.c:52:4: warning: symbol '_rtl_mac_to_hwqueue' was not declared. Should it be static?
drivers/staging/rtl8821ae/pci.c:365:6: warning: symbol 'rtl_pci_check_buddy_priv' was not declared. Should it be static?
drivers/staging/rtl8821ae/pci.c:409:6: warning: symbol 'rtl_pci_get_linkcontrol_field' was not declared. Should it be static?
drivers/staging/rtl8821ae/pci.c:1748:6: warning: symbol 'rtl_pci_deinit' was not declared. Should it be static?
drivers/staging/rtl8821ae/pci.c:1763:5: warning: symbol 'rtl_pci_init' was not declared. Should it be static?
drivers/staging/rtl8821ae/pci.c:1780:5: warning: symbol 'rtl_pci_start' was not declared. Should it be static?
drivers/staging/rtl8821ae/pci.c:1814:6: warning: symbol 'rtl_pci_stop' was not declared. Should it be static?
drivers/staging/rtl8821ae/pci.c:2105:21: warning: symbol 'hw_export' was not declared. Should it be static?

Signed-off-by: Mathieu OTHACEHE <m.othacehe@gmail.com>
---
This patch is part of task 16 of the eudyptula challenge
 drivers/staging/rtl8821ae/pci.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/rtl8821ae/pci.c b/drivers/staging/rtl8821ae/pci.c
index 2995230..a332ede 100644
--- a/drivers/staging/rtl8821ae/pci.c
+++ b/drivers/staging/rtl8821ae/pci.c
@@ -49,7 +49,7 @@ static const u8 ac_to_hwq[] = {
 	BK_QUEUE
 };
 
-u8 _rtl_mac_to_hwqueue(struct ieee80211_hw *hw,
+static u8 _rtl_mac_to_hwqueue(struct ieee80211_hw *hw,
 		struct sk_buff *skb)
 {
 	struct rtl_hal *rtlhal = rtl_hal(rtl_priv(hw));
@@ -362,8 +362,8 @@ static bool rtl_pci_get_amd_l1_patch(struct ieee80211_hw *hw)
 	return status;
 }
 
-bool rtl_pci_check_buddy_priv(struct ieee80211_hw *hw,
-        		      struct rtl_priv **buddy_priv)
+static bool rtl_pci_check_buddy_priv(struct ieee80211_hw *hw,
+				     struct rtl_priv **buddy_priv)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	struct rtl_pci_priv *pcipriv = rtl_pcipriv(hw);
@@ -406,7 +406,7 @@ bool rtl_pci_check_buddy_priv(struct ieee80211_hw *hw,
 	return b_find_buddy_priv;
 }
 
-void rtl_pci_get_linkcontrol_field(struct ieee80211_hw *hw)
+static void rtl_pci_get_linkcontrol_field(struct ieee80211_hw *hw)
 {
 	struct rtl_pci_priv *pcipriv = rtl_pcipriv(hw);
 	u8 capabilityoffset = pcipriv->ndis_adapter.pcibridge_pciehdr_offset;
@@ -1745,7 +1745,7 @@ static void rtl_pci_flush(struct ieee80211_hw *hw, u32 queues, bool drop)
 	}
 }
 
-void rtl_pci_deinit(struct ieee80211_hw *hw)
+static void rtl_pci_deinit(struct ieee80211_hw *hw)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	struct rtl_pci *rtlpci = rtl_pcidev(rtl_pcipriv(hw));
@@ -1760,7 +1760,7 @@ void rtl_pci_deinit(struct ieee80211_hw *hw)
 
 }
 
-int rtl_pci_init(struct ieee80211_hw *hw, struct pci_dev *pdev)
+static int rtl_pci_init(struct ieee80211_hw *hw, struct pci_dev *pdev)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	int err;
@@ -1777,7 +1777,7 @@ int rtl_pci_init(struct ieee80211_hw *hw, struct pci_dev *pdev)
 	return 1;
 }
 
-int rtl_pci_start(struct ieee80211_hw *hw)
+static int rtl_pci_start(struct ieee80211_hw *hw)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	struct rtl_hal *rtlhal = rtl_hal(rtl_priv(hw));
@@ -1811,7 +1811,7 @@ int rtl_pci_start(struct ieee80211_hw *hw)
 	return 0;
 }
 
-void rtl_pci_stop(struct ieee80211_hw *hw)
+static void rtl_pci_stop(struct ieee80211_hw *hw)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	struct rtl_ps_ctl *ppsc = rtl_psc(rtl_priv(hw));
@@ -2102,7 +2102,7 @@ static int rtl_pci_intr_mode_decide(struct ieee80211_hw *hw)
 
 /* this is used for other modules get
  * hw pointer in rtl_pci_get_hw_pointer */
-struct ieee80211_hw *hw_export = NULL;
+static struct ieee80211_hw *hw_export;
 
 int rtl_pci_probe(struct pci_dev *pdev,
                   const struct pci_device_id *id)
-- 
2.1.0

