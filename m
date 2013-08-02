Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754024Ab3HBBux (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 21:50:53 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:56025 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753170Ab3HBBu2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 21:50:28 -0400
X-AuditID: 9c930179-b7c49ae000000e68-52-51fb106163df
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, Mike Galbraith <efault@gmx.de>,
        Paul Turner <pjt@google.com>, Alex Shi <alex.shi@intel.com>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Morten Rasmussen <morten.rasmussen@arm.com>,
        Namhyung Kim <namhyung@kernel.org>, Joonsoo Kim <js1304@gmail.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: [PATCH v2 0/3] optimization, clean-up about fair.c
Date: Fri,  2 Aug 2013 10:50:20 +0900
Message-Id: <1375408223-10934-1-git-send-email-iamjoonsoo.kim@lge.com>
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

* Change from v1
Remove 2 patches, because I cannot sure they are right.

Joonsoo Kim (3):
  sched: remove one division operation in find_buiest_queue()
  sched: factor out code to should_we_balance()
  sched: clean-up struct sd_lb_stat

 kernel/sched/fair.c |  326 +++++++++++++++++++++++++--------------------------
 1 file changed, 161 insertions(+), 165 deletions(-)

-- 
1.7.9.5

