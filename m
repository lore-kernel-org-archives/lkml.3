Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756649AbbAXBoc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 20:44:32 -0500
Received: from mail-pd0-f174.google.com ([209.85.192.174]:57585 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756055AbbAXBoU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 20:44:20 -0500
From: John Stultz <john.stultz@linaro.org>
To: lkml <linux-kernel@vger.kernel.org>
Cc: Xunlei Pang <pang.xunlei@linaro.org>,
        Arnd Bergmann <arnd.bergmann@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        John Stultz <john.stultz@linaro.org>
Subject: [PATCH 7/8] rtc: Remove redundant rtc_valid_tm() from rtc_hctosys()
Date: Fri, 23 Jan 2015 17:43:59 -0800
Message-Id: <1422063840-2837-8-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1422063840-2837-1-git-send-email-john.stultz@linaro.org>
References: <1422063840-2837-1-git-send-email-john.stultz@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Xunlei Pang <pang.xunlei@linaro.org>

rtc_read_time() has already judged valid tm by rtc_valid_tm(),
so just remove it.

Cc: pang.xunlei <pang.xunlei@linaro.org>
Cc: Arnd Bergmann <arnd.bergmann@linaro.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Xunlei Pang <pang.xunlei@linaro.org>
Signed-off-by: John Stultz <john.stultz@linaro.org>
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

