Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751438Ab3EEGgA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 May 2013 02:36:00 -0400
Received: from terminus.zytor.com ([198.137.202.10]:60485 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751320Ab3EEGf6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 May 2013 02:35:58 -0400
Date: Sat, 4 May 2013 23:35:11 -0700
From: tip-bot for Kevin Hilman <tipbot@zytor.com>
Message-ID: <tip-485cf5dac2966b93ef2b6211cf2fd42d66c823e6@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        rusty@rustcorp.com.au, torvalds@linux-foundation.org,
        peterz@infradead.org, srivatsa.bhat@linux.vnet.ibm.com,
        paulmck@linux.vnet.ibm.com, tglx@linutronix.de, khilman@linaro.org,
        magnus.damm@gmail.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, rusty@rustcorp.com.au,
        peterz@infradead.org, srivatsa.bhat@linux.vnet.ibm.com,
        paulmck@linux.vnet.ibm.com, khilman@linaro.org, tglx@linutronix.de,
        magnus.damm@gmail.com
In-Reply-To: <1366849153-25564-1-git-send-email-khilman@linaro.org>
References: <1366849153-25564-1-git-send-email-khilman@linaro.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/urgent] idle: Fix hlt/
 nohlt command-line handling in new generic idle
Git-Commit-ID: 485cf5dac2966b93ef2b6211cf2fd42d66c823e6
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  485cf5dac2966b93ef2b6211cf2fd42d66c823e6
Gitweb:     http://git.kernel.org/tip/485cf5dac2966b93ef2b6211cf2fd42d66c823e6
Author:     Kevin Hilman <khilman@linaro.org>
AuthorDate: Wed, 24 Apr 2013 17:19:13 -0700
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Sun, 5 May 2013 08:29:40 +0200

idle: Fix hlt/nohlt command-line handling in new generic idle

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

Signed-off-by: Kevin Hilman <khilman@linaro.org>
Reviewed-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Paul McKenney <paulmck@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Magnus Damm <magnus.damm@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linaro-kernel@lists.linaro.org
Link: http://lkml.kernel.org/r/1366849153-25564-1-git-send-email-khilman@linaro.org
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/Kconfig | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/Kconfig b/arch/Kconfig
index 99f0e17..3e64403 100644
--- a/arch/Kconfig
+++ b/arch/Kconfig
@@ -213,6 +213,9 @@ config USE_GENERIC_SMP_HELPERS
 config GENERIC_SMP_IDLE_THREAD
        bool
 
+config GENERIC_IDLE_POLL_SETUP
+       bool
+
 # Select if arch init_task initializer is different to init/init_task.c
 config ARCH_INIT_TASK
        bool
