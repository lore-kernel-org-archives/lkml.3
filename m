Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751635AbaC0FXu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2014 01:23:50 -0400
Received: from mail-wg0-f46.google.com ([74.125.82.46]:33999 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750771AbaC0FXs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2014 01:23:48 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: tglx@linutronix.de
Cc: linaro-kernel@lists.linaro.org, linux-kernel@vger.kernel.org,
        fweisbec@gmail.com, linaro-networking@linaro.org,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 1/2] hrtimer: don't add clock-base to active_bases if already present
Date: Thu, 27 Mar 2014 10:53:36 +0530
Message-Id: <3c77c9453e42b7a914c15ef67a8ee142d3543a48.1395897612.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <cover.1395832156.git.viresh.kumar@linaro.org>
References: <cover.1395832156.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If active_bases already has entry for a particular clock type, then we don't
need to rewrite it while queuing a hrtimer.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
Initially I thought of doing this but then thought better remove active_bases
completely and so didn't sent this one. Now it might find some place for itself
:).

 kernel/hrtimer.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
index da351ad..acfef5f 100644
--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -864,8 +864,9 @@ static int enqueue_hrtimer(struct hrtimer *timer,
 {
 	debug_activate(timer);
 
+	if (!timerqueue_getnext(&base->active))
+		base->cpu_base->active_bases |= 1 << base->index;
 	timerqueue_add(&base->active, &timer->node);
-	base->cpu_base->active_bases |= 1 << base->index;
 
 	/*
 	 * HRTIMER_STATE_ENQUEUED is or'ed to the current state to preserve the
-- 
1.7.12.rc2.18.g61b472e

