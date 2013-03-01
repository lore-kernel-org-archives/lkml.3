Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751944Ab3CAQJq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 11:09:46 -0500
Received: from mail-qc0-f170.google.com ([209.85.216.170]:36322 "EHLO
	mail-qc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751697Ab3CAQJo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 11:09:44 -0500
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Li Zhong <zhong@linux.vnet.ibm.com>, Kevin Hilman <khilman@linaro.org>,
        Mats Liljegren <mats.liljegren@enea.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 5/5] context_tracking: Enable probes by default for selftesting
Date: Fri,  1 Mar 2013 17:08:59 +0100
Message-Id: <1362154139-1139-6-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1362154139-1139-1-git-send-email-fweisbec@gmail.com>
References: <1362154139-1139-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Until we provide the nohz_mask boot parameter, keeping
the context tracking probes disabled by default is pointless
since what we want is to runtime test this code anyway.

It's furthermore confusing for the users which don't expect
the probes to be off when they select RCU user mode or full
dynticks cputime accounting.

Let's enable these probes selftests by default for now.

Suggested: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Li Zhong <zhong@linux.vnet.ibm.com>
Cc: Kevin Hilman <khilman@linaro.org>
Cc: Mats Liljegren <mats.liljegren@enea.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Namhyung Kim <namhyung.kim@lge.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
---
 init/Kconfig |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/init/Kconfig b/init/Kconfig
index 7000d96..55e376b 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -536,6 +536,7 @@ config RCU_USER_QS
 config CONTEXT_TRACKING_FORCE
 	bool "Force context tracking"
 	depends on CONTEXT_TRACKING
+	default CONTEXT_TRACKING
 	help
 	  Probe on user/kernel boundaries by default in order to
 	  test the features that rely on it such as userspace RCU extended
-- 
1.7.5.4

