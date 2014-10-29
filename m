Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757524AbaJ2Wmm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 18:42:42 -0400
Received: from mail-pa0-f43.google.com ([209.85.220.43]:55332 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757287AbaJ2Wmj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 18:42:39 -0400
From: Behan Webster <behanw@converseincode.com>
To: andriy.shevchenko@linux.intel.com, aysemelikeyurtoglu@gmail.com,
        matthias.schoepe@studium.uni-erlangen.de, mdcasey@chabloom.com,
        peter.senna@gmail.com, rashika.kheria@gmail.com, standby24x7@gmail.com
Cc: behanw@converseincode.com, akpm@linux-foundation.org,
        andreas.frembs@studium.uni-erlangen.de, devel@driverdev.osuosl.org,
        gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        mahati.chamarthy@gmail.com, peter.p.waskiewicz.jr@intel.com,
        quozl@laptop.org, valentina.manea.m@gmail.com,
        Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 1/4] staging, rtl8192e, LLVMLinux: Change extern inline to static inline
Date: Wed, 29 Oct 2014 15:42:20 -0700
Message-Id: <1414622543-22969-2-git-send-email-behanw@converseincode.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1414622543-22969-1-git-send-email-behanw@converseincode.com>
References: <1414622543-22969-1-git-send-email-behanw@converseincode.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With compilers which follow the C99 standard (like modern versions of gcc and
clang), "extern inline" does the opposite thing from older versions of gcc
(emits code for an externally linkable version of the inline function).

"static inline" does the intended behavior in all cases instead.

Signed-off-by: Behan Webster <behanw@converseincode.com>
Suggested-by: Arnd Bergmann <arnd@arndb.de>
Cc: Arnd Bergmann <arnd@arndb.de>
---
 drivers/staging/rtl8192e/rtllib.h         | 4 ++--
 drivers/staging/rtl8192e/rtllib_softmac.c | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/rtl8192e/rtllib.h b/drivers/staging/rtl8192e/rtllib.h
index 2d82f89..33995ac 100644
--- a/drivers/staging/rtl8192e/rtllib.h
+++ b/drivers/staging/rtl8192e/rtllib.h
@@ -2944,12 +2944,12 @@ void rtllib_softmac_scan_syncro(struct rtllib_device *ieee, u8 is_mesh);
 
 extern const long rtllib_wlan_frequencies[];
 
-extern inline void rtllib_increment_scans(struct rtllib_device *ieee)
+static inline void rtllib_increment_scans(struct rtllib_device *ieee)
 {
 	ieee->scans++;
 }
 
-extern inline int rtllib_get_scans(struct rtllib_device *ieee)
+static inline int rtllib_get_scans(struct rtllib_device *ieee)
 {
 	return ieee->scans;
 }
diff --git a/drivers/staging/rtl8192e/rtllib_softmac.c b/drivers/staging/rtl8192e/rtllib_softmac.c
index abb6729..067a45a 100644
--- a/drivers/staging/rtl8192e/rtllib_softmac.c
+++ b/drivers/staging/rtl8192e/rtllib_softmac.c
@@ -343,7 +343,7 @@ inline void softmac_ps_mgmt_xmit(struct sk_buff *skb,
 	}
 }
 
-inline struct sk_buff *rtllib_probe_req(struct rtllib_device *ieee)
+static inline struct sk_buff *rtllib_probe_req(struct rtllib_device *ieee)
 {
 	unsigned int len, rate_len;
 	u8 *tag;
-- 
1.9.1

