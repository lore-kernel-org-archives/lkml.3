Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755434AbaD1Wp7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 18:45:59 -0400
Received: from g5t1627.atlanta.hp.com ([15.192.137.10]:17576 "EHLO
	g5t1627.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752062AbaD1Wp6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 18:45:58 -0400
From: Jason Low <jason.low2@hp.com>
To: mingo@kernel.org, peterz@infradead.org, jason.low2@hp.com
Cc: linux-kernel@vger.kernel.org, daniel.lezcano@linaro.org,
        alex.shi@linaro.org, preeti@linux.vnet.ibm.com, efault@gmx.de,
        vincent.guittot@linaro.org, morten.rasmussen@arm.com, aswin@hp.com
Subject: [PATCH 0/2] sched: Idle load balance fixes
Date: Mon, 28 Apr 2014 15:45:53 -0700
Message-Id: <1398725155-7591-1-git-send-email-jason.low2@hp.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Resending to LKML]

This patchset includes fixes relating to idle_balance() and
rebalance_domains(). These apply on top of the following patches:

https://lkml.org/lkml/2014/4/23/767
https://lkml.org/lkml/2014/4/23/764

Patch #1 addresses an issue introduced by commit e5fc6611 which potentially
can cause rq->max_idle_balance_cost and rq->next_balance to not get updated
when it should.

Patch #2 fixes how rq->next_balance gets updated in idle_balance() and
rebalance_domains().

Jason Low (2):
  sched: Fix updating rq->max_idle_balance_cost and rq->next_balance in
    idle_balance()
  sched: Fix next_balance logic in rebalance_domains() and
    idle_balance()

 kernel/sched/fair.c |   84 ++++++++++++++++++++++++++++++++-------------------
 1 files changed, 53 insertions(+), 31 deletions(-)

