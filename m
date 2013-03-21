Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755693Ab3CUPYa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 11:24:30 -0400
Received: from mail-ve0-f171.google.com ([209.85.128.171]:58646 "EHLO
	mail-ve0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751051Ab3CUPY3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 11:24:29 -0400
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
Subject: [GIT PULL] nohz: Full dynticks base interface
Date: Thu, 21 Mar 2013 16:24:17 +0100
Message-Id: <1363879460-21595-1-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

This settles the initial ground to start a special full dynticks tree in -tip
that we can iterate incrementally to accelerate the development.
It is based on tip:sched/core.

I tried to rearrange a bit the naming. We are probably not yet done with
that but I guess we can fix it along with the rest.

Please pull from:

git://git.kernel.org/pub/scm/linux/kernel/git/frederic/linux-dynticks.git
	full-dynticks-for-mingo

Changes on these commits since they were part of 3.9-rc1-nohz1:

* Force a timekeeping CPU over the full dynticks range
* Rename CONFIG_NO_HZ_FULL to CONFIG_NO_HZ_EXTENDED
* Following *_nohz_extended_* APIs renames
* Handle CPU hotplug for timekeeping
* Rename full_nohz= kernel parameter to nohz_extended=
* Improve some error handling
* Improve some documentation (comments, Kconfig, ...)

Many of these changes may have been suggested by several reviewers.
Sorry for the missing credits, I lost a bit track...

Thanks.
---
Frederic Weisbecker (3):
  nohz: Basic full dynticks interface
  nohz: Assign timekeeping duty to a CPU outside the full dynticks
    range
  nohz: Wake up full dynticks CPUs when a timer gets enqueued

 Documentation/kernel-parameters.txt |    6 ++
 include/linux/sched.h               |    4 +-
 include/linux/tick.h                |    7 ++
 kernel/sched/core.c                 |   20 ++++++-
 kernel/time/Kconfig                 |   19 ++++++
 kernel/time/tick-broadcast.c        |    3 +-
 kernel/time/tick-common.c           |    5 +-
 kernel/time/tick-sched.c            |  107 ++++++++++++++++++++++++++++++++++-
 kernel/timer.c                      |   12 ++--
 9 files changed, 171 insertions(+), 12 deletions(-)

-- 
1.7.5.4

