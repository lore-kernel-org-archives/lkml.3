Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752687AbaDDGly (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2014 02:41:54 -0400
Received: from mail-wg0-f52.google.com ([74.125.82.52]:33526 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752633AbaDDGlq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2014 02:41:46 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: tglx@linutronix.de
Cc: linaro-kernel@lists.linaro.org, fweisbec@gmail.com,
        linaro-networking@linaro.org, Arvind.Chauhan@arm.com,
        linux-kernel@vger.kernel.org, Viresh Kumar <viresh.kumar@linaro.org>,
        Ingo Molnar <mingo@redhat.com>
Subject: [PATCH V2 20/36] hrtimer: replace base by new_base to get resolution: __hrtimer_start_range_ns()
Date: Fri,  4 Apr 2014 12:06:03 +0530
Message-Id: <20dfe3ddd26b9c52d362a9e9178e5b15f78f7ebe.1396592516.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <cover.1396592516.git.viresh.kumar@linaro.org>
References: <cover.1396592516.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1396592516.git.viresh.kumar@linaro.org>
References: <cover.1396592516.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This code was added long back by following commit:

	commit 06027bdd278a32a84b273e41db68a5db8ffd2bb6
	Author: Ingo Molnar <mingo@elte.hu>
	Date:   Tue Feb 14 13:53:15 2006 -0800

	    [PATCH] hrtimer: round up relative start time on low-res arches

Don't know if it was a mistake or was intentional. But probably we must use
new_base instead of base here to get resolution. Things might be working
smoothly as resolution might be same for both the bases in most of the cases.

Also commit log of above commit has this: "This will go away with the GTOD
framework". So, should we get this removed?

Cc: Ingo Molnar <mingo@redhat.com>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 kernel/hrtimer.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
index 2ac423d..458b952 100644
--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -964,7 +964,7 @@ int __hrtimer_start_range_ns(struct hrtimer *timer, ktime_t tim,
 		 * timeouts. This will go away with the GTOD framework.
 		 */
 #ifdef CONFIG_TIME_LOW_RES
-		tim = ktime_add_safe(tim, base->resolution);
+		tim = ktime_add_safe(tim, new_base->resolution);
 #endif
 	}
 
-- 
1.7.12.rc2.18.g61b472e

