Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752071AbaBKXZ3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 18:25:29 -0500
Received: from merlin.infradead.org ([205.233.59.134]:49224 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751788AbaBKXZ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 18:25:28 -0500
Message-ID: <52FAB164.3090701@infradead.org>
Date: Tue, 11 Feb 2014 15:25:24 -0800
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] staging/rtl8821ae: fix build, depends on MAC80211
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>

rtl8821ae uses ieee80211 interfaces so it should depend on
MAC80211.  Fixes these build errors:

ERROR: "ieee80211_rx_irqsafe" [drivers/staging/rtl8821ae/rtl8821ae.ko] undefined!
ERROR: "ieee80211_beacon_get_tim" [drivers/staging/rtl8821ae/rtl8821ae.ko] undefined!
ERROR: "ieee80211_unregister_hw" [drivers/staging/rtl8821ae/rtl8821ae.ko] undefined!
ERROR: "rate_control_send_low" [drivers/staging/rtl8821ae/rtl8821ae.ko] undefined!
ERROR: "ieee80211_stop_queue" [drivers/staging/rtl8821ae/rtl8821ae.ko] undefined!
ERROR: "ieee80211_rate_control_register" [drivers/staging/rtl8821ae/rtl8821ae.ko] undefined!
ERROR: "wiphy_to_ieee80211_hw" [drivers/staging/rtl8821ae/rtl8821ae.ko] undefined!
ERROR: "ieee80211_stop_tx_ba_cb_irqsafe" [drivers/staging/rtl8821ae/rtl8821ae.ko] undefined!
ERROR: "ieee80211_tx_status_irqsafe" [drivers/staging/rtl8821ae/rtl8821ae.ko] undefined!
ERROR: "ieee80211_find_sta" [drivers/staging/rtl8821ae/rtl8821ae.ko] undefined!
ERROR: "ieee80211_wake_queue" [drivers/staging/rtl8821ae/rtl8821ae.ko] undefined!
ERROR: "ieee80211_rate_control_unregister" [drivers/staging/rtl8821ae/rtl8821ae.ko] undefined!
ERROR: "ieee80211_register_hw" [drivers/staging/rtl8821ae/rtl8821ae.ko] undefined!
ERROR: "ieee80211_start_tx_ba_session" [drivers/staging/rtl8821ae/rtl8821ae.ko] undefined!
ERROR: "ieee80211_alloc_hw" [drivers/staging/rtl8821ae/rtl8821ae.ko] undefined!
ERROR: "ieee80211_free_hw" [drivers/staging/rtl8821ae/rtl8821ae.ko] undefined!
ERROR: "ieee80211_connection_loss" [drivers/staging/rtl8821ae/rtl8821ae.ko] undefined!
ERROR: "ieee80211_start_tx_ba_cb_irqsafe" [drivers/staging/rtl8821ae/rtl8821ae.ko] undefined!

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
---
 drivers/staging/rtl8821ae/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-next-20140211.orig/drivers/staging/rtl8821ae/Kconfig
+++ linux-next-20140211/drivers/staging/rtl8821ae/Kconfig
@@ -1,6 +1,6 @@
 config R8821AE
 	tristate "RealTek RTL8821AE Wireless LAN NIC driver"
-	depends on PCI && WLAN
+	depends on PCI && WLAN && MAC80211
 	depends on m
 	select WIRELESS_EXT
 	select WEXT_PRIV
