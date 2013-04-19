Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030836Ab3DSOvr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Apr 2013 10:51:47 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:60968 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030552Ab3DSOvq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Apr 2013 10:51:46 -0400
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
Subject: [GIT PULL v2] nohz: Posix cpu timers handling on full dynticks
Date: Fri, 19 Apr 2013 16:51:37 +0200
Message-Id: <1366383100-17053-1-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo,

Please pull this second version of the dynticks handling of posix cpu
timers from:

git://git.kernel.org/pub/scm/linux/kernel/git/frederic/linux-dynticks.git
	timers/nohz-posix-timers-v2

This fixes an issue with a race between run_posix_cpu_timers() and full
dynticks CPUs that we found while discussing a patch with Olivier Langlois.

As a bonus, it also provides the other side of posix cpu timers handling
in dynticks with the new helper to check before stopping the tick.

Thanks.

Frederic Weisbecker (3):
  nohz: New APIs to re-evaluate the tick on full dynticks CPUs
  posix_timers: Kick full dynticks CPUs when a posix cpu timer is armed
  posix_timers: New API to prevent from stopping the tick when timers
    are running

 include/linux/posix-timers.h |    2 +
 include/linux/tick.h         |    4 ++
 kernel/posix-cpu-timers.c    |   76 +++++++++++++++++++++++++++++++++---------
 kernel/time/Kconfig          |    1 +
 kernel/time/tick-sched.c     |   51 ++++++++++++++++++++++++++++
 5 files changed, 118 insertions(+), 16 deletions(-)

-- 
1.7.5.4

