Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755530AbbATQtt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 11:49:49 -0500
Received: from mail-ie0-f175.google.com ([209.85.223.175]:60605 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753252AbbATQlq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 11:41:46 -0500
From: Xunlei Pang <pang.xunlei@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: rtc-linux@googlegroups.com, Thomas Gleixner <tglx@linutronix.de>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Feng Tang <feng.tang@intel.com>, John Stultz <john.stultz@linaro.org>,
        Arnd Bergmann <arnd.bergmann@linaro.org>,
        Xunlei Pang <pang.xunlei@linaro.org>
Subject: [PATCH 3/3] time: clocksource: Add a comment to CLOCK_SOURCE_SUSPEND_NONSTOP
Date: Tue, 20 Jan 2015 16:41:30 +0000
Message-Id: <1421772090-13113-3-git-send-email-pang.xunlei@linaro.org>
X-Mailer: git-send-email 2.2.1
In-Reply-To: <1421772090-13113-1-git-send-email-pang.xunlei@linaro.org>
References: <1421772090-13113-1-git-send-email-pang.xunlei@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When doing timekeeping_resume(), if the nonstop clocksource wraps
back, "cycle_delta" will miss the wrap time.

So add a comment to indicate that if have this flag set, you are
aware that this nonstop clocksource won't wrap during suspension.

Signed-off-by: Xunlei Pang <pang.xunlei@linaro.org>
---
 include/linux/clocksource.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/include/linux/clocksource.h b/include/linux/clocksource.h
index abcafaa..20bca76 100644
--- a/include/linux/clocksource.h
+++ b/include/linux/clocksource.h
@@ -207,6 +207,11 @@ struct clocksource {
 #define CLOCK_SOURCE_WATCHDOG			0x10
 #define CLOCK_SOURCE_VALID_FOR_HRES		0x20
 #define CLOCK_SOURCE_UNSTABLE			0x40
+
+/*
+ * Setting this flag, also means it doesn't wrap back during
+ * system suspend/resume. See timekeeping_resume().
+ */
 #define CLOCK_SOURCE_SUSPEND_NONSTOP		0x80
 #define CLOCK_SOURCE_RESELECT			0x100
 
-- 
1.9.1

