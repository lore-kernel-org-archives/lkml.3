Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756569Ab3DRXNL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Apr 2013 19:13:11 -0400
Received: from mail1.windriver.com ([147.11.146.13]:50717 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753871Ab3DRXNJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Apr 2013 19:13:09 -0400
Date: Thu, 18 Apr 2013 19:13:51 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: Rakib Mullick <rakib.mullick@gmail.com>
CC: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH 0/2] sched: move content out of core files for load
 average
Message-ID: <20130418231351.GA25621@windriver.com>
References: <1365811457-31924-1-git-send-email-paul.gortmaker@windriver.com>
 <20130415093330.GC17715@gmail.com>
 <1366283681.19383.5.camel@laptop>
 <51701722.1070407@windriver.com>
 <CADZ9YHgq1UyyJUaF6j9e7pgwmz4rZmu3YzJrWRXcWCgh7_f+qg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <CADZ9YHgq1UyyJUaF6j9e7pgwmz4rZmu3YzJrWRXcWCgh7_f+qg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Re: [RFC PATCH 0/2] sched: move content out of core files for load average] On 18/04/2013 (Thu 23:06) Rakib Mullick wrote:

> On Thu, Apr 18, 2013 at 9:54 PM, Paul Gortmaker
> <paul.gortmaker@windriver.com> wrote:
> > On 13-04-18 07:14 AM, Peter Zijlstra wrote:
> >> On Mon, 2013-04-15 at 11:33 +0200, Ingo Molnar wrote:
> >>> * Paul Gortmaker <paul.gortmaker@windriver.com> wrote:
> >>>
> >>>> Recent activity has had a focus on moving functionally related blocks of stuff
> >>>> out of sched/core.c into stand-alone files.  The code relating to load average
> >>>> calculations has grown significantly enough recently to warrant placing it in a
> >>>> separate file.
> >>>>
> >>>> Here we do that, and in doing so, we shed ~20k of code from sched/core.c (~10%).
> >>>>
> >>>> A couple small static functions in the core sched.h header were also localized
> >>>> to their singular user in sched/fair.c at the same time, with the goal to also
> >>>> reduce the amount of "broadcast" content in that sched.h file.
> >>>
> >>> Nice!
> >>>
> >>> Peter, is this (and the naming of the new file) fine with you too?
> >>
> >> Yes and no.. that is I do like the change, but I don't like the
> >> filename. We have _waaaay_ too many different things we call load_avg.
> >>
> >> That said, I'm having a somewhat hard time coming up with a coherent
> >> alternative :/
> >
> > Several of the relocated functions start their name with "calc_load..."
> > Does "calc_load.c" sound any better?
> >
> How about sched_load.c ?

No, that doesn't work since it duplicates the path info in the file
name -- something that none of the other kernel/sched/*.c files do.
Do a "ls -1 kernel/sched" to see what I mean if it is not clear.

I honestly didn't spend a lot of time thinking about the file name.
I chose load_avg.c since it had a parallel to the /proc/loadavg that
linux has had since the early 1990s.  I have no real attachment
to that name, but at the same time I'd like to avoid having name
choice become a bikeshedding event...

Thanks,
Paul.
