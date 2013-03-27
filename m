Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753579Ab3C0Pcv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 11:32:51 -0400
Received: from mail-vb0-f48.google.com ([209.85.212.48]:55274 "EHLO
	mail-vb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752848Ab3C0Pcs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 11:32:48 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Chris Metcalf <cmetcalf@tilera.com>, Christoph Lameter <cl@linux.com>,
        Geoff Levand <geoff@infradead.org>,
        Gilad Ben Yossef <gilad@benyossef.com>,
        Hakan Akkan <hakanakkan@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        Kevin Hilman <khilman@linaro.org>, Li Zhong <zhong@linux.vnet.ibm.com>,
        Namhyung Kim <namhyung.kim@lge.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 0/4] nohz: Full dynticks fixes/improvements
Date: Wed, 27 Mar 2013 16:32:35 +0100
Message-Id: <1364398359-21990-1-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Changes against tip:timers/nohz :

* Fixes for timekeeping
* Handle RCU nocb restriction
* Improvements on info and tunables

I'll send these to Ingo for tip:timers/nohz in a few days if no
comment arise.

You can fetch from:

git://git.kernel.org/pub/scm/linux/kernel/git/frederic/linux-dynticks.git
	timers/nohz

Thanks.

Frederic Weisbecker (4):
  nohz: Force boot CPU outside full dynticks range
  nohz: Print final full dynticks CPUs range on boot
  nohz: Ensure full dynticks CPUs are RCU nocbs
  nohz: New option to force all CPUs in full dynticks range

 Documentation/kernel-parameters.txt |    6 ++-
 include/linux/rcupdate.h            |    7 +++
 include/linux/tick.h                |    2 +
 init/main.c                         |    1 +
 kernel/rcutree.c                    |    6 +-
 kernel/rcutree.h                    |    1 -
 kernel/rcutree_plugin.h             |   13 ++----
 kernel/time/Kconfig                 |   10 +++++
 kernel/time/tick-sched.c            |   71 ++++++++++++++++++-----------------
 9 files changed, 67 insertions(+), 50 deletions(-)

-- 
1.7.5.4

