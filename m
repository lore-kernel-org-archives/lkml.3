Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753870Ab3GWAbi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 20:31:38 -0400
Received: from mail-wg0-f53.google.com ([74.125.82.53]:48799 "EHLO
	mail-wg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753611Ab3GWAbX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 20:31:23 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Stephane Eranian <eranian@google.com>, Don Zickus <dzickus@redhat.com>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Anish Singh <anish198519851985@gmail.com>
Subject: [PATCH 8/8] watchdog: Remove hack to make full dynticks working
Date: Tue, 23 Jul 2013 02:31:06 +0200
Message-Id: <1374539466-4799-9-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1374539466-4799-1-git-send-email-fweisbec@gmail.com>
References: <1374539466-4799-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A perf event can be used without forcing the tick to
stay alive if it doesn't use a frequency but a sample
period and if it doesn't throttle (raise storm of events).

Since the lockup detector neither use a perf event frequency
nor should ever throttle due to its high period, it can now
run concurrently with the full dynticks feature.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Stephane Eranian <eranian@google.com>
Cc: Don Zickus <dzickus@redhat.com>
Cc: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
Cc: Anish Singh <anish198519851985@gmail.com>
---
 kernel/watchdog.c |    8 --------
 1 files changed, 0 insertions(+), 8 deletions(-)

diff --git a/kernel/watchdog.c b/kernel/watchdog.c
index 1241d8c..51c4f34 100644
--- a/kernel/watchdog.c
+++ b/kernel/watchdog.c
@@ -553,14 +553,6 @@ void __init lockup_detector_init(void)
 {
 	set_sample_period();
 
-#ifdef CONFIG_NO_HZ_FULL
-	if (watchdog_user_enabled) {
-		watchdog_user_enabled = 0;
-		pr_warning("Disabled lockup detectors by default for full dynticks\n");
-		pr_warning("You can reactivate it with 'sysctl -w kernel.watchdog=1'\n");
-	}
-#endif
-
 	if (watchdog_user_enabled)
 		watchdog_enable_all_cpus();
 }
-- 
1.7.5.4

