Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754592AbbAVCcY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 21:32:24 -0500
Received: from mail-qc0-f181.google.com ([209.85.216.181]:35307 "EHLO
	mail-qc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754355AbbAVCcI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 21:32:08 -0500
From: Xunlei Pang <pang.xunlei@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: rtc-linux@googlegroups.com, Thomas Gleixner <tglx@linutronix.de>,
        Alessandro Zummo <a.zummo@towertech.it>,
        John Stultz <john.stultz@linaro.org>,
        Arnd Bergmann <arnd.bergmann@linaro.org>,
        Xunlei Pang <pang.xunlei@linaro.org>
Subject: [PATCH 4/5] rtc: Remove redundant rtc_valid_tm() from rtc_hctosys()
Date: Thu, 22 Jan 2015 02:31:54 +0000
Message-Id: <1421893915-19309-4-git-send-email-pang.xunlei@linaro.org>
X-Mailer: git-send-email 2.2.1
In-Reply-To: <1421893915-19309-1-git-send-email-pang.xunlei@linaro.org>
References: <1421893915-19309-1-git-send-email-pang.xunlei@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

rtc_read_time() has already judged valid tm by rtc_valid_tm(),
so just remove it.

Reviewed-by: John Stultz <john.stultz@linaro.org>
Reviewed-by: Arnd Bergmann <arnd.bergmann@linaro.org>
Signed-off-by: Xunlei Pang <pang.xunlei@linaro.org>
---
 drivers/rtc/hctosys.c | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/drivers/rtc/hctosys.c b/drivers/rtc/hctosys.c
index 2153b52..6c719f2 100644
--- a/drivers/rtc/hctosys.c
+++ b/drivers/rtc/hctosys.c
@@ -45,13 +45,6 @@ static int __init rtc_hctosys(void)
 
 	}
 
-	err = rtc_valid_tm(&tm);
-	if (err) {
-		dev_err(rtc->dev.parent,
-			"hctosys: invalid date/time\n");
-		goto err_invalid;
-	}
-
 	tv64.tv_sec = rtc_tm_to_time64(&tm);
 
 	err = do_settimeofday64(&tv64);
@@ -63,7 +56,6 @@ static int __init rtc_hctosys(void)
 		tm.tm_hour, tm.tm_min, tm.tm_sec,
 		(long long) tv64.tv_sec);
 
-err_invalid:
 err_read:
 	rtc_class_close(rtc);
 
-- 
1.9.1

