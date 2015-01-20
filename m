Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754826AbbATQlt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 11:41:49 -0500
Received: from mail-ie0-f176.google.com ([209.85.223.176]:47571 "EHLO
	mail-ie0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754448AbbATQlp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 11:41:45 -0500
From: Xunlei Pang <pang.xunlei@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: rtc-linux@googlegroups.com, Thomas Gleixner <tglx@linutronix.de>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Feng Tang <feng.tang@intel.com>, John Stultz <john.stultz@linaro.org>,
        Arnd Bergmann <arnd.bergmann@linaro.org>,
        Xunlei Pang <pang.xunlei@linaro.org>
Subject: [PATCH 2/3] rtc: Remove redundant rtc_valid_tm() from rtc_resume()
Date: Tue, 20 Jan 2015 16:41:29 +0000
Message-Id: <1421772090-13113-2-git-send-email-pang.xunlei@linaro.org>
X-Mailer: git-send-email 2.2.1
In-Reply-To: <1421772090-13113-1-git-send-email-pang.xunlei@linaro.org>
References: <1421772090-13113-1-git-send-email-pang.xunlei@linaro.org>
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
index c8f35a5..5953225 100644
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

