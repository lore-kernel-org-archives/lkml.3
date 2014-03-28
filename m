Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752023AbaC1NYW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2014 09:24:22 -0400
Received: from mail-wg0-f43.google.com ([74.125.82.43]:35876 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751305AbaC1NYV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2014 09:24:21 -0400
From: Vincent Guittot <vincent.guittot@linaro.org>
To: peterz@infradead.org, mingo@kernel.org, linux-kernel@vger.kernel.org,
        linux@arm.linux.org.uk, linux-arm-kernel@lists.infradead.org
Cc: preeti@linux.vnet.ibm.com, Morten.Rasmussen@arm.com, efault@gmx.de,
        linaro-kernel@lists.linaro.org,
        Vincent Guittot <vincent.guittot@linaro.org>
Subject: [RFC 0/4] sched: consolidation of cpu_power
Date: Fri, 28 Mar 2014 14:22:25 +0100
Message-Id: <1396012949-6227-1-git-send-email-vincent.guittot@linaro.org>
X-Mailer: git-send-email 1.9.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Part of this patchset was previously part of the larger tasks packing patchset
[1]. I have splitted the latter in 3 different patchsets (at least) to make the
thing easier.
-configuration of sched_domain topology [2]
-update and consolidation of cpu_power (this patchset)
-tasks packing algorithm

SMT system is no more the only system that can have a CPUs with capacity that
is different from the default value. We need to extend the use of
cpu_power_orig to all kind of platform so the scheduler will have both the
maximum capacity (cpu_power_orig/power_orig) and the current capacity
(cpu_power/power) of CPUs and groups of the sched_domains.
During load balance, the scheduler evaluates the number of tasks that a group
of CPUs can handle. The current method ensures that we will not return more
capacity than number of real cores but it returns wrong value for group of
LITTLE cores and in some situation for SMT system. The proposed solution
computes the ratio between CPUs and cores for a group durint the init sequence
and uses it with power and power_orig to return the current capacity of a
group.

[1] https://lkml.org/lkml/2013/10/18/121
[2] https://lkml.org/lkml/2014/3/19/377

Vincent Guittot (4):
  sched: extend the usage of cpu_power_orig
  ARM: topology: use new cpu_power interface
  sched: fix computed capacity for HMP
  sched: add per group cpu_power_orig

 arch/arm/kernel/topology.c |  4 ++--
 kernel/sched/core.c        |  9 ++++++++-
 kernel/sched/fair.c        | 31 +++++++++++++++++++------------
 kernel/sched/sched.h       |  3 ++-
 4 files changed, 31 insertions(+), 16 deletions(-)

-- 
1.9.0

