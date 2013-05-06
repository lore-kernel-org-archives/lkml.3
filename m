Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753132Ab3EFOUI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 10:20:08 -0400
Received: from mail.windriver.com ([147.11.1.11]:65521 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752412Ab3EFOUH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 10:20:07 -0400
Date: Mon, 6 May 2013 10:21:03 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: Ingo Molnar <mingo@kernel.org>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHv2 0/2] sched: move content out of core files for load
 calculations
Message-ID: <20130506142103.GA29610@windriver.com>
References: <1366398650-31599-1-git-send-email-paul.gortmaker@windriver.com>
 <20130421091846.GE31470@gmail.com>
 <20130506092657.GA9227@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20130506092657.GA9227@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Re: [PATCHv2 0/2] sched: move content out of core files for load calculations] On 06/05/2013 (Mon 11:26) Ingo Molnar wrote:

> 
> * Ingo Molnar <mingo@kernel.org> wrote:
> 
> > 
> > * Paul Gortmaker <paul.gortmaker@windriver.com> wrote:
> > 
> > > Recent activity has had a focus on moving functionally related blocks of
> > > stuff out of sched/core.c into stand-alone files.  The code relating to load
> > > calculations has grown significantly enough recently to warrant placing it in
> > > a separate file.
> > > 
> > > Here we do that, and in doing so, we shed ~20k of code from sched/core.c (~10%).
> > > 
> > > A couple small static functions in the core sched.h header were also localized
> > > to their singular user in sched/fair.c at the same time, with the goal to also
> > > reduce the amount of "broadcast" content in that sched.h file.
> > > 
> > > Paul.
> > > ---
> > > 
> > > v2 changes:
> > > 
> > >   1) rebase from tip's sched/core (v3.9-rc1-38-gb329fd5) to today's
> > >      tip master (v3.9-rc6-2031-g27f8b76).
> > >   2) rename file from load_avg.c to proc.c
> > 
> > Thanks, looks good to me. Note, I'll try to apply this after the initial 
> > round of trees went to Linus in the merge window, to reduce interactions 
> > between the trees. [...]
> 
> Ok, all relevant trees are now upstream - mind sending a refreshed series 
> against upstream merge commit 534c97b0950b or later?

Sure.  After putting them on top of 534c97b095, I re-checked with a
quick defconfig build.  Also in comparison to v2, the patches are
unchanged except for trivial line offset deltas.  So it should be OK.

Thanks,
Paul.

---

The following changes since commit 534c97b0950b1967bca1c753aeaed32f5db40264:

  Merge branch 'timers-nohz-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip (2013-05-05 13:23:27 -0700)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/paulg/linux.git for-ingo

for you to fetch changes up to 54aecbbcfcbea684257ebe674251f148ee340412:

  sched: move update_load_[add/sub/set] from sched.h to fair.c (2013-05-06 09:39:50 -0400)

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
