Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755846Ab3C1H7C (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 03:59:02 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:53645 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755214Ab3C1H7B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 03:59:01 -0400
X-AuditID: 9c930197-b7c9dae000006959-84-5153f8415db6
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, Mike Galbraith <efault@gmx.de>,
        Paul Turner <pjt@google.com>, Alex Shi <alex.shi@intel.com>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Morten Rasmussen <morten.rasmussen@arm.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: [PATCH 0/5] optimization, clean-up, correctness about fair.c
Date: Thu, 28 Mar 2013 16:58:51 +0900
Message-Id: <1364457537-15114-1-git-send-email-iamjoonsoo.kim@lge.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is no unified subject for this patchset.

Patch 1 is for removing one division operation with multiplication.
Patch 2,3 is for clean-up related to load_balance(), there is improvement
in terms of code size and IMO, readability may be also improved.
Patch 4,5 is for correctness about sched_slice()

Feel free to give a comment for this patchset.

It's based on v3.9-rc4 and top of my previous patchset. But, perhaps,
it may not really depend on my previous patchset. :)

https://lkml.org/lkml/2013/3/26/28
"[PATCH v2 0/6] correct load_balance()"

Thanks.

Joonsoo Kim (5):
  sched: remove one division operation in find_buiest_queue()
  sched: factor out code to should_we_balance()
  sched: clean-up struct sd_lb_stat
  sched: don't consider upper se in sched_slice()
  sched: limit sched_slice if it is more than sysctl_sched_latency

 kernel/sched/fair.c |  347 +++++++++++++++++++++++++--------------------------
 1 file changed, 171 insertions(+), 176 deletions(-)

-- 
1.7.9.5

