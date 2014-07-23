Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756779AbaGWFKk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 01:10:40 -0400
Received: from mail-yk0-f179.google.com ([209.85.160.179]:58795 "EHLO
	mail-yk0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756476AbaGWFKi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 01:10:38 -0400
From: Pranith Kumar <bobby.prani@gmail.com>
To: paulmck@linux.vnet.ibm.com, Josh Triplett <josh@joshtriplett.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 00/16] rcu: Some minor fixes and cleanups
Date: Wed, 23 Jul 2014 01:09:37 -0400
Message-Id: <1406092194-13004-1-git-send-email-bobby.prani@gmail.com>
X-Mailer: git-send-email 2.0.0.rc2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Paul,

This is a series of minor fixes and cleanup patches which I found while studying
the code. All my previous pending (but not rejected ;) patches are superseded by
this series, expect the rcutorture snprintf changes. I am still waiting for you
to decide on that one :)

These changes have been tested by the kvm rcutorture test setup. Some tests give
me stall warnings, but otherwise have SUCCESS messages in the logs. But those
are occuring even without these changes with the tip paul/rcu/dev. May be it is
because I am running them for a duration of 4 minutes each only?

--
Pranith.

Pranith Kumar (16):
  rcu: Use rcu_num_nodes instead of NUM_RCU_NODES
  rcu: Check return value for cpumask allocation
  rcu: Fix comment for gp_state field values
  rcu: Remove redundant check for an online CPU
  rcu: Add noreturn attribute to boost kthread
  rcu: Clear gp_flags only when actually starting new gp
  rcu: Save and restore irq flags in rcu_gp_cleanup()
  rcu: Clean up rcu_spawn_one_boost_kthread()
  rcu: Remove redundant check for online cpu
  rcu: Check for RCU_FLAG_GP_INIT bit in gp_flags for spurious wakeup
  rcu: Check for spurious wakeup using return value
  rcu: Rename rcu_spawn_gp_kthread() to rcu_spawn_kthreads()
  rcu: Spawn nocb kthreads from rcu_prepare_kthreads()
  rcu: Remove redundant checks for rcu_scheduler_fully_active
  rcu: Check for a nocb cpu before trying to spawn nocb threads
  rcu: kvm.sh: Fix error when you pass --cpus argument

 kernel/rcu/tree.c                             | 42 ++++++++++++++-------------
 kernel/rcu/tree.h                             |  4 +--
 kernel/rcu/tree_plugin.h                      | 40 +++++++++++++------------
 tools/testing/selftests/rcutorture/bin/kvm.sh |  4 +--
 4 files changed, 47 insertions(+), 43 deletions(-)

-- 
2.0.0.rc2

