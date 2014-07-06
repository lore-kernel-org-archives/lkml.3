Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751520AbaGFJBX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jul 2014 05:01:23 -0400
Received: from mail-lb0-f177.google.com ([209.85.217.177]:63161 "EHLO
	mail-lb0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750911AbaGFJBW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jul 2014 05:01:22 -0400
Date: Sun, 6 Jul 2014 12:01:11 +0300
From: Sami Laine <laine.j.sami@gmail.com>
To: gregkh@linuxfoundation.org
Cc: gulsah.1004@gmail.com, Larry.Finger@lwfinger.net, linville@tuxdriver.com,
        paulmck@linux.vnet.ibm.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, trivial@kernel.org
Subject: [PATCH next-20140704]: staging/rtl8821ae/base.c: sparse warning
 corrections
Message-ID: <20140706090111.GA16760@acer>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sami Laine <laine.j.sami@gmail.com>

Sparse warning corrections for:

drivers/staging/rtl8821ae/base.c:1370:16: warning: symbol 'rtl_make_smps_action' was not declared. Should it be static?
drivers/staging/rtl8821ae/base.c:1543:6: warning: symbol 'rtl_find_221_ie' was not declared. Should it be static?
drivers/staging/rtl8821ae/base.c:1804:5: warning: symbol 'rtl_core_module_init' was not declared. Should it be static?
drivers/staging/rtl8821ae/base.c:1820:6: warning: symbol 'rtl_core_module_exit' was not declared. Should it be static?

Signed-off-by: Sami Laine <laine.j.sami@gmail.com>
---
diff --git a/drivers/staging/rtl8821ae/base.c b/drivers/staging/rtl8821ae/base.c
index 4a36da0..c2d0b18 100644
--- a/drivers/staging/rtl8821ae/base.c
+++ b/drivers/staging/rtl8821ae/base.c
@@ -1367,7 +1367,7 @@ u8 *rtl_find_ie(u8 *data, unsigned int len, u8 ie)
 
 /* when we use 2 rx ants we send IEEE80211_SMPS_OFF */
 /* when we use 1 rx ant we send IEEE80211_SMPS_STATIC */
-struct sk_buff *rtl_make_smps_action(struct ieee80211_hw *hw,
+static struct sk_buff *rtl_make_smps_action(struct ieee80211_hw *hw,
 				     enum ieee80211_smps_mode smps,
 				     u8 *da, u8 *bssid)
 {
@@ -1540,7 +1540,7 @@ static bool rtl_chk_vendor_ouisub(struct ieee80211_hw *hw,
 	return matched;
 }
 
-bool rtl_find_221_ie(struct ieee80211_hw *hw, u8 *data,
+static bool rtl_find_221_ie(struct ieee80211_hw *hw, u8 *data,
 		unsigned int len)
 {
 	struct ieee80211_mgmt *mgmt = (void *)data;
@@ -1801,7 +1801,7 @@ MODULE_DESCRIPTION("Realtek 802.11n PCI wireless core");
 #endif
 struct rtl_global_var global_var = {};
 
-int rtl_core_module_init(void)
+static int rtl_core_module_init(void)
 {
 	if (rtl_rate_control_register())
 		printk(KERN_DEBUG "rtl: Unable to register rtl_rc, use default RC !!\n");
@@ -1815,8 +1815,9 @@ int rtl_core_module_init(void)
 
 	return 0;
 }
+EXPORT_SYMBOL(rtl_core_module_init);
 
-void rtl_core_module_exit(void)
+static void rtl_core_module_exit(void)
 {
 	/*RC*/
 	rtl_rate_control_unregister();
@@ -1824,6 +1825,7 @@ void rtl_core_module_exit(void)
 	/* add proc for debug */
 	rtl_proc_remove_topdir();
 }
+EXPORT_SYMBOL(rtl_core_module_exit);
 
 #if 0
 module_init(rtl_core_module_init);
