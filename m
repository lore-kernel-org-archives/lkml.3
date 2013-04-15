Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935032Ab3DOVKd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Apr 2013 17:10:33 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:50579 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933505Ab3DOVK3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Apr 2013 17:10:29 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Chris Metcalf <cmetcalf@tilera.com>, Christoph Lameter <cl@linux.com>,
        Geoff Levand <geoff@infradead.org>,
        Gilad Ben Yossef <gilad@benyossef.com>,
        Hakan Akkan <hakanakkan@gmail.com>, Kevin Hilman <khilman@linaro.org>,
        Li Zhong <zhong@linux.vnet.ibm.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 1/5] nohz: Fix old dynticks idle Kconfig backward compatibility
Date: Mon, 15 Apr 2013 23:10:16 +0200
Message-Id: <1366060220-20271-2-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1366060220-20271-1-git-send-email-fweisbec@gmail.com>
References: <1366060220-20271-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In order to enforce backward compatibility with older
config files, we want the new dynticks-idle Kconfig entry
to default its value to the one of the old CONFIG_NO_HZ symbol
if present.

Namely we want:

	config NO_HZ # old obsolete dynticks idle symbol
		bool

	config NO_HZ_IDLE # new dynticks idle symbol
		default NO_HZ

However Kconfig prevents this to work if the old symbol
is not visible. And this is currently the case because
NO_HZ lacks a title in order to show it in make oldconfig
and alike.

To fix this, bring a minimal title and help text to the
obsolete Kconfig entry that explains its purpose. This
makes the "defaulting" to work.

Reported-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Chris Metcalf <cmetcalf@tilera.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Geoff Levand <geoff@infradead.org>
Cc: Gilad Ben Yossef <gilad@benyossef.com>
Cc: Hakan Akkan <hakanakkan@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Kevin Hilman <khilman@linaro.org>
Cc: Li Zhong <zhong@linux.vnet.ibm.com>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/time/Kconfig |   12 ++++++++----
 1 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/kernel/time/Kconfig b/kernel/time/Kconfig
index 27cc404..cbe64be 100644
--- a/kernel/time/Kconfig
+++ b/kernel/time/Kconfig
@@ -75,10 +75,6 @@ config NO_HZ_COMMON
 	depends on !ARCH_USES_GETTIMEOFFSET && GENERIC_CLOCKEVENTS
 	select TICK_ONESHOT
 
-# Kept around for compatibility, maps to NO_HZ_IDLE
-config NO_HZ
-	bool
-
 choice
 	prompt "Timer tick handling"
 	default NO_HZ_IDLE if NO_HZ
@@ -130,6 +126,14 @@ config NO_HZ_EXTENDED
 
 endchoice
 
+config NO_HZ
+	bool "Old Idle dynticks config"
+	depends on !ARCH_USES_GETTIMEOFFSET && GENERIC_CLOCKEVENTS
+	help
+	  This is the old config entry that enables dynticks idle.
+	  We keep it around for a little while to enforce backward
+	  compatibility with older config files.
+
 config HIGH_RES_TIMERS
 	bool "High Resolution Timer Support"
 	depends on !ARCH_USES_GETTIMEOFFSET && GENERIC_CLOCKEVENTS
-- 
1.7.5.4

