Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934479Ab3DOVK2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Apr 2013 17:10:28 -0400
Received: from mail-wg0-f42.google.com ([74.125.82.42]:56214 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752930Ab3DOVK1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Apr 2013 17:10:27 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Josh Triplett <josh@joshtriplett.org>,
        Chris Metcalf <cmetcalf@tilera.com>, Christoph Lameter <cl@linux.com>,
        Geoff Levand <geoff@infradead.org>,
        Gilad Ben Yossef <gilad@benyossef.com>,
        Hakan Akkan <hakanakkan@gmail.com>, Kevin Hilman <khilman@linaro.org>,
        Li Zhong <zhong@linux.vnet.ibm.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [GIT PULL] nohz: More Kconfig and Rcu improvements
Date: Mon, 15 Apr 2013 23:10:15 +0200
Message-Id: <1366060220-20271-1-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo,

Please pull the latest timers/nohz branch that can be found at:

git://git.kernel.org/pub/scm/linux/kernel/git/frederic/linux-dynticks.git
	timers/nohz

HEAD: 65d798f0f9339ae2c4ebe9480e3260b33382a584

This fixes some of the issues you've reported. There is still the
dependency on CONFIG_VIRT_CPU_ACCOUNTING_GEN to fix, probably in
the Kconfig side. Stay tuned.

Thanks.

---
Frederic Weisbecker (4):
  nohz: Fix old dynticks idle Kconfig backward compatibility
  nohz: Switch from "extended nohz" to "full nohz" based naming
  nohz: Align periodic tick Kconfig with other choices' naming
    convention
  nohz: Improve a bit the full dynticks Kconfig documentation

Paul E. McKenney (1):
  rcu: Kick adaptive-ticks CPUs that are holding up RCU grace periods

 Documentation/kernel-parameters.txt |    4 +-
 include/linux/tick.h                |    6 ++--
 kernel/rcutree.c                    |   10 ++++++
 kernel/rcutree.h                    |    1 +
 kernel/rcutree_plugin.h             |   18 +++++++++++
 kernel/sched/core.c                 |    6 ++--
 kernel/time/Kconfig                 |   26 ++++++++++------
 kernel/time/tick-broadcast.c        |    2 +-
 kernel/time/tick-common.c           |    2 +-
 kernel/time/tick-sched.c            |   54 +++++++++++++++++-----------------
 10 files changed, 82 insertions(+), 47 deletions(-)

-- 
1.7.5.4

