Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755070AbaCZLZz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2014 07:25:55 -0400
Received: from mail-wi0-f175.google.com ([209.85.212.175]:56790 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753973AbaCZLWB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2014 07:22:01 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: tglx@linutronix.de
Cc: linaro-kernel@lists.linaro.org, linux-kernel@vger.kernel.org,
        fweisbec@gmail.com, linaro-networking@linaro.org,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 02/14] hrtimer: Coalesce format fragments in printk()
Date: Wed, 26 Mar 2014 16:51:08 +0530
Message-Id: <04223a83cbf1be9cde0b959f61d42dfa9534cf6e.1395832156.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <cover.1395832156.git.viresh.kumar@linaro.org>
References: <cover.1395832156.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1395832156.git.viresh.kumar@linaro.org>
References: <cover.1395832156.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Breaking format fragments into multiple lines hits readability of code. Even if
it goes over 80 column width, its better to keep them together.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 kernel/hrtimer.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
index a1120a0..95243f2 100644
--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -695,8 +695,8 @@ static int hrtimer_switch_to_hres(void)
 
 	if (tick_init_highres()) {
 		local_irq_restore(flags);
-		printk(KERN_WARNING "Could not switch to high resolution "
-				    "mode on CPU %d\n", cpu);
+		printk(KERN_WARNING "Could not switch to high resolution mode on CPU %d\n",
+			cpu);
 		return 0;
 	}
 	base->hres_active = 1;
-- 
1.7.12.rc2.18.g61b472e

