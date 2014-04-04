Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752442AbaDDGlJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2014 02:41:09 -0400
Received: from mail-wg0-f46.google.com ([74.125.82.46]:64525 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752122AbaDDGk3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2014 02:40:29 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: tglx@linutronix.de
Cc: linaro-kernel@lists.linaro.org, fweisbec@gmail.com,
        linaro-networking@linaro.org, Arvind.Chauhan@arm.com,
        linux-kernel@vger.kernel.org, Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH V2 07/36] hrtimer: replace sizeof(struct hrtimer) with sizeof(*timer)
Date: Fri,  4 Apr 2014 12:05:50 +0530
Message-Id: <67b891e708df0147862e9107c6d920c9b9e9065b.1396592516.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <cover.1396592516.git.viresh.kumar@linaro.org>
References: <cover.1396592516.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1396592516.git.viresh.kumar@linaro.org>
References: <cover.1396592516.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linux coding guidelines says:

The preferred form for passing a size of a struct is the following:
	p = kmalloc(sizeof(*p), ...);

But __hrtimer_init() wasn't following that. Fix it.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 kernel/hrtimer.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
index f6b1968..db580ab 100644
--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -1166,7 +1166,7 @@ static void __hrtimer_init(struct hrtimer *timer, clockid_t clock_id,
 	struct hrtimer_cpu_base *cpu_base;
 	int base;
 
-	memset(timer, 0, sizeof(struct hrtimer));
+	memset(timer, 0, sizeof(*timer));
 
 	cpu_base = &__raw_get_cpu_var(hrtimer_bases);
 
-- 
1.7.12.rc2.18.g61b472e

