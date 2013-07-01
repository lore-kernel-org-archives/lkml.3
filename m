Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752786Ab3GAHMA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 03:12:00 -0400
Received: from na3sys009aog134.obsmtp.com ([74.125.149.83]:54773 "EHLO
	na3sys009aog134.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752457Ab3GAHL7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 03:11:59 -0400
From: Lei Wen <leiwen@marvell.com>
To: Paul Turner <pjt@google.com>, Alex Shi <alex.shi@intel.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        <mingo@redhat.com>, <leiwen@marvell.com>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/2] sched: add trace event for per-entity tracking
Date: Mon, 1 Jul 2013 15:10:31 +0800
Message-ID: <1372662634-12833-1-git-send-email-leiwen@marvell.com>
X-Mailer: git-send-email 1.7.10.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for the per-entity tracking feature, we could know the details of
each task by its help.
This patch add its trace support, so that we could quickly know the system
status in a large time scale, like now we may get each runqueue's usage ratio by:

cfs_rq's usage ratio = cfs_rq->runnable_load_avg/cfs_rq->load.weight

Lei Wen (2):
  sched: add trace events for task and rq usage tracking
  sched: update cfs_rq weight earlier in enqueue_entity

 include/trace/events/sched.h |   73 ++++++++++++++++++++++++++++++++++++++++++
 kernel/sched/fair.c          |   31 ++++++++++++++++--
 2 files changed, 101 insertions(+), 3 deletions(-)

-- 
1.7.10.4

