Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754817Ab3HFIgu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Aug 2013 04:36:50 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:57619 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754634Ab3HFIgq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Aug 2013 04:36:46 -0400
X-AuditID: 9c930179-b7c53ae000000457-a2-5200b59c2f64
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, Mike Galbraith <efault@gmx.de>,
        Paul Turner <pjt@google.com>, Alex Shi <alex.shi@intel.com>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Morten Rasmussen <morten.rasmussen@arm.com>,
        Namhyung Kim <namhyung@kernel.org>, Joonsoo Kim <js1304@gmail.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: [PATCH v3 0/3] optimization, clean-up about fair.c
Date: Tue,  6 Aug 2013 17:36:40 +0900
Message-Id: <1375778203-31343-1-git-send-email-iamjoonsoo.kim@lge.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Patch 1 is for removing one division operation with multiplication.
Patch 2,3 is for clean-up related to load_balance(), there is improvement
in terms of code size and readability may be also improved.

Feel free to give a comment for this patchset.

It's tested on v3.10.
On v3.11-rc3, it can be compiled properly.

* Change from v2
[2/3]: set initial value 1 to should_balance in rebalance_domains()
	as Vincent commented
[3/3]: not overwrite sum_weighted_load to represent load_per_task.
	Instead, use newly load_per_task as Preeti commented

* Change from v1
Remove 2 patches, because I'm not sure they are right.

Joonsoo Kim (3):
  sched: remove one division operation in find_buiest_queue()
  sched: factor out code to should_we_balance()
  sched: clean-up struct sd_lb_stat

 kernel/sched/fair.c |  326 +++++++++++++++++++++++++--------------------------
 1 file changed, 162 insertions(+), 164 deletions(-)

-- 
1.7.9.5

