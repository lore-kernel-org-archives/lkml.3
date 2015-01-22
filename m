Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752477AbbAVMCn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 07:02:43 -0500
Received: from mail-qa0-f46.google.com ([209.85.216.46]:40635 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751854AbbAVMC0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 07:02:26 -0500
From: Xunlei Pang <pang.xunlei@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: rtc-linux@googlegroups.com, Thomas Gleixner <tglx@linutronix.de>,
        Alessandro Zummo <a.zummo@towertech.it>,
        John Stultz <john.stultz@linaro.org>,
        Arnd Bergmann <arnd.bergmann@linaro.org>,
        Xunlei Pang <pang.xunlei@linaro.org>
Subject: [PATCH v2 2/3] rtc: Remove redundant rtc_valid_tm() from rtc_resume()
Date: Thu, 22 Jan 2015 12:01:16 +0000
Message-Id: <1421928077-4698-2-git-send-email-pang.xunlei@linaro.org>
X-Mailer: git-send-email 2.2.1
In-Reply-To: <1421928077-4698-1-git-send-email-pang.xunlei@linaro.org>
References: <1421928077-4698-1-git-send-email-pang.xunlei@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

rtc_read_time() has already judged valid tm by rtc_valid_tm(),
so just remove it.

Signed-off-by: Xunlei Pang <pang.xunlei@linaro.org>
---
 drivers/rtc/class.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/rtc/class.c b/drivers/rtc/class.c
index 6100af5..7db4c90 100644
--- a/drivers/rtc/class.c
+++ b/drivers/rtc/class.c
@@ -117,10 +117,6 @@ static int rtc_resume(struct device *dev)
 		return 0;
 	}
 
-	if (rtc_valid_tm(&tm) != 0) {
-		pr_debug("%s:  bogus resume time\n", dev_name(&rtc->dev));
-		return 0;
-	}
 	new_rtc.tv_sec = rtc_tm_to_time64(&tm);
 	new_rtc.tv_nsec = 0;
 
-- 
1.9.1

