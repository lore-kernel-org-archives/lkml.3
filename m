Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755259Ab3FRNG7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 09:06:59 -0400
Received: from na3sys009aog115.obsmtp.com ([74.125.149.238]:47288 "EHLO
	na3sys009aog115.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752064Ab3FRNG6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 09:06:58 -0400
From: Lei Wen <leiwen@marvell.com>
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        <mingo@redhat.com>, <leiwen@marvell.com>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH v4 0/4] small fix for scale usage
Date: Tue, 18 Jun 2013 21:04:15 +0800
Message-ID: <1371560659-4686-1-git-send-email-leiwen@marvell.com>
X-Mailer: git-send-email 1.7.10.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here are three patches which correct scale usage in both fix_small_imbalance
and update_sg_lb_stats.

And give out comment over when fix_small_imbalance would cause load change.

V2: fix scale usage for update_sg_lb_stats

V3: fix scale problem in comparing sds->busiest_load_per_task
    and sds->avg_load when there is not balanced group inside the domain

V4: env->imbalance should be applied with not scaled value, fix according to it.
    Fix one ping-pong adjustment for special case.

Lei Wen (4):
  sched: reduce calculation effort in fix_small_imbalance
  sched: scale the busy and this queue's per-task load before compare
  sched: scale cpu load for judgment of group imbalance
  sched: adjust fix_small_imbalance moving task condition

 kernel/sched/fair.c |   85 ++++++++++++++++++++++++++++++++-------------------
 1 file changed, 54 insertions(+), 31 deletions(-)

-- 
1.7.10.4

