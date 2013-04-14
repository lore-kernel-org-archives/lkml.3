Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932200Ab3DNAHI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Apr 2013 20:07:08 -0400
Received: from mail-wi0-f181.google.com ([209.85.212.181]:38074 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753678Ab3DNAHH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Apr 2013 20:07:07 -0400
MIME-Version: 1.0
In-Reply-To: <CADZ9YHhdrdJk2aosJFrvbFKYj_eKbW7vypJsUKaxHyR6hpQYRw@mail.gmail.com>
References: <1365811457-31924-1-git-send-email-paul.gortmaker@windriver.com> <CADZ9YHhdrdJk2aosJFrvbFKYj_eKbW7vypJsUKaxHyR6hpQYRw@mail.gmail.com>
From: Paul Gortmaker <paul.gortmaker@windriver.com>
Date: Sat, 13 Apr 2013 20:06:33 -0400
X-Google-Sender-Auth: g0eQFAV2-M1JC12PbZkrjdywi2Y
Message-ID: <CAP=VYLroRvxadNNgHOrEu0pEwo_EUzUTH5DJZkUg6ZUHCmjpbg@mail.gmail.com>
Subject: Re: [RFC PATCH 0/2] sched: move content out of core files for load average
To: Rakib Mullick <rakib.mullick@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 13, 2013 at 12:30 AM, Rakib Mullick <rakib.mullick@gmail.com> wrote:
> On Sat, Apr 13, 2013 at 6:04 AM, Paul Gortmaker
> <paul.gortmaker@windriver.com> wrote:
>> Recent activity has had a focus on moving functionally related blocks of stuff
>> out of sched/core.c into stand-alone files.  The code relating to load average
>> calculations has grown significantly enough recently to warrant placing it in
>> a separate file.
>>
>> Here we do that, and in doing so, we shed ~20k of code from sched/core.c (~10%).

[...]

>> Paul Gortmaker (2):
>>   sched: fork load calculation code from sched/core --> sched/load_avg
>>   sched: move update_load_[add/sub/set] from sched.h to fair.c
>>
>>  kernel/sched/Makefile   |   2 +-
>>  kernel/sched/core.c     | 569 -----------------------------------------------
>>  kernel/sched/fair.c     |  18 ++
>>  kernel/sched/load_avg.c | 577 ++++++++++++++++++++++++++++++++++++++++++++++++
>>  kernel/sched/sched.h    |  26 +--
>>  5 files changed, 604 insertions(+), 588 deletions(-)
>>  create mode 100644 kernel/sched/load_avg.c
>>
>
> Is there any impact positive over vmlinuz size after these changes?

As per the above description and diffstat, it is just a straight
up code relocation, so aside from trivial differences in what
the optimizer does, I'd expect no real change at all in the
size or anything else

Paul.
--

>
> Thanks,
> Rakib
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
