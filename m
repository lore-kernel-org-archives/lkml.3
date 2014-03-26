Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754836AbaCZLXI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2014 07:23:08 -0400
Received: from mail-wg0-f47.google.com ([74.125.82.47]:44340 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753771AbaCZLXG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2014 07:23:06 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: tglx@linutronix.de
Cc: linaro-kernel@lists.linaro.org, linux-kernel@vger.kernel.org,
        fweisbec@gmail.com, linaro-networking@linaro.org,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 13/14] timer: simplify CPU_UP_PREPARE notifier code path
Date: Wed, 26 Mar 2014 16:51:19 +0530
Message-Id: <5d9ab05cbefb2dabe660c5ac57432fc097e06291.1395832156.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <cover.1395832156.git.viresh.kumar@linaro.org>
References: <cover.1395832156.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1395832156.git.viresh.kumar@linaro.org>
References: <cover.1395832156.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently we are returning notifier_from_errno() from CPU_UP_PREPARE notifier
when we detect an error while calling init_timers_cpu(). notifier_from_errno()
already has enough checks within to do something similar. And so we can call it
directly without checking if there was an error or not.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 kernel/timer.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/kernel/timer.c b/kernel/timer.c
index 1d35dda..4360edc 100644
--- a/kernel/timer.c
+++ b/kernel/timer.c
@@ -1646,9 +1646,7 @@ static int timer_cpu_notify(struct notifier_block *self,
 	case CPU_UP_PREPARE:
 	case CPU_UP_PREPARE_FROZEN:
 		err = init_timers_cpu(cpu);
-		if (err < 0)
-			return notifier_from_errno(err);
-		break;
+		return notifier_from_errno(err);
 #ifdef CONFIG_HOTPLUG_CPU
 	case CPU_DEAD:
 	case CPU_DEAD_FROZEN:
-- 
1.7.12.rc2.18.g61b472e

