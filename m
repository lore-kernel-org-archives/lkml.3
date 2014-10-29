Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757703AbaJ2Wms (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 18:42:48 -0400
Received: from mail-pa0-f51.google.com ([209.85.220.51]:43854 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757581AbaJ2Wmp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 18:42:45 -0400
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
Subject: [PATCH 3/4] staging, rtl8192e, LLVMLinux: Remove unused prototype
Date: Wed, 29 Oct 2014 15:42:22 -0700
Message-Id: <1414622543-22969-4-git-send-email-behanw@converseincode.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1414622543-22969-1-git-send-email-behanw@converseincode.com>
References: <1414622543-22969-1-git-send-email-behanw@converseincode.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

MgntQuery_MgntFrameTxRate is only used within rtllib_softmac.c, so it really
should be static instead of extern.

Since it is currently extern a warning is generated because a different
function of the same name is defined staticlly in ieee80211_softmac.c

Removing the incorrect extern declaration and defining the rtllib_softmac
version of this routine static fixes the warning.

Signed-off-by: Behan Webster <behanw@converseincode.com>
Suggested-by: Arnd Bergmann <arnd@arndb.de>
Cc: Arnd Bergmann <arnd@arndb.de>
---
 drivers/staging/rtl8192e/rtllib.h         | 1 -
 drivers/staging/rtl8192e/rtllib_softmac.c | 2 +-
 2 files changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/staging/rtl8192e/rtllib.h b/drivers/staging/rtl8192e/rtllib.h
index 1322782..cef2dc2 100644
--- a/drivers/staging/rtl8192e/rtllib.h
+++ b/drivers/staging/rtl8192e/rtllib.h
@@ -2762,7 +2762,6 @@ extern void rtllib_stop_scan(struct rtllib_device *ieee);
 extern bool rtllib_act_scanning(struct rtllib_device *ieee, bool sync_scan);
 extern void rtllib_stop_scan_syncro(struct rtllib_device *ieee);
 extern void rtllib_start_scan_syncro(struct rtllib_device *ieee, u8 is_mesh);
-extern u8 MgntQuery_MgntFrameTxRate(struct rtllib_device *ieee);
 extern void rtllib_sta_ps_send_null_frame(struct rtllib_device *ieee,
 					  short pwr);
 extern void rtllib_sta_wakeup(struct rtllib_device *ieee, short nl);
diff --git a/drivers/staging/rtl8192e/rtllib_softmac.c b/drivers/staging/rtl8192e/rtllib_softmac.c
index 067a45a..089a058 100644
--- a/drivers/staging/rtl8192e/rtllib_softmac.c
+++ b/drivers/staging/rtl8192e/rtllib_softmac.c
@@ -193,7 +193,7 @@ MgntQuery_TxRateExcludeCCKRates(struct rtllib_device *ieee)
 	return QueryRate;
 }
 
-u8 MgntQuery_MgntFrameTxRate(struct rtllib_device *ieee)
+static u8 MgntQuery_MgntFrameTxRate(struct rtllib_device *ieee)
 {
 	struct rt_hi_throughput *pHTInfo = ieee->pHTInfo;
 	u8 rate;
-- 
1.9.1

