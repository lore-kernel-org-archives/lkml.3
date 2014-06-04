Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752585AbaFDRb0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 13:31:26 -0400
Received: from mail-pd0-f176.google.com ([209.85.192.176]:50825 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752371AbaFDRbV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 13:31:21 -0400
From: Andy Lutomirski <luto@amacapital.net>
To: Peter Zijlstra <peterz@infradead.org>, umgwanakikbuti@gmail.com
Cc: mingo@kernel.org, tglx@linutronix.de, nicolas.pitre@linaro.org,
        daniel.lezcano@linaro.org, linux-kernel@vger.kernel.org,
        Andy Lutomirski <luto@amacapital.net>
Subject: [PATCH v2 0/5] sched: Cleanup and improve polling idle loops
Date: Wed,  4 Jun 2014 10:31:13 -0700
Message-Id: <cover.1401902905.git.luto@amacapital.net>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series reduces the number of IPIs on my workload by something like
99%.  It's down from many hundreds per second to very few.

The basic idea behind this series is to make TIF_POLLING_NRFLAG be a
reliable indication that the idle task is polling.  Once that's done,
the rest is reasonably straightforward.

Patches 1 and 2 are related improvements: patch 1 teaches the cpuidle
polling loop how to poll, and patch 2 adds tracepoints so that avoided
IPIs are visible.  Patch 3 is the main semantic change, patch 4 is
cleanup, and patch 5 is peterz's code, rebased on top of my stuff, and
fixed up a bit.

Changes from v1:

 - Squashed the two idle loop rearrangement patches.
 - Improved comments.

Andy Lutomirski (4):
  cpuidle: Set polling in poll_idle
  sched,trace: Add a tracepoint for IPI-less remote wakeups
  sched,idle: Clear polling before descheduling the idle thread
  sched,idle: Simplify wake_up_idle_cpu

Peter Zijlstra (1):
  sched: Optimize ttwu IPI

 drivers/cpuidle/driver.c     |  7 ++--
 include/trace/events/sched.h | 20 +++++++++++
 kernel/sched/core.c          | 79 +++++++++++++++++++++++++++++---------------
 kernel/sched/idle.c          | 30 ++++++++++++++++-
 kernel/sched/sched.h         |  6 ++++
 5 files changed, 113 insertions(+), 29 deletions(-)

-- 
1.9.3

