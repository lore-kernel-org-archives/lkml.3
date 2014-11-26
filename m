Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751996AbaKZApG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 19:45:06 -0500
Received: from mga01.intel.com ([192.55.52.88]:59901 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750975AbaKZApE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 19:45:04 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,459,1413270000"; 
   d="scan'208";a="628294247"
From: Wanpeng Li <wanpeng.li@linux.intel.com>
To: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>
Cc: Juri Lelli <juri.lelli@arm.com>, Kirill Tkhai <ktkhai@parallels.com>,
        linux-kernel@vger.kernel.org, Wanpeng Li <wanpeng.li@linux.intel.com>
Subject: [PATCH v6 0/7] sched: support dl task migration during cpu hotplug and other fixes
Date: Wed, 26 Nov 2014 08:44:00 +0800
Message-Id: <1416962647-76792-1-git-send-email-wanpeng.li@linux.intel.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I collect recent send out patches to one patchset in order to get review easily.

For 7/7 I will remove rd->span related modification if Pang's effort merged.
https://lkml.org/lkml/2014/11/17/443

Wanpeng Li (7):
  sched/deadline: fix start high-res preemption tick for a non-leftmost task
  sched/deadline: fix rt runtime corrupt when dl refuse a smaller bandwidth
  sched/deadline: fix dl entity is still mark yield after replenishing
  sched/deadline: reduce overhead if there are no scheduling parameters changed
  sched/fair: fix idle balance when remaining tasks are all non-CFS tasks
  sched: fix start hrtick for short schedule slices on UP
  sched/deadline: support dl task migration during cpu hotplug

 kernel/sched/core.c     | 27 +++++++++++++++++----
 kernel/sched/deadline.c | 62 +++++++++++++++++++++++++++++++++++++++++++++----
 kernel/sched/fair.c     |  2 +-
 kernel/sched/sched.h    |  3 ++-
 4 files changed, 84 insertions(+), 10 deletions(-)

-- 
1.9.1

