Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753663AbaA0G0e (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 01:26:34 -0500
Received: from relais.videotron.ca ([24.201.245.36]:51663 "EHLO
	relais.videotron.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753402AbaA0GYO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 01:24:14 -0500
X-Greylist: delayed 901 seconds by postgrey-1.27 at vger.kernel.org; Mon, 27 Jan 2014 01:24:12 EST
Content-transfer-encoding: 7BIT
From: Nicolas Pitre <nicolas.pitre@linaro.org>
To: Russell King <linux@arm.linux.org.uk>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mundt <lethal@linux-sh.org>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linuxppc-dev@lists.ozlabs.org, linux-sh@vger.kernel.org,
        linux-pm@vger.kernel.org, linaro-kernel@lists.linaro.org
Subject: [PATCH 3/9] idle: no more arch_cpu_idle_prepare() users
Date: Mon, 27 Jan 2014 01:08:18 -0500
Message-id: <1390802904-28399-4-git-send-email-nicolas.pitre@linaro.org>
X-Mailer: git-send-email 1.8.4.108.g55ea5f6
In-reply-to: <1390802904-28399-1-git-send-email-nicolas.pitre@linaro.org>
References: <1390802904-28399-1-git-send-email-nicolas.pitre@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

... so we can get rid of it entirely.

Signed-off-by: Nicolas Pitre <nico@linaro.org>
---
 include/linux/cpu.h | 1 -
 kernel/cpu/idle.c   | 2 --
 2 files changed, 3 deletions(-)

diff --git a/include/linux/cpu.h b/include/linux/cpu.h
index 03e235ad1b..218fab7521 100644
--- a/include/linux/cpu.h
+++ b/include/linux/cpu.h
@@ -221,7 +221,6 @@ void cpu_idle(void);
 void cpu_idle_poll_ctrl(bool enable);
 
 void arch_cpu_idle(void);
-void arch_cpu_idle_prepare(void);
 void arch_cpu_idle_enter(void);
 void arch_cpu_idle_exit(void);
 void arch_cpu_idle_dead(void);
diff --git a/kernel/cpu/idle.c b/kernel/cpu/idle.c
index 988573a9a3..4e327e211b 100644
--- a/kernel/cpu/idle.c
+++ b/kernel/cpu/idle.c
@@ -52,7 +52,6 @@ static inline int cpu_idle_poll(void)
 }
 
 /* Weak implementations for optional arch specific functions */
-void __weak arch_cpu_idle_prepare(void) { }
 void __weak arch_cpu_idle_enter(void) { }
 void __weak arch_cpu_idle_exit(void) { }
 void __weak arch_cpu_idle_dead(void) { }
@@ -136,6 +135,5 @@ void cpu_startup_entry(enum cpuhp_state state)
 	boot_init_stack_canary();
 #endif
 	__current_set_polling();
-	arch_cpu_idle_prepare();
 	cpu_idle_loop();
 }
-- 
1.8.4.108.g55ea5f6

