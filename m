Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751793Ab3IRC6C (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Sep 2013 22:58:02 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:48297 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751218Ab3IRC6B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Sep 2013 22:58:01 -0400
Message-ID: <5239167D.7090404@huawei.com>
Date: Wed, 18 Sep 2013 10:57:01 +0800
From: Xie XiuQi <xiexiuqi@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130307 Thunderbird/17.0.4
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: John Stultz <john.stultz@linaro.org>, Ingo Molnar <mingo@elte.hu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH v2] clocksource: fix misleading comment for __clocksource_updatefreq_scale()
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.69.18]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Functions clocksource_updatefreq_hz() and clocksource_updatefreq_khz()
mentioned in the comment of __clocksource_updatefreq_scale() do not exist.

As Thomas Gleixner's suggestion, I renamed the functions and the few call
sites because the underscores are completely meaningless.

Signed-off-by: Xie XiuQi <xiexiuqi@huawei.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
---
 drivers/clocksource/cadence_ttc_timer.c | 2 +-
 drivers/clocksource/em_sti.c            | 2 +-
 drivers/clocksource/sh_cmt.c            | 2 +-
 drivers/clocksource/sh_tmu.c            | 2 +-
 include/linux/clocksource.h             | 4 ++--
 5 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/clocksource/cadence_ttc_timer.c b/drivers/clocksource/cadence_ttc_timer.c
index 4cbe28c..05f00e7 100644
--- a/drivers/clocksource/cadence_ttc_timer.c
+++ b/drivers/clocksource/cadence_ttc_timer.c
@@ -226,7 +226,7 @@ static int ttc_rate_change_clocksource_cb(struct notifier_block *nb,
 		 * Do whatever is necessary to maintain a proper time base
 		 *
 		 * I cannot find a way to adjust the currently used clocksource
-		 * to the new frequency. __clocksource_updatefreq_hz() sounds
+		 * to the new frequency. clocksource_updatefreq_hz() sounds
 		 * good, but does not work. Not sure what's that missing.
 		 *
 		 * This approach works, but triggers two clocksource switches.
diff --git a/drivers/clocksource/em_sti.c b/drivers/clocksource/em_sti.c
index 4329a29..ccbb513 100644
--- a/drivers/clocksource/em_sti.c
+++ b/drivers/clocksource/em_sti.c
@@ -210,7 +210,7 @@ static int em_sti_clocksource_enable(struct clocksource *cs)

 	ret = em_sti_start(p, USER_CLOCKSOURCE);
 	if (!ret)
-		__clocksource_updatefreq_hz(cs, p->rate);
+		clocksource_updatefreq_hz(cs, p->rate);
 	return ret;
 }

diff --git a/drivers/clocksource/sh_cmt.c b/drivers/clocksource/sh_cmt.c
index 08d0c41..dc812c5 100644
--- a/drivers/clocksource/sh_cmt.c
+++ b/drivers/clocksource/sh_cmt.c
@@ -504,7 +504,7 @@ static int sh_cmt_clocksource_enable(struct clocksource *cs)

 	ret = sh_cmt_start(p, FLAG_CLOCKSOURCE);
 	if (!ret) {
-		__clocksource_updatefreq_hz(cs, p->rate);
+		clocksource_updatefreq_hz(cs, p->rate);
 		p->cs_enabled = true;
 	}
 	return ret;
diff --git a/drivers/clocksource/sh_tmu.c b/drivers/clocksource/sh_tmu.c
index 78b8dae..be4ae3e 100644
--- a/drivers/clocksource/sh_tmu.c
+++ b/drivers/clocksource/sh_tmu.c
@@ -236,7 +236,7 @@ static int sh_tmu_clocksource_enable(struct clocksource *cs)

 	ret = sh_tmu_enable(p);
 	if (!ret) {
-		__clocksource_updatefreq_hz(cs, p->rate);
+		clocksource_updatefreq_hz(cs, p->rate);
 		p->cs_enabled = true;
 	}

diff --git a/include/linux/clocksource.h b/include/linux/clocksource.h
index dbbf8aa..87e8aa0 100644
--- a/include/linux/clocksource.h
+++ b/include/linux/clocksource.h
@@ -314,12 +314,12 @@ static inline int clocksource_register_khz(struct clocksource *cs, u32 khz)
 	return __clocksource_register_scale(cs, 1000, khz);
 }

-static inline void __clocksource_updatefreq_hz(struct clocksource *cs, u32 hz)
+static inline void clocksource_updatefreq_hz(struct clocksource *cs, u32 hz)
 {
 	__clocksource_updatefreq_scale(cs, 1, hz);
 }

-static inline void __clocksource_updatefreq_khz(struct clocksource *cs, u32 khz)
+static inline void clocksource_updatefreq_khz(struct clocksource *cs, u32 khz)
 {
 	__clocksource_updatefreq_scale(cs, 1000, khz);
 }
-- 
1.8.2.1


