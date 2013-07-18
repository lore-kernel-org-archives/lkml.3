Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934870Ab3GRXW7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 19:22:59 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:58816 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934808Ab3GRXVl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 19:21:41 -0400
From: Stephen Boyd <sboyd@codeaurora.org>
To: John Stultz <john.stultz@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Russell King <linux@arm.linux.org.uk>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Christopher Covington <cov@codeaurora.org>
Subject: [PATCH v4 17/17] sched_clock: Deprecate setup_sched_clock()
Date: Thu, 18 Jul 2013 16:21:30 -0700
Message-Id: <1374189690-10810-18-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.8.3.3.754.g9c3c367
In-Reply-To: <1374189690-10810-1-git-send-email-sboyd@codeaurora.org>
References: <1374189690-10810-1-git-send-email-sboyd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Users of the generic sched_clock framework should use
sched_clock_register() instead of setup_sched_clock(). Mark the
function as deprecated.

Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 include/linux/sched_clock.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/include/linux/sched_clock.h b/include/linux/sched_clock.h
index cddf0c2..d3da3e2 100644
--- a/include/linux/sched_clock.h
+++ b/include/linux/sched_clock.h
@@ -14,7 +14,8 @@ extern void sched_clock_postinit(void);
 static inline void sched_clock_postinit(void) { }
 #endif
 
-extern void setup_sched_clock(u32 (*read)(void), int bits, unsigned long rate);
+/* Use sched_clock_register() instead */
+extern void __deprecated setup_sched_clock(u32 (*read)(void), int bits, unsigned long rate);
 extern void sched_clock_register(u64 (*read)(void), int bits,
 				 unsigned long rate);
 
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

