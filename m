Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752270AbaDXBau (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 21:30:50 -0400
Received: from g9t1613g.houston.hp.com ([15.240.0.71]:45283 "EHLO
	g9t1613g.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750750AbaDXBat (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 21:30:49 -0400
From: Jason Low <jason.low2@hp.com>
To: mingo@kernel.org, peterz@infradead.org, jason.low2@hp.com
Cc: linux-kernel@vger.kernel.org, daniel.lezcano@linaro.org,
        alex.shi@linaro.org, preeti@linux.vnet.ibm.com, efault@gmx.de,
        vincent.guittot@linaro.org, morten.rasmussen@arm.com, aswin@hp.com,
        chegu_vinod@hp.com
Subject: [PATCH 0/3] sched: Idle balance patches
Date: Wed, 23 Apr 2014 18:30:32 -0700
Message-Id: <1398303035-18255-1-git-send-email-jason.low2@hp.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset includes a few modifications related to idle_balance().

Patch #1 addresses an issue introduced by commit e5fc6611 which potentially
can cause rq->max_idle_balance_cost to not get updated when it should.

Patch #2 initializes the per domain newidle balance stats in sd_numa_init().

Patch #3 is a performance related patch. It stops searching for more tasks
to pull while traversing the domains in idle balance if we find that there
are runnable tasks. This patch resulted in approximately a 6% performance
improvement to a Java server workload on an 8 socket machine.

Jason Low (3):
  sched, balancing: Update rq->max_idle_balance_cost whenever newidle
    balance is attempted
  sched: Initialize newidle balance stats in sd_numa_init()
  sched, fair: Stop searching for tasks in newidle balance if there are
    runnable tasks

 kernel/sched/core.c |    2 ++
 kernel/sched/fair.c |   17 +++++++++++------
 2 files changed, 13 insertions(+), 6 deletions(-)

