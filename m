Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753043AbaDDGnU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2014 02:43:20 -0400
Received: from mail-wi0-f179.google.com ([209.85.212.179]:50832 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753006AbaDDGnN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2014 02:43:13 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: tglx@linutronix.de
Cc: linaro-kernel@lists.linaro.org, fweisbec@gmail.com,
        linaro-networking@linaro.org, Arvind.Chauhan@arm.com,
        linux-kernel@vger.kernel.org, Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH V2 35/36] timer: simplify CPU_UP_PREPARE notifier code path
Date: Fri,  4 Apr 2014 12:06:18 +0530
Message-Id: <17837b2835498eba99afc173daf33771816bf141.1396592516.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <cover.1396592516.git.viresh.kumar@linaro.org>
References: <cover.1396592516.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1396592516.git.viresh.kumar@linaro.org>
References: <cover.1396592516.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently we are returning notifier_from_errno() from CPU_UP_PREPARE notifier
when we detect there is an error while calling init_timers_cpu().
notifier_from_errno() already has enough checks within to do something similar.
And so we can call it directly without checking if there was an error or not.

Reviewed-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
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

