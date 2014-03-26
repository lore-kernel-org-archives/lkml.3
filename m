Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754666AbaCZLWq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2014 07:22:46 -0400
Received: from mail-wg0-f49.google.com ([74.125.82.49]:43741 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754320AbaCZLWm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2014 07:22:42 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: tglx@linutronix.de
Cc: linaro-kernel@lists.linaro.org, linux-kernel@vger.kernel.org,
        fweisbec@gmail.com, linaro-networking@linaro.org,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 09/14] hrtimer: don't check state of base->hres_active in hrtimer_switch_to_hres()
Date: Wed, 26 Mar 2014 16:51:15 +0530
Message-Id: <7a90f7e3c9f448b23ad0888091cd56ba8e2652d3.1395832156.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <cover.1395832156.git.viresh.kumar@linaro.org>
References: <cover.1395832156.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1395832156.git.viresh.kumar@linaro.org>
References: <cover.1395832156.git.viresh.kumar@linaro.org>
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
index 5b3b212..e6e1255 100644
--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -685,9 +685,6 @@ static int hrtimer_switch_to_hres(void)
 	struct hrtimer_cpu_base *base = &per_cpu(hrtimer_bases, cpu);
 	unsigned long flags;
 
-	if (base->hres_active)
-		return 1;
-
 	local_irq_save(flags);
 
 	if (tick_init_highres()) {
-- 
1.7.12.rc2.18.g61b472e

