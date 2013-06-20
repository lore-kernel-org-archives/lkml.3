Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757966Ab3FTPmq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 11:42:46 -0400
Received: from mail-we0-f179.google.com ([74.125.82.179]:54599 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757675Ab3FTPmp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 11:42:45 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Li Zhong <zhong@linux.vnet.ibm.com>, Borislav Petkov <bp@alien8.de>,
        Don Zickus <dzickus@redhat.com>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Anish Singh <anish198519851985@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: [GIT PULL] nohz: A few updates
Date: Thu, 20 Jun 2013 17:42:40 +0200
Message-Id: <1371742960-24727-1-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo,

Please pull the timers/core branch that can be found at:

git://git.kernel.org/pub/scm/linux/kernel/git/frederic/linux-dynticks.git
	timers/core

Note that "watchdog: Boot-disable by default on full dynticks" is a temporary
solution to solve the issue with the watchdog that prevents the tick from
stopping. This is to make sure that 3.11 doesn't have that problem as several
people complained about it.

A proper and longer term solution has been proposed by Peterz:

	http://lkml.kernel.org/r/20130618103632.GO3204@twins.programming.kicks-ass.net

I plan to work on it. But since I'll be off next week, I prefer to have
at least a working temporary solution before the next merge window.

Thanks,
	Frederic
---

Frederic Weisbecker (4):
      watchdog: Register / unregister watchdog kthreads on sysctl control
      watchdog: Rename confusing state variable
      watchdog: Boot-disable by default on full dynticks
      nohz: Remove obsolete check for full dynticks CPUs to be RCU nocbs

Steven Rostedt (1):
      nohz: Warn if the machine can not perform nohz_full


 include/linux/nmi.h      |    2 +-
 kernel/sysctl.c          |    4 +-
 kernel/time/tick-sched.c |   15 ++----
 kernel/watchdog.c        |  113 ++++++++++++++++++++++++++--------------------
 4 files changed, 72 insertions(+), 62 deletions(-)
