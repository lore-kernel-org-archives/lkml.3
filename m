Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752517Ab3HUQql (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 12:46:41 -0400
Received: from mail-wi0-f175.google.com ([209.85.212.175]:57770 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752497Ab3HUQqj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 12:46:39 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        John Stultz <john.stultz@linaro.org>,
        Steven Rostedt <rostedt@goodmis.org>, Don Zickus <dzickus@redhat.com>
Subject: [RFC PATCH 3/6] x86: Tell that sched clock is callable in nmi
Date: Wed, 21 Aug 2013 18:42:18 +0200
Message-Id: <1377103341-15235-4-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1377103341-15235-1-git-send-email-fweisbec@gmail.com>
References: <1377103341-15235-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The x86 version of sched_clock() seem to be safely callable
from NMIs, tell about that.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: John Stultz <john.stultz@linaro.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Don Zickus <dzickus@redhat.com>
---
 arch/x86/Kconfig |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 7fbda5c..fc7c34c 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -125,6 +125,7 @@ config X86
 	select RTC_LIB
 	select HAVE_DEBUG_STACKOVERFLOW
 	select HAVE_NSECS_TO_CYCLES
+	select HAVE_SCHED_CLOCK_NMI
 
 config INSTRUCTION_DECODER
 	def_bool y
-- 
1.7.5.4

