Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751923Ab3DMEaJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Apr 2013 00:30:09 -0400
Received: from mail-vb0-f44.google.com ([209.85.212.44]:35914 "EHLO
	mail-vb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751657Ab3DMEaI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Apr 2013 00:30:08 -0400
MIME-Version: 1.0
In-Reply-To: <1365811457-31924-1-git-send-email-paul.gortmaker@windriver.com>
References: <1365811457-31924-1-git-send-email-paul.gortmaker@windriver.com>
Date: Sat, 13 Apr 2013 10:30:06 +0600
Message-ID: <CADZ9YHhdrdJk2aosJFrvbFKYj_eKbW7vypJsUKaxHyR6hpQYRw@mail.gmail.com>
Subject: Re: [RFC PATCH 0/2] sched: move content out of core files for load average
From: Rakib Mullick <rakib.mullick@gmail.com>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 13, 2013 at 6:04 AM, Paul Gortmaker
<paul.gortmaker@windriver.com> wrote:
> Recent activity has had a focus on moving functionally related blocks of stuff
> out of sched/core.c into stand-alone files.  The code relating to load average
> calculations has grown significantly enough recently to warrant placing it in
> a separate file.
>
> Here we do that, and in doing so, we shed ~20k of code from sched/core.c (~10%).
>
> A couple small static functions in the core sched.h header were also localized
> to their singular user in sched/fair.c at the same time, with the goal to also
> reduce the amount of "broadcast" content in that sched.h file.
>
> Paul.
> ---
>
> [ Patches sent here are tested on tip's sched/core, i.e. v3.9-rc1-38-gb329fd5
>
>   Assuming that this change is OK with folks, the timing can be whatever is most
>   convenient -- i.e. I can update/respin it close to the end of the merge window
>   for what will be v3.10-rc1, if that is what minimizes the inconvenience to folks
>   who might be changing the code that is relocated here. ]
>
> Paul Gortmaker (2):
>   sched: fork load calculation code from sched/core --> sched/load_avg
>   sched: move update_load_[add/sub/set] from sched.h to fair.c
>
>  kernel/sched/Makefile   |   2 +-
>  kernel/sched/core.c     | 569 -----------------------------------------------
>  kernel/sched/fair.c     |  18 ++
>  kernel/sched/load_avg.c | 577 ++++++++++++++++++++++++++++++++++++++++++++++++
>  kernel/sched/sched.h    |  26 +--
>  5 files changed, 604 insertions(+), 588 deletions(-)
>  create mode 100644 kernel/sched/load_avg.c
>

Is there any impact positive over vmlinuz size after these changes?

Thanks,
Rakib
