Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753050Ab3IWTkL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 15:40:11 -0400
Received: from g5t0007.atlanta.hp.com ([15.192.0.44]:35829 "EHLO
	g5t0007.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751835Ab3IWTkI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 15:40:08 -0400
From: Waiman Long <Waiman.Long@hp.com>
Cc: Waiman Long <Waiman.Long@hp.com>, linux-kernel@vger.kernel.org,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>
Subject: [PATCH 0/2] sched: Reduce contention on tg's load_avg & runnable_avg
Date: Mon, 23 Sep 2013 15:39:21 -0400
Message-Id: <1379965163-18440-1-git-send-email-Waiman.Long@hp.com>
X-Mailer: git-send-email 1.7.1
To: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These 2 patches try to reduce contention on the load_avg and
runnable_avg values of the task_group structure in large NUMA
machine by:

patch 1: Move them into their own cacheline & reduce actual read/write
	 to them.

patch 2: Reduce the frequecy of doing the average computation.

Waiman Long (2):
  sched: reduce contention on tg's load_avg & runnable_avg
  sched, numa: reduce load/runnable_avg computation frequency

 init/Kconfig         |   13 ++++++++
 kernel/sched/core.c  |    1 +
 kernel/sched/fair.c  |   84 +++++++++++++++++++++++++++++++++++++++++++++-----
 kernel/sched/sched.h |   29 ++++++++++++++++-
 4 files changed, 117 insertions(+), 10 deletions(-)

