Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752651Ab3DVVId (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Apr 2013 17:08:33 -0400
Received: from mail-we0-f169.google.com ([74.125.82.169]:48323 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751646Ab3DVVIc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Apr 2013 17:08:32 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Chris Metcalf <cmetcalf@tilera.com>, Christoph Lameter <cl@linux.com>,
        Geoff Levand <geoff@infradead.org>,
        Gilad Ben Yossef <gilad@benyossef.com>,
        Hakan Akkan <hakanakkan@gmail.com>, Kevin Hilman <khilman@linaro.org>,
        Li Zhong <zhong@linux.vnet.ibm.com>, Oleg Nesterov <oleg@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [GIT PULL] nohz: Help for testing
Date: Mon, 22 Apr 2013 23:08:23 +0200
Message-Id: <1366664905-21884-1-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo,

Please pull the testing enhancements for full dynticks from:

git://git.kernel.org/pub/scm/linux/kernel/git/frederic/linux-dynticks.git
        timers/nohz-help-testing

HEAD: cb41a29076e9f95547da46578d5c8804f7b8845d

This is on top of my previous pull request (the timers/nohz branch) and
it is deemed to ease testing and help to diagnose failures:

* First patch enables CONFIG_RCU_NOCB_ALL when we have full dynticks to
ease automatic testing of the feature. This should also further
help simplifying the code. If users want more granularity in the future
to set RCU nocbs and timekeeper masks, we can still step back and
select CONFIG_RCU_NOCB_ALL only when we have CONFIG_NO_HZ_FULL_ALL.
Note this will only have an effect on tip/master because that config
is in core/rcu and not yet upstream.

* Second patch adds some tracepoints to	dump the dynticks behaviour as
I got many questions from user who don't know how to diagnose why the  
tick didn't stop on their settings.

Thanks.

---

Frederic Weisbecker (2):
  nohz: Select wide RCU nocb for full dynticks
  nohz: Add basic tracing

 include/trace/events/timer.h |   21 +++++++++++++++++++++
 kernel/time/Kconfig          |    1 +
 kernel/time/tick-sched.c     |   19 +++++++++++++++----
 3 files changed, 37 insertions(+), 4 deletions(-)

-- 
1.7.5.4

