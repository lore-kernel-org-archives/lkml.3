Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751820AbaLQLB5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Dec 2014 06:01:57 -0500
Received: from mail3.unitn.it ([193.205.206.24]:50272 "EHLO mail3.unitn.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750904AbaLQLBx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2014 06:01:53 -0500
From: Luca Abeni <luca.abeni@unitn.it>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@redhat.com>, Juri Lelli <juri.lelli@gmail.com>,
        Dario Faggioli <raistlin@linux.it>, linux-kernel@vger.kernel.org,
        luca.abeni@unitn.it
Subject: [PATCH 0/2] SCHED_DEADLINE fixes
Date: Wed, 17 Dec 2014 11:50:30 +0100
Message-Id: <1418813432-20797-1-git-send-email-luca.abeni@unitn.it>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

I noticed some discrepancies between the schedule produced
by SCHED_DEADLINE and the expectations from real-time
scheduling theory. After some investigations, it turned out
that such discrepancies are due to two bugs in deadline.c,
which are particularly visible when using global scheduling
on multiple CPUs (see the two patches for more details).

I think the first bug (fixed in patch 0001) is particularly
critical, because it causes a violation of the SCHED_DEADLINE
guarantee (if the total load is smaller than the number of
CPUs, there is an upper bound for the response times. This is
a well known property for global EDF, but is not respected by
SCHED_DEADLINE - see patch 0001 for more details).
The second patch is IMHO also important, but less critical.

Luca Abeni (2):
  Fix migration of SCHED_DEADLINE tasks
  Avoid double-accounting in case of missed deadlines

 kernel/sched/deadline.c | 25 ++++---------------------
 1 file changed, 4 insertions(+), 21 deletions(-)

-- 
1.9.1

