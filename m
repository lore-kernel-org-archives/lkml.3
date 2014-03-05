Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753257AbaCEHTB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 02:19:01 -0500
Received: from mail-pa0-f41.google.com ([209.85.220.41]:48184 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750747AbaCEHS7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 02:18:59 -0500
From: Vincent Guittot <vincent.guittot@linaro.org>
To: peterz@infradead.org, mingo@kernel.org, linux-kernel@vger.kernel.org,
        tony.luck@intel.com, fenghua.yu@intel.com, schwidefsky@de.ibm.com,
        james.hogan@imgtec.com, cmetcalf@tilera.com, benh@kernel.crashing.org,
        linux@arm.linux.org.uk, linux-arm-kernel@lists.infradead.org
Cc: dietmar.eggemann@arm.com, preeti@linux.vnet.ibm.com,
        linaro-kernel@lists.linaro.org,
        Vincent Guittot <vincent.guittot@linaro.org>
Subject: [RFC 0/6] rework sched_domain topology description
Date: Wed,  5 Mar 2014 15:18:20 +0800
Message-Id: <1394003906-11630-1-git-send-email-vincent.guittot@linaro.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset was previously part of the larger tasks packing patchset [1].
I have splitted the latter in 3 different patchsets (at least) to make the
thing easier.
-configuration of sched_domain topology (this patchset)
-update and consolidation of cpu_power
-tasks packing algorithm

Based on Peter Z's proposal [2][3], this patchset modifies the way to configure
the sched_domain level in order to let architectures to add specific level like
the current BOOK level or the proposed power gating level for ARM architecture.

[1] https://lkml.org/lkml/2013/10/18/121
[2] https://lkml.org/lkml/2013/11/5/239
[3] https://lkml.org/lkml/2013/11/5/449

Vincent Guittot (6):
  sched: remove unused SCHED_INIT_NODE
  sched: rework of sched_domain topology definition
  sched: s390: create a dedicated topology table
  sched: powerpc: create a dedicated topology table
  sched: add a new SD_SHARE_POWERDOMAIN for sched_domain
  sched: ARM: create a dedicated scheduler topology table

 arch/arm/kernel/topology.c        |   26 ++++
 arch/ia64/include/asm/topology.h  |   24 ----
 arch/metag/include/asm/topology.h |   27 -----
 arch/powerpc/kernel/smp.c         |   35 ++++--
 arch/s390/include/asm/topology.h  |   13 +-
 arch/s390/kernel/topology.c       |   25 ++++
 arch/tile/include/asm/topology.h  |   33 ------
 include/linux/sched.h             |   30 +++++
 include/linux/topology.h          |  128 ++------------------
 kernel/sched/core.c               |  235 ++++++++++++++++++-------------------
 10 files changed, 237 insertions(+), 339 deletions(-)

-- 
1.7.9.5

