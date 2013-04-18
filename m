Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967562Ab3DRXoO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Apr 2013 19:44:14 -0400
Received: from mail-lb0-f172.google.com ([209.85.217.172]:61298 "EHLO
	mail-lb0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967409Ab3DRXoM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Apr 2013 19:44:12 -0400
MIME-Version: 1.0
In-Reply-To: <20130418231351.GA25621@windriver.com>
References: <1365811457-31924-1-git-send-email-paul.gortmaker@windriver.com>
 <20130415093330.GC17715@gmail.com> <1366283681.19383.5.camel@laptop>
 <51701722.1070407@windriver.com> <CADZ9YHgq1UyyJUaF6j9e7pgwmz4rZmu3YzJrWRXcWCgh7_f+qg@mail.gmail.com>
 <20130418231351.GA25621@windriver.com>
From: Paul Turner <pjt@google.com>
Date: Thu, 18 Apr 2013 16:43:40 -0700
Message-ID: <CAPM31R+w2=GBi0tarvh8cDU2e99cUnOE89dsjAYuueYfOppjtQ@mail.gmail.com>
Subject: Re: [RFC PATCH 0/2] sched: move content out of core files for load average
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: Rakib Mullick <rakib.mullick@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We could use a name along the lines of "load_index.c"; it calls to
mind where we actually consume these values and (being specific) is
less overloaded than load_avg.

On Thu, Apr 18, 2013 at 4:13 PM, Paul Gortmaker
<paul.gortmaker@windriver.com> wrote:
> [Re: [RFC PATCH 0/2] sched: move content out of core files for load average] On 18/04/2013 (Thu 23:06) Rakib Mullick wrote:
>
>> On Thu, Apr 18, 2013 at 9:54 PM, Paul Gortmaker
>> <paul.gortmaker@windriver.com> wrote:
>> > On 13-04-18 07:14 AM, Peter Zijlstra wrote:
>> >> On Mon, 2013-04-15 at 11:33 +0200, Ingo Molnar wrote:
>> >>> * Paul Gortmaker <paul.gortmaker@windriver.com> wrote:
>> >>>
>> >>>> Recent activity has had a focus on moving functionally related blocks of stuff
>> >>>> out of sched/core.c into stand-alone files.  The code relating to load average
>> >>>> calculations has grown significantly enough recently to warrant placing it in a
>> >>>> separate file.
>> >>>>
>> >>>> Here we do that, and in doing so, we shed ~20k of code from sched/core.c (~10%).
>> >>>>
>> >>>> A couple small static functions in the core sched.h header were also localized
>> >>>> to their singular user in sched/fair.c at the same time, with the goal to also
>> >>>> reduce the amount of "broadcast" content in that sched.h file.
>> >>>
>> >>> Nice!
>> >>>
>> >>> Peter, is this (and the naming of the new file) fine with you too?
>> >>
>> >> Yes and no.. that is I do like the change, but I don't like the
>> >> filename. We have _waaaay_ too many different things we call load_avg.
>> >>
>> >> That said, I'm having a somewhat hard time coming up with a coherent
>> >> alternative :/
>> >
>> > Several of the relocated functions start their name with "calc_load..."
>> > Does "calc_load.c" sound any better?
>> >
>> How about sched_load.c ?
>
> No, that doesn't work since it duplicates the path info in the file
> name -- something that none of the other kernel/sched/*.c files do.
> Do a "ls -1 kernel/sched" to see what I mean if it is not clear.
>
> I honestly didn't spend a lot of time thinking about the file name.
> I chose load_avg.c since it had a parallel to the /proc/loadavg that
> linux has had since the early 1990s.  I have no real attachment
> to that name, but at the same time I'd like to avoid having name
> choice become a bikeshedding event...
>
> Thanks,
> Paul.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
