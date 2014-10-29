Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757658AbaJ2Wmp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 18:42:45 -0400
Received: from mail-pa0-f49.google.com ([209.85.220.49]:51015 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757482AbaJ2Wmm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 18:42:42 -0400
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
Subject: [PATCH 2/4] staging, rtl8192e, LLVMLinux: Remove unused inline prototype
Date: Wed, 29 Oct 2014 15:42:21 -0700
Message-Id: <1414622543-22969-3-git-send-email-behanw@converseincode.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1414622543-22969-1-git-send-email-behanw@converseincode.com>
References: <1414622543-22969-1-git-send-email-behanw@converseincode.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

rtllib_probe_req is defined as "static inline" in rtllib_softmac.c however it
is declared differently as "extern inline" in rtllib_softmac.h. Since it isn't
used outside of the scope of rtllib_softmac, it makes sense to remove the
incorrect declaration.

Signed-off-by: Behan Webster <behanw@converseincode.com>
Suggested-by: Arnd Bergmann <arnd@arndb.de>
Cc: Arnd Bergmann <arnd@arndb.de>
---
 drivers/staging/rtl8192e/rtllib.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/staging/rtl8192e/rtllib.h b/drivers/staging/rtl8192e/rtllib.h
index 33995ac..1322782 100644
--- a/drivers/staging/rtl8192e/rtllib.h
+++ b/drivers/staging/rtl8192e/rtllib.h
@@ -2762,7 +2762,6 @@ extern void rtllib_stop_scan(struct rtllib_device *ieee);
 extern bool rtllib_act_scanning(struct rtllib_device *ieee, bool sync_scan);
 extern void rtllib_stop_scan_syncro(struct rtllib_device *ieee);
 extern void rtllib_start_scan_syncro(struct rtllib_device *ieee, u8 is_mesh);
-extern inline struct sk_buff *rtllib_probe_req(struct rtllib_device *ieee);
 extern u8 MgntQuery_MgntFrameTxRate(struct rtllib_device *ieee);
 extern void rtllib_sta_ps_send_null_frame(struct rtllib_device *ieee,
 					  short pwr);
-- 
1.9.1

