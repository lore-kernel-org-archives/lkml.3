Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754505AbaHLHFl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2014 03:05:41 -0400
Received: from mail-pa0-f48.google.com ([209.85.220.48]:57256 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752726AbaHLHFg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2014 03:05:36 -0400
From: Jeremiah Mahler <jmmahler@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Jeremiah Mahler <jmmahler@gmail.com>,
        Joel Pelaez Jorge <joelpelaez@gmail.com>,
        Andrea Merello <andrea.merello@gmail.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        Joe Perches <joe@perches.com>, Himangi Saraogi <himangi774@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Peter P Waskiewicz Jr <peter.p.waskiewicz.jr@intel.com>,
        Ana Rey <anarey@gmail.com>, Chaitanya Hazarey <c@24.io>,
        Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Teodora Baluta <teobaluta@gmail.com>
Subject: [PATCH v3] staging: rtl8192u/ieee80211: Fix sparse ieee80211_debug_init/_exit not declared warning
Date: Tue, 12 Aug 2014 00:03:44 -0700
Message-Id: <1407827024-14746-1-git-send-email-jmmahler@gmail.com>
X-Mailer: git-send-email 2.1.0.rc1
In-Reply-To: <20140812041733.GA7613@hudson.localdomain>
References: <20140812041733.GA7613@hudson.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A sparse warning is generated about 'ieee80211_debug_init' and
'ieee80211_debug_exit' not being declared.

  drivers/staging/rtl8192u/ieee80211/ieee80211_module.c:275:12: warning:
  symbol 'ieee80211_debug_init' was not declared. Should it be static?
  drivers/staging/rtl8192u/ieee80211/ieee80211_module.c:297:13: warning:
  symbol 'ieee80211_debug_exit' was not declared. Should it be static?

These functions are used outside of this file so using static will not
work.  The prototypes are given in r8192U_core.c but sparse nonetheless
still gives a warning.  Fix the sparse warning by moving these
prototypes from r8192U_core.c to ieee80211.h.

Signed-off-by: Jeremiah Mahler <jmmahler@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Joel Pelaez Jorge <joelpelaez@gmail.com>
Cc: Andrea Merello <andrea.merello@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>
Cc: Joe Perches <joe@perches.com>
Cc: Himangi Saraogi <himangi774@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Peter P Waskiewicz Jr <peter.p.waskiewicz.jr@intel.com>
Cc: Ana Rey <anarey@gmail.com>
Cc: Chaitanya Hazarey <c@24.io>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Cc: Teodora Baluta <teobaluta@gmail.com>
---

Notes:
    Changes in v2:
    
      - remove #ifdef CONFIG_IEEE80211_DEBUG, not needed in header.
    
      - removed __init and __exit, not needed in header.
    
    Changes in v3:
    
      - remove the duplicate prototypes from r892U_core.c
    
      - (prototypes moved from r8192U_core.c to ieee80211.h)

 drivers/staging/rtl8192u/ieee80211/ieee80211.h | 4 ++++
 drivers/staging/rtl8192u/r8192U_core.c         | 2 --
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/rtl8192u/ieee80211/ieee80211.h b/drivers/staging/rtl8192u/ieee80211/ieee80211.h
index 1040bab..c118551 100644
--- a/drivers/staging/rtl8192u/ieee80211/ieee80211.h
+++ b/drivers/staging/rtl8192u/ieee80211/ieee80211.h
@@ -2485,6 +2485,10 @@ extern int ieee80211_wx_set_freq(struct ieee80211_device *ieee, struct iw_reques
 extern int ieee80211_wx_get_freq(struct ieee80211_device *ieee, struct iw_request_info *a,
 			     union iwreq_data *wrqu, char *b);
 
+/* ieee80211_module.c */
+extern int ieee80211_debug_init(void);
+extern void ieee80211_debug_exit(void);
+
 //extern void ieee80211_wx_sync_scan_wq(struct ieee80211_device *ieee);
 extern void ieee80211_wx_sync_scan_wq(struct work_struct *work);
 
diff --git a/drivers/staging/rtl8192u/r8192U_core.c b/drivers/staging/rtl8192u/r8192U_core.c
index 7640386..ee27bb3 100644
--- a/drivers/staging/rtl8192u/r8192U_core.c
+++ b/drivers/staging/rtl8192u/r8192U_core.c
@@ -5277,8 +5277,6 @@ static void rtl8192_usb_disconnect(struct usb_interface *intf)
 }
 
 /* fun with the built-in ieee80211 stack... */
-extern int ieee80211_debug_init(void);
-extern void ieee80211_debug_exit(void);
 extern int ieee80211_crypto_init(void);
 extern void ieee80211_crypto_deinit(void);
 extern int ieee80211_crypto_tkip_init(void);
-- 
2.1.0.rc1

