Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755858AbaDNQ1j (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 12:27:39 -0400
Received: from mail-pd0-f170.google.com ([209.85.192.170]:54279 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753360AbaDNQ1e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 12:27:34 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: tglx@linutronix.de
Cc: linaro-kernel@lists.linaro.org, linux-kernel@vger.kernel.org,
        fweisbec@gmail.com, Arvind.Chauhan@arm.com,
        linaro-networking@linaro.org, Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 30/38] tick-sched: move nohz_full_buf[] inside tick_nohz_init()
Date: Mon, 14 Apr 2014 21:53:52 +0530
Message-Id: <b9bb3a40fc7a973438a54ddab8e1c89c6c66dd8c.1397492345.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <cover.1397492345.git.viresh.kumar@linaro.org>
References: <cover.1397492345.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1397492345.git.viresh.kumar@linaro.org>
References: <cover.1397492345.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

nohz_full_buf[] is used at only one place, i.e. inside tick_nohz_init(). Make it
a local variable. Can move it out in case it is used in some other routines in
future.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 kernel/time/tick-sched.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index d8b9a69..22b9505 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -321,13 +321,6 @@ static int tick_nohz_cpu_down_callback(struct notifier_block *nfb,
 	return NOTIFY_OK;
 }
 
-/*
- * Worst case string length in chunks of CPU range seems 2 steps
- * separations: 0,2,4,6,...
- * This is NR_CPUS + sizeof('\0')
- */
-static char __initdata nohz_full_buf[NR_CPUS + 1];
-
 static int tick_nohz_init_all(void)
 {
 	int err = -1;
@@ -347,6 +340,12 @@ static int tick_nohz_init_all(void)
 
 void __init tick_nohz_init(void)
 {
+	/*
+	 * Worst case string length in chunks of CPU range seems 2 steps
+	 * separations: 0,2,4,6,...
+	 * This is NR_CPUS + sizeof('\0')
+	 */
+	char nohz_full_buf[NR_CPUS + 1];
 	int cpu;
 
 	if (!tick_nohz_full_running) {
-- 
1.7.12.rc2.18.g61b472e

