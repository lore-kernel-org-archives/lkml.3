Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756119AbaIROeR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2014 10:34:17 -0400
Received: from thoros.lunarpages.com ([67.210.120.70]:57259 "EHLO
	thoros.lunarpages.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754380AbaIROeQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2014 10:34:16 -0400
X-Greylist: delayed 61691 seconds by postgrey-1.27 at vger.kernel.org; Thu, 18 Sep 2014 10:34:16 EDT
From: "Ragnar B. Johannsson" <ragnar@igo.is>
To: dan.carpenter@oracle.com, gregkh@linuxfoundation.org, gdonald@gmail.com,
        himangi774@gmail.com, joe@perches.com, joelpelaez@gmail.com,
        arnd@arndb.de, jmmahler@gmail.com, peter.p.waskiewicz.jr@intel.com,
        antoine@schweitzer-chaput.fr, anarey@gmail.com, c@24.io,
        rickard_strandqvist@spectrumdigital.se, teobaluta@gmail.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        "Ragnar B. Johannsson" <ragnar@igo.is>
Subject: [PATCH v2 1/1] staging: rtl8192u: Move ieee80211_crypto_* declarations to ieee80211/ieee80211.h
Date: Thu, 18 Sep 2014 14:33:25 +0000
Message-Id: <1411050805-61907-1-git-send-email-ragnar@igo.is>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <20140917214027.GM17875@mwanda>
References: <20140917214027.GM17875@mwanda>
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - thoros.lunarpages.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - igo.is
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move ieee80211_crypto*_init and _exit prototype declarations from r8192U_core.c to ieee80211/ieee80211.h. This fixes the following sparse warnings:

drivers/staging/rtl8192u/ieee80211/ieee80211_crypt.c:203:12: warning: symbol 'ieee80211_crypto_init' was not declared. Should it be static?
drivers/staging/rtl8192u/ieee80211/ieee80211_crypt.c:223:13: warning: symbol 'ieee80211_crypto_deinit' was not declared. Should it be static?
drivers/staging/rtl8192u/ieee80211/ieee80211_crypt_tkip.c:764:12: warning: symbol 'ieee80211_crypto_tkip_init' was not declared. Should it be static?
drivers/staging/rtl8192u/ieee80211/ieee80211_crypt_tkip.c:769:13: warning: symbol 'ieee80211_crypto_tkip_exit' was not declared. Should it be static?
drivers/staging/rtl8192u/ieee80211/ieee80211_crypt_ccmp.c:467:12: warning: symbol 'ieee80211_crypto_ccmp_init' was not declared. Should it be static?
drivers/staging/rtl8192u/ieee80211/ieee80211_crypt_ccmp.c:472:13: warning: symbol 'ieee80211_crypto_ccmp_exit' was not declared. Should it be static?
drivers/staging/rtl8192u/ieee80211/ieee80211_crypt_wep.c:281:12: warning: symbol 'ieee80211_crypto_wep_init' was not declared. Should it be static?
drivers/staging/rtl8192u/ieee80211/ieee80211_crypt_wep.c:286:13: warning: symbol 'ieee80211_crypto_wep_exit' was not declared. Should it be static?

Signed-off-by: Ragnar B. Johannsson <ragnar@igo.is>
---
Changes in v2: Remove extern, as suggested by Dan Carpenter.

 drivers/staging/rtl8192u/ieee80211/ieee80211.h |    9 +++++++++
 drivers/staging/rtl8192u/r8192U_core.c         |   10 ----------
 2 files changed, 9 insertions(+), 10 deletions(-)

diff --git a/drivers/staging/rtl8192u/ieee80211/ieee80211.h b/drivers/staging/rtl8192u/ieee80211/ieee80211.h
index bdad3a2..d56c3aac 100644
--- a/drivers/staging/rtl8192u/ieee80211/ieee80211.h
+++ b/drivers/staging/rtl8192u/ieee80211/ieee80211.h
@@ -2445,6 +2445,15 @@ extern void ieee80211_tkip_null(void);
 extern void ieee80211_wep_null(void);
 extern void ieee80211_ccmp_null(void);
 
+int ieee80211_crypto_init(void);
+void ieee80211_crypto_deinit(void);
+int ieee80211_crypto_tkip_init(void);
+void ieee80211_crypto_tkip_exit(void);
+int ieee80211_crypto_ccmp_init(void);
+void ieee80211_crypto_ccmp_exit(void);
+int ieee80211_crypto_wep_init(void);
+void ieee80211_crypto_wep_exit(void);
+
 /* ieee80211_softmac_wx.c */
 
 extern int ieee80211_wx_get_wap(struct ieee80211_device *ieee,
diff --git a/drivers/staging/rtl8192u/r8192U_core.c b/drivers/staging/rtl8192u/r8192U_core.c
index a4e1d6b..e8447b1 100644
--- a/drivers/staging/rtl8192u/r8192U_core.c
+++ b/drivers/staging/rtl8192u/r8192U_core.c
@@ -4798,16 +4798,6 @@ static void rtl8192_usb_disconnect(struct usb_interface *intf)
 	RT_TRACE(COMP_DOWN, "wlan driver removed\n");
 }
 
-/* fun with the built-in ieee80211 stack... */
-extern int ieee80211_crypto_init(void);
-extern void ieee80211_crypto_deinit(void);
-extern int ieee80211_crypto_tkip_init(void);
-extern void ieee80211_crypto_tkip_exit(void);
-extern int ieee80211_crypto_ccmp_init(void);
-extern void ieee80211_crypto_ccmp_exit(void);
-extern int ieee80211_crypto_wep_init(void);
-extern void ieee80211_crypto_wep_exit(void);
-
 static int __init rtl8192_usb_module_init(void)
 {
 	int ret;
-- 
1.7.10.4

