Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755885Ab3DQQZE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Apr 2013 12:25:04 -0400
Received: from mail-wi0-f179.google.com ([209.85.212.179]:39897 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754061Ab3DQQY7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Apr 2013 12:24:59 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
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
Subject: [GIT PULL] nohz: Full dynticks timekeeping and RCU improvement
Date: Wed, 17 Apr 2013 18:24:46 +0200
Message-Id: <1366215889-2635-1-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

So with this we are mostly done with the RCU and timekeeping sides.
The interface is still a bit spartan:

* Need to keep the boot CPU outside full dynticks range.
* Need to have nohz_full= be a subset of rcu_nocbs=

Note that none of this is thought to be fixed on the rock. It's
just a KISS interface settlement so that we can focus on the
central things.

These constraints will likely be removed in the future.

Please pull from:

git://git.kernel.org/pub/scm/linux/kernel/git/frederic/linux-dynticks.git
	timers/nohz

HEAD: da922312f6980cb9214a64f7303f6cb3cf93626f

Thanks.

Frederic Weisbecker (3):
  nohz: Force boot CPU outside full dynticks range
  nohz: Ensure full dynticks CPUs are RCU nocbs
  nohz: New option to default all CPUs in full dynticks range

 Documentation/kernel-parameters.txt |    6 ++-
 include/linux/rcupdate.h            |    7 +++
 include/linux/tick.h                |    2 +
 init/main.c                         |    1 +
 kernel/rcutree.c                    |    6 +-
 kernel/rcutree.h                    |    1 -
 kernel/rcutree_plugin.h             |   13 ++----
 kernel/time/Kconfig                 |   10 +++++
 kernel/time/tick-sched.c            |   77 ++++++++++++++++++----------------
 9 files changed, 72 insertions(+), 51 deletions(-)

-- 
1.7.5.4

