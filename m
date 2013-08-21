Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752490Ab3HUQo7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 12:44:59 -0400
Received: from mail-we0-f182.google.com ([74.125.82.182]:59294 "EHLO
	mail-we0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751898Ab3HUQo6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 12:44:58 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        John Stultz <john.stultz@linaro.org>,
        Steven Rostedt <rostedt@goodmis.org>, Don Zickus <dzickus@redhat.com>
Subject: [RFC PATCH 1/6] sched: Let arch tell us if sched clock is NMI-safe
Date: Wed, 21 Aug 2013 18:42:16 +0200
Message-Id: <1377103341-15235-2-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1377103341-15235-1-git-send-email-fweisbec@gmail.com>
References: <1377103341-15235-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sched_clock() should be fast, scalable and not use any lock. As a
resuly it should be safely called from NMIs.

Now just in case there might be some implementation details proper
to some archs that make sched_clock() not reliable or not safe in NMIs,
lets provide a way through Kconfig for archs to testify about that
support.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: John Stultz <john.stultz@linaro.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Don Zickus <dzickus@redhat.com>
---
 arch/Kconfig |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/arch/Kconfig b/arch/Kconfig
index 1feb169..52ad235 100644
--- a/arch/Kconfig
+++ b/arch/Kconfig
@@ -393,6 +393,11 @@ config HAVE_UNDERSCORE_SYMBOL_PREFIX
 	  Some architectures generate an _ in front of C symbols; things like
 	  module loading and assembly files need to know about this.
 
+config HAVE_SCHED_CLOCK_NMI
+	bool
+	help
+	  Architecture's sched_clock() implementation is safely callable from  NMIs.
+
 #
 # ABI hall of shame
 #
-- 
1.7.5.4

