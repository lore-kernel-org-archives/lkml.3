Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753954AbaHLBuA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 21:50:00 -0400
Received: from mail-pd0-f176.google.com ([209.85.192.176]:40692 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750763AbaHLBt7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 21:49:59 -0400
From: Jeremiah Mahler <jmmahler@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Jeremiah Mahler <jmmahler@gmail.com>,
        Teodora Baluta <teobaluta@gmail.com>,
        Andrea Merello <andrea.merello@gmail.com>,
        Joel Pelaez Jorge <joelpelaez@gmail.com>,
        Bob Copeland <me@bobcopeland.com>, Joe Perches <joe@perches.com>,
        Arnd Bergmann <arnd@arndb.de>, Himangi Saraogi <himangi774@gmail.com>
Subject: [PATCH v2] staging: rtl8192u/ieee80211: Fix sparse ieee80211_debug_init/_exit not declared warning
Date: Mon, 11 Aug 2014 18:49:25 -0700
Message-Id: <1407808165-3873-1-git-send-email-jmmahler@gmail.com>
X-Mailer: git-send-email 2.1.0.rc1
In-Reply-To: <20140811223206.GB9475@kroah.com>
References: <20140811223206.GB9475@kroah.com>
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
work.  Fix the warning by declaring the functions in the header file,
ieee80211.h

Signed-off-by: Jeremiah Mahler <jmmahler@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Teodora Baluta <teobaluta@gmail.com>
Cc: Andrea Merello <andrea.merello@gmail.com>
Cc: Joel Pelaez Jorge <joelpelaez@gmail.com>
Cc: Bob Copeland <me@bobcopeland.com>
Cc: Joe Perches <joe@perches.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Himangi Saraogi <himangi774@gmail.com>
---

Notes:
    Changes in v2:
    
      - remove #ifdef CONFIG_IEEE80211_DEBUG, not needed in header.
    
      - remove __init and __exit, not needed in header.

 drivers/staging/rtl8192u/ieee80211/ieee80211.h | 4 ++++
 1 file changed, 4 insertions(+)

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
 
-- 
2.1.0.rc1

