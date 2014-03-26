Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754621AbaCZLWh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2014 07:22:37 -0400
Received: from mail-we0-f175.google.com ([74.125.82.175]:62962 "EHLO
	mail-we0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754320AbaCZLWa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2014 07:22:30 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: tglx@linutronix.de
Cc: linaro-kernel@lists.linaro.org, linux-kernel@vger.kernel.org,
        fweisbec@gmail.com, linaro-networking@linaro.org,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 07/14] hrtimer: use base->hres_active directly instead of hrtimer_hres_active()
Date: Wed, 26 Mar 2014 16:51:13 +0530
Message-Id: <66f4cd9641551d97251e89d792053fbacd4a812f.1395832156.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <cover.1395832156.git.viresh.kumar@linaro.org>
References: <cover.1395832156.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1395832156.git.viresh.kumar@linaro.org>
References: <cover.1395832156.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

retrigger_next_event() is defined within #ifdef CONFIG_HIGH_RES_TIMERS and we
already have pointer to base available. So it makes more sense to simply use
base->hres_active instead of doing this by calling hrtimer_hres_active():

	__this_cpu_read(hrtimer_bases.hres_active)

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 kernel/hrtimer.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
index 32d1504..cb485b9 100644
--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -667,7 +667,7 @@ static void retrigger_next_event(void *arg)
 {
 	struct hrtimer_cpu_base *base = &__get_cpu_var(hrtimer_bases);
 
-	if (!hrtimer_hres_active())
+	if (!base->hres_active)
 		return;
 
 	raw_spin_lock(&base->lock);
-- 
1.7.12.rc2.18.g61b472e

