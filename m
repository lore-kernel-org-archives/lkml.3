Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753563Ab3DSTLV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Apr 2013 15:11:21 -0400
Received: from mail.windriver.com ([147.11.1.11]:60982 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753124Ab3DSTLU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Apr 2013 15:11:20 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: Ingo Molnar <mingo@kernel.org>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [PATCHv2 0/2] sched: move content out of core files for load calculations
Date: Fri, 19 Apr 2013 15:10:48 -0400
Message-ID: <1366398650-31599-1-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.8.1.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Recent activity has had a focus on moving functionally related blocks of
stuff out of sched/core.c into stand-alone files.  The code relating to load
calculations has grown significantly enough recently to warrant placing it in
a separate file.

Here we do that, and in doing so, we shed ~20k of code from sched/core.c (~10%).

A couple small static functions in the core sched.h header were also localized
to their singular user in sched/fair.c at the same time, with the goal to also
reduce the amount of "broadcast" content in that sched.h file.

Paul.
---

v2 changes:

  1) rebase from tip's sched/core (v3.9-rc1-38-gb329fd5) to today's
     tip master (v3.9-rc6-2031-g27f8b76).
  2) rename file from load_avg.c to proc.c

---

The following changes since commit 27f8b769cba5a97ffcbaae92fd4c0ed84f00e214:

  manual merge of tools/kvm (2013-04-19 13:05:17 +0200)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/paulg/linux.git for-ingo

for you to fetch changes up to dac25445169ff97142ae4f7174e3d94ce7036ad3:

  sched: move update_load_[add/sub/set] from sched.h to fair.c (2013-04-19 14:38:11 -0400)

----------------------------------------------------------------
Paul Gortmaker (2):
      sched: fork load calculation code from sched/core --> sched/proc
      sched: move update_load_[add/sub/set] from sched.h to fair.c

 kernel/sched/Makefile |   2 +-
 kernel/sched/core.c   | 569 -------------------------------------------------
 kernel/sched/fair.c   |  18 ++
 kernel/sched/proc.c   | 578 ++++++++++++++++++++++++++++++++++++++++++++++++++
 kernel/sched/sched.h  |  26 +--
 5 files changed, 605 insertions(+), 588 deletions(-)
 create mode 100644 kernel/sched/proc.c
