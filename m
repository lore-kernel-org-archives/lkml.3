Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752548AbaDDGlW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2014 02:41:22 -0400
Received: from mail-wi0-f180.google.com ([209.85.212.180]:63956 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752374AbaDDGlE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2014 02:41:04 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: tglx@linutronix.de
Cc: linaro-kernel@lists.linaro.org, fweisbec@gmail.com,
        linaro-networking@linaro.org, Arvind.Chauhan@arm.com,
        linux-kernel@vger.kernel.org, Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH V2 13/36] hrtimer: don't check state of base->hres_active in hrtimer_switch_to_hres()
Date: Fri,  4 Apr 2014 12:05:56 +0530
Message-Id: <2e8b55ff1b131d924d8ede95ac1bccdba24c5ba0.1396592516.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <cover.1396592516.git.viresh.kumar@linaro.org>
References: <cover.1396592516.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1396592516.git.viresh.kumar@linaro.org>
References: <cover.1396592516.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Caller of hrtimer_switch_to_hres(), i.e. hrtimer_run_pending(), has already
verified this by calling hrtimer_hres_active() and so we don't need to do it
again in hrtimer_switch_to_hres().

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 kernel/hrtimer.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
index ad5b7ba..476ad5d 100644
--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -690,9 +690,6 @@ static int hrtimer_switch_to_hres(void)
 	struct hrtimer_cpu_base *base = &per_cpu(hrtimer_bases, cpu);
 	unsigned long flags;
 
-	if (base->hres_active)
-		return 1;
-
 	local_irq_save(flags);
 
 	if (tick_init_highres()) {
-- 
1.7.12.rc2.18.g61b472e

