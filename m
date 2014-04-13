Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754887AbaDMRKD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2014 13:10:03 -0400
Received: from tex.lwn.net ([70.33.254.29]:43265 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751499AbaDMRKA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2014 13:10:00 -0400
Date: Sun, 13 Apr 2014 11:10:45 -0600
From: Jake Edge <jake@edge2.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Ana Rey <anarey@gmail.com>,
        Peter P Waskiewicz Jr <peter.p.waskiewicz.jr@intel.com>,
        Himangi Saraogi <himangi774@gmail.com>,
        Bob Copeland <me@bobcopeland.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] staging/rtl8187se fix sparse complaints
Message-ID: <20140413111045.52aef874@quetzal.lan>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.22; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Fix the following sparse complaints:

drivers/staging/rtl8187se//r8180_wx.c:1399:24: warning: symbol
'r8180_wx_handlers_def' was not declared. Should it be static?

drivers/staging/rtl8187se//ieee80211/ieee80211_crypt.c:201:5: warning:
symbol 'ieee80211_crypto_init' was not declared. Should it be static?

drivers/staging/rtl8187se//ieee80211/ieee80211_crypt.c:222:6: warning:
symbol 'ieee80211_crypto_deinit' was not declared. Should it be static?

drivers/staging/rtl8187se//ieee80211/ieee80211_crypt_ccmp.c:446:5:
warning: symbol 'ieee80211_crypto_ccmp_init' was not declared. Should
it be static?

drivers/staging/rtl8187se//ieee80211/ieee80211_crypt_ccmp.c:452:6:
warning: symbol 'ieee80211_crypto_ccmp_exit' was not declared. Should
it be static?

drivers/staging/rtl8187se//ieee80211/ieee80211_crypt_wep.c:264:5:
warning: symbol 'ieee80211_crypto_wep_init' was not declared. Should it
be static?

drivers/staging/rtl8187se//ieee80211/ieee80211_crypt_wep.c:269:6:
warning: symbol 'ieee80211_crypto_wep_exit' was not declared. Should it
be static?

by adding an include file into source files and moving some
declarations around into the proper header files.

Signed-off-by: Jake Edge <jake@edge2.net>
---

Against next-20140411

diff --git a/drivers/staging/rtl8187se/ieee80211/ieee80211_crypt.h b/drivers/staging/rtl8187se/ieee80211/ieee80211_crypt.h
index 0b4ea43..8fe7873 100644
--- a/drivers/staging/rtl8187se/ieee80211/ieee80211_crypt.h
+++ b/drivers/staging/rtl8187se/ieee80211/ieee80211_crypt.h
@@ -83,4 +83,13 @@ void ieee80211_crypt_deinit_handler(unsigned long);
 void ieee80211_crypt_delayed_deinit(struct ieee80211_device *ieee,
 				    struct ieee80211_crypt_data **crypt);
 
+/* fun with the built-in ieee80211 stack... */
+int ieee80211_crypto_init(void);
+void ieee80211_crypto_deinit(void);
+int ieee80211_crypto_tkip_init(void);
+void ieee80211_crypto_tkip_exit(void);
+int ieee80211_crypto_ccmp_init(void);
+void ieee80211_crypto_ccmp_exit(void);
+int ieee80211_crypto_wep_init(void);
+void ieee80211_crypto_wep_exit(void);
 #endif
diff --git a/drivers/staging/rtl8187se/r8180.h b/drivers/staging/rtl8187se/r8180.h
index 9f931db..cf510b6 100644
--- a/drivers/staging/rtl8187se/r8180.h
+++ b/drivers/staging/rtl8187se/r8180.h
@@ -629,12 +629,3 @@ bool MgntActSet_RF_State(struct net_device *dev, enum rt_rf_power_state StateToS
 
 #endif
 
-/* fun with the built-in ieee80211 stack... */
-extern int ieee80211_crypto_init(void);
-extern void ieee80211_crypto_deinit(void);
-extern int ieee80211_crypto_tkip_init(void);
-extern void ieee80211_crypto_tkip_exit(void);
-extern int ieee80211_crypto_ccmp_init(void);
-extern void ieee80211_crypto_ccmp_exit(void);
-extern int ieee80211_crypto_wep_init(void);
-extern void ieee80211_crypto_wep_exit(void);
diff --git a/drivers/staging/rtl8187se/r8180_core.c b/drivers/staging/rtl8187se/r8180_core.c
index a6022d4..cbdff00 100644
--- a/drivers/staging/rtl8187se/r8180_core.c
+++ b/drivers/staging/rtl8187se/r8180_core.c
@@ -47,6 +47,7 @@
 #include "r8180_dm.h"
 
 #include "ieee80211/dot11d.h"
+#include "ieee80211/ieee80211_crypt.h"
 
 static struct pci_device_id rtl8180_pci_id_tbl[] = {
 	{
diff --git a/drivers/staging/rtl8187se/r8180_wx.c b/drivers/staging/rtl8187se/r8180_wx.c
index b552491..57bf01f 100644
--- a/drivers/staging/rtl8187se/r8180_wx.c
+++ b/drivers/staging/rtl8187se/r8180_wx.c
@@ -20,6 +20,7 @@
 
 #include "r8180.h"
 #include "r8180_hw.h"
+#include "r8180_wx.h"
 
 #include <net/iw_handler.h>
 #include "ieee80211/dot11d.h"


-- 
Jake Edge - jake@edge2.net - http://www.edge2.net
