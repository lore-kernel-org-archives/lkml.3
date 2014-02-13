Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754568AbaBMMAV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 07:00:21 -0500
Received: from cpsmtpb-ews10.kpnxchange.com ([213.75.39.15]:53079 "EHLO
	cpsmtpb-ews10.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753284AbaBMMAU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 07:00:20 -0500
Message-ID: <1392292818.14949.5.camel@x220>
Subject: [PATCH] staging: r8188eu: Remove dead code
From: Paul Bolle <pebolle@tiscali.nl>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Date: Thu, 13 Feb 2014 13:00:18 +0100
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.3 (3.10.3-1.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 13 Feb 2014 12:00:19.0253 (UTC) FILETIME=[2A64A650:01CF28B3]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are a few lines in this driver that depend on a macro
CONFIG_BT_COEXIST. But there's no Kconfig symbol of that name nor is
there a preprocessor define for that string. So remove these lines.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
Entirely untested.

Fun fact: two years ago, code depending on the same undefined macro was
removed from rtl8192cu, see commit 9ef11f7b34c0 ("rtl8192cu: Remove dead
code never selected"). I wonder where this macro originated.

 drivers/staging/rtl8188eu/include/rtw_debug.h   | 10 ----------
 drivers/staging/rtl8188eu/include/rtw_pwrctrl.h |  4 ----
 2 files changed, 14 deletions(-)

diff --git a/drivers/staging/rtl8188eu/include/rtw_debug.h b/drivers/staging/rtl8188eu/include/rtw_debug.h
index c6b193a..7cd61b2 100644
--- a/drivers/staging/rtl8188eu/include/rtw_debug.h
+++ b/drivers/staging/rtl8188eu/include/rtw_debug.h
@@ -277,14 +277,4 @@ int proc_get_rssi_disp(char *page, char **start,
 int proc_set_rssi_disp(struct file *file, const char __user *buffer,
 		       unsigned long count, void *data);
 
-#ifdef CONFIG_BT_COEXIST
-int proc_get_btcoex_dbg(char *page, char **start,
-			off_t offset, int count,
-			int *eof, void *data);
-
-int proc_set_btcoex_dbg(struct file *file, const char *buffer,
-			signed long count, void *data);
-
-#endif /* CONFIG_BT_COEXIST */
-
 #endif	/* __RTW_DEBUG_H__ */
diff --git a/drivers/staging/rtl8188eu/include/rtw_pwrctrl.h b/drivers/staging/rtl8188eu/include/rtw_pwrctrl.h
index 4a0e9ff..9a42859 100644
--- a/drivers/staging/rtl8188eu/include/rtw_pwrctrl.h
+++ b/drivers/staging/rtl8188eu/include/rtw_pwrctrl.h
@@ -206,10 +206,6 @@ struct pwrctrl_priv {
 
 	u8		bInternalAutoSuspend;
 	u8		bInSuspend;
-#ifdef	CONFIG_BT_COEXIST
-	u8		bAutoResume;
-	u8		autopm_cnt;
-#endif
 	u8		bSupportRemoteWakeup;
 	struct timer_list pwr_state_check_timer;
 	int		pwr_state_check_interval;
-- 
1.8.5.3

