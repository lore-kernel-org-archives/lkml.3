Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751147AbaBKHfI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 02:35:08 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:4755 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750758AbaBKHfE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 02:35:04 -0500
X-IronPort-AV: E=Sophos;i="4.95,824,1384272000"; 
   d="scan'208";a="9505334"
From: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
To: linux-kernel@vger.kernel.org
Cc: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
Subject: [PATCH 0/9] Add MAX_NICE, MIN_NICE and NICE_WIDTH macros in prio.h.
Date: Tue, 11 Feb 2014 15:34:44 +0800
Message-Id: <cover.1392103744.git.yangds.fnst@cn.fujitsu.com>
X-Mailer: git-send-email 1.8.2.1
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2014/02/11 15:33:01,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2014/02/11 15:33:02,
	Serialize complete at 2014/02/11 15:33:02
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter,
	There are lots of hardcoding of -20 and 19 in kernel to represent
minimum and maximum of nice value currently. This patch set define three
macros in prio.h and replace some of the hardcoding with them.

	Please help to take a look at it, thanx :)

Dongsheng Yang (9):
  sched: Prio: Use DEFAULT_PRIO to define NICE_TO_PRIO and PRIO_TO_NICE.
  sched: prio: Add 3 macros of MAX_NICE, MIN_NICE and NICE_WIDTH in
    prio.h.
  sched: prio: Use NICE_WIDTH macro to avoid using of hard coding of 40
    and 20 in prio.h.
  sched: prio: Add spaces before and after operator of '-'.
  rcu: Use MAX_NICE to replace hard coding of 19.
  sched: Replace hardcoding of -20 and 19 with MIN_NICE and MAX_NICE.
  sys: Replace hardcoding of -20 and 19 with MIN_NICE and MAX_NICE.
  workqueue: Replace hardcoding of -20 and 19 with MIN_NICE and
    MAX_NICE.
  trace: Replace hardcoding of 19 with MAX_NICE.

 include/linux/sched/prio.h           | 14 +++++++++-----
 kernel/rcu/torture.c                 |  8 ++++----
 kernel/sched/auto_group.c            |  2 +-
 kernel/sched/core.c                  | 12 ++++++------
 kernel/sys.c                         |  8 ++++----
 kernel/trace/ring_buffer_benchmark.c |  6 +++---
 kernel/workqueue.c                   |  2 +-
 7 files changed, 28 insertions(+), 24 deletions(-)

-- 
1.8.2.1

