Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758660Ab3DYATT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Apr 2013 20:19:19 -0400
Received: from mail-da0-f45.google.com ([209.85.210.45]:55858 "EHLO
	mail-da0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758605Ab3DYATR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Apr 2013 20:19:17 -0400
From: Kevin Hilman <khilman@linaro.org>
To: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, linaro-kernel@lists.linaro.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Magnus Damm <magnus.damm@gmail.com>
Subject: [PATCH] idle: fix hlt/nohlt command-line handling in new generic idle
Date: Wed, 24 Apr 2013 17:19:13 -0700
Message-Id: <1366849153-25564-1-git-send-email-khilman@linaro.org>
X-Mailer: git-send-email 1.8.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit d1669912 (idle: Implement generic idle function) added a new
generic idle along with support for hlt/nohlt command line options to
override default idle loop behavior.  However, the command-line
processing is never compiled.

The command-line handling is wrapped by CONFIG_GENERIC_IDLE_POLL_SETUP
and arches that use this feature select it in their Kconfigs.
However, no Kconfig definition was created for this option, so it is
never enabled, and therefore command-line override of the idle-loop
behavior is broken after migrating to the generic idle loop.

To fix, add a Kconfig definition for GENERIC_IDLE_POLL_SETUP.

Tested on ARM (OMAP4/Panda) which enables the command-line overrides
by default.

Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Paul McKenney <paulmck@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
Cc: Magnus Damm <magnus.damm@gmail.com>
Signed-off-by: Kevin Hilman <khilman@linaro.org>
---
Applies on tip/smp/hotplug where generic idle feature is added

 arch/Kconfig | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/Kconfig b/arch/Kconfig
index 1455579..e0ef57b 100644
--- a/arch/Kconfig
+++ b/arch/Kconfig
@@ -216,6 +216,9 @@ config USE_GENERIC_SMP_HELPERS
 config GENERIC_SMP_IDLE_THREAD
        bool
 
+config GENERIC_IDLE_POLL_SETUP
+       bool
+
 # Select if arch init_task initializer is different to init/init_task.c
 config ARCH_INIT_TASK
        bool
-- 
1.8.2

