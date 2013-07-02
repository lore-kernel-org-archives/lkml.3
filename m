Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752222Ab3GBMPm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 08:15:42 -0400
Received: from na3sys009aog105.obsmtp.com ([74.125.149.75]:57041 "EHLO
	na3sys009aog105.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751504Ab3GBMPl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 08:15:41 -0400
From: Lei Wen <leiwen@marvell.com>
To: Paul Turner <pjt@google.com>, Alex Shi <alex.shi@intel.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        <mingo@redhat.com>, Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Lei Wen <leiwen@marvell.com>, <linux-kernel@vger.kernel.org>
Subject: [PATCH V3 0/2] sched: add trace event for per-entity tracking
Date: Tue, 2 Jul 2013 20:15:04 +0800
Message-ID: <1372767306-9478-1-git-send-email-leiwen@marvell.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1372682002-15373-1-git-send-email-leiwen@marvell.com>
References: <1372682002-15373-1-git-send-email-leiwen@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for the per-entity tracking feature, we could know the details of
each task by its help.
This patch add its trace support, so that we could quickly know the system
status in a large time scale.

The "cfs_rq->runnable_load_avg/cfs_rq->load.weight" is useful in identify
load distribution status in the whole system

With those pre-embedded tracepoint, we could make our life easy over tracking
the system load, especially since the per-entity load tracking is recently added,
people may want to use those trace point to get better understanding for
this new feature.

V3: make trace events passing parameter being simple, and only extend
    its detail in the header file definition. Thanks Peter for pointing out this.

V2: Abstract sched_cfs_rq_runnable_load and sched_cfs_rq_blocked_load using
    sched_cfs_rq_load_contri_template. Thanks Kamalesh for this contribution!

Lei Wen (2):
  sched: add trace events for task and rq usage tracking
  sched: update cfs_rq weight earlier in enqueue_entity

 include/trace/events/sched.h |   73 ++++++++++++++++++++++++++++++++++++++++++
 kernel/sched/fair.c          |   31 ++++++++++++++++--
 2 files changed, 101 insertions(+), 3 deletions(-)

-- 
1.7.10.4

