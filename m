Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935427Ab3JPSQR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 14:16:17 -0400
Received: from mail-ye0-f202.google.com ([209.85.213.202]:40157 "EHLO
	mail-ye0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934807Ab3JPSQN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 14:16:13 -0400
Subject: [PATCH 0/5] Fix several races in CFS_BANDWIDTH
To: peterz@infradead.org, mingo@redhat.com
From: Ben Segall <bsegall@google.com>
Cc: pjt@google.com, linux-kernel@vger.kernel.org
Date: Wed, 16 Oct 2013 11:16:06 -0700
Message-ID: <20131016181548.22647.17161.stgit@sword-of-the-dawn.mtv.corp.google.com>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are several races we've found in CFS_BANDWIDTH that cause crashes or stuck
tasks.

---

Ben Segall (4):
      sched: Fix race on toggling cfs_bandwidth_used
      sched: Fix cfs_bandwidth misuse of hrtimer_expires_remaining
      sched: Fix hrtimer_cancel/rq->lock deadlock
      sched: Avoid throttle_cfs_rq racing with period_timer stopping

Paul Turner (1):
      sched: Guarantee new group-entities always have weight


 kernel/sched/core.c  |    9 ++++++++-
 kernel/sched/debug.c |    8 ++++++++
 kernel/sched/fair.c  |   50 +++++++++++++++++++++++++++++++++++---------------
 kernel/sched/sched.h |    3 ++-
 4 files changed, 53 insertions(+), 17 deletions(-)

-- 
Signature
