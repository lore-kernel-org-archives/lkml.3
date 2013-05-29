Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965746Ab3E2LDB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 07:03:01 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:45473 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965626Ab3E2LC7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 07:02:59 -0400
From: Glauber Costa <glommer@openvz.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Turner <pjt@google.com>, <linux-kernel@vger.kernel.org>,
        Tejun Heo <tj@kernel.org>, <cgroups@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, <devel@openvz.org>
Subject: [PATCH v7 00/11] per-cgroup cpu-stat
Date: Wed, 29 May 2013 15:03:11 +0400
Message-Id: <1369825402-31046-1-git-send-email-glommer@openvz.org>
X-Mailer: git-send-email 1.8.1.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter et. al,

I am coming again with this series, hoping this is a better time for you all to
look at it.

I am *not* going as far as marking cpuacct deprecated, because I think it
deserves a special discussion (even though my position in this matter is widely
known), but all the infrastructure to make it happen is here. But after this,
it should be a matter of setting a flag (or not).

Through this patchset I am making cpu cgroup provide the same functionality of
cpuacct, and now with a more clear semantics, I attempt to provide userspace
with enough information to reconstruct per-container version of files like
"/proc/stat". In particular, we are interested in knowing the per-cgroup slices
of user time, system time, wait time, number of processes, and a variety of
statistics.

To make sure we can count nr of switches correctly, I am ressurecting one of
Peter's patches that apparently got nowhere in the past.

Glauber Costa (8):
  don't call cpuacct_charge in stop_task.c
  sched: adjust exec_clock to use it as cpu usage metric
  cpuacct: don't actually do anything.
  sched: document the cpu cgroup.
  sched: account guest time per-cgroup as well.
  sched: record per-cgroup number of context switches
  sched: change nr_context_switches calculation.
  sched: introduce cgroup file stat_percpu

Peter Zijlstra (1):
  sched: Push put_prev_task() into pick_next_task()

Tejun Heo (2):
  cgroup: implement CFTYPE_NO_PREFIX
  cgroup, sched: let cpu serve the same files as cpuacct

 Documentation/cgroups/cpu.txt |  99 +++++++++++
 include/linux/cgroup.h        |   1 +
 kernel/cgroup.c               |  16 +-
 kernel/sched/core.c           | 385 ++++++++++++++++++++++++++++++++++++++++--
 kernel/sched/cputime.c        |  33 +++-
 kernel/sched/fair.c           |  39 ++++-
 kernel/sched/idle_task.c      |   9 +-
 kernel/sched/rt.c             |  42 +++--
 kernel/sched/sched.h          |  35 +++-
 kernel/sched/stop_task.c      |   8 +-
 10 files changed, 626 insertions(+), 41 deletions(-)
 create mode 100644 Documentation/cgroups/cpu.txt

-- 
1.8.1.4

