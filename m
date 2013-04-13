Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753538Ab3DMAFC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Apr 2013 20:05:02 -0400
Received: from mail.windriver.com ([147.11.1.11]:35932 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752182Ab3DMAFA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Apr 2013 20:05:00 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>
CC: Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [RFC PATCH 0/2] sched: move content out of core files for load average
Date: Fri, 12 Apr 2013 20:04:15 -0400
Message-ID: <1365811457-31924-1-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.8.1.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Recent activity has had a focus on moving functionally related blocks of stuff
out of sched/core.c into stand-alone files.  The code relating to load average
calculations has grown significantly enough recently to warrant placing it in
a separate file.

Here we do that, and in doing so, we shed ~20k of code from sched/core.c (~10%).

A couple small static functions in the core sched.h header were also localized
to their singular user in sched/fair.c at the same time, with the goal to also
reduce the amount of "broadcast" content in that sched.h file.

Paul.
---

[ Patches sent here are tested on tip's sched/core, i.e. v3.9-rc1-38-gb329fd5

  Assuming that this change is OK with folks, the timing can be whatever is most
  convenient -- i.e. I can update/respin it close to the end of the merge window
  for what will be v3.10-rc1, if that is what minimizes the inconvenience to folks
  who might be changing the code that is relocated here. ]

Paul Gortmaker (2):
  sched: fork load calculation code from sched/core --> sched/load_avg
  sched: move update_load_[add/sub/set] from sched.h to fair.c

 kernel/sched/Makefile   |   2 +-
 kernel/sched/core.c     | 569 -----------------------------------------------
 kernel/sched/fair.c     |  18 ++
 kernel/sched/load_avg.c | 577 ++++++++++++++++++++++++++++++++++++++++++++++++
 kernel/sched/sched.h    |  26 +--
 5 files changed, 604 insertions(+), 588 deletions(-)
 create mode 100644 kernel/sched/load_avg.c

-- 
1.8.1.2

