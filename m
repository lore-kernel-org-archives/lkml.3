Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755135Ab3EFQUs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 12:20:48 -0400
Received: from e23smtp04.au.ibm.com ([202.81.31.146]:32861 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754341Ab3EFQUp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 12:20:45 -0400
Message-ID: <51878A48.6040003@linux.vnet.ibm.com>
Date: Mon, 06 May 2013 16:17:36 +0530
From: Preeti U Murthy <preeti@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Paul Turner <pjt@google.com>
CC: Alex Shi <alex.shi@intel.com>, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Borislav Petkov <bp@alien8.de>, Namhyung Kim <namhyung@kernel.org>,
        Mike Galbraith <efault@gmx.de>,
        Morten Rasmussen <morten.rasmussen@arm.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        LKML <linux-kernel@vger.kernel.org>, Mel Gorman <mgorman@suse.de>,
        Rik van Riel <riel@redhat.com>,
        Michael Wang <wangyun@linux.vnet.ibm.com>
Subject: Re: [PATCH v5 2/7] sched: remove SMP cover for runnable variables
 in cfs_rq
References: <1367804711-30308-1-git-send-email-alex.shi@intel.com> <1367804711-30308-3-git-send-email-alex.shi@intel.com> <CAPM31R+oBDRF4geM451-ySCtkU1NpqFT_R1mtB95jV-pnLBimQ@mail.gmail.com> <5187708A.20103@intel.com> <CAPM31R+-zeuquH7ozjjZEGX03aWoek1xJ5LgsaVP5j1WnxzzRw@mail.gmail.com>
In-Reply-To: <CAPM31R+-zeuquH7ozjjZEGX03aWoek1xJ5LgsaVP5j1WnxzzRw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13050613-9264-0000-0000-000003AED893
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Paul,

On 05/06/2013 02:38 PM, Paul Turner wrote:
> On Mon, May 6, 2013 at 1:57 AM, Alex Shi <alex.shi@intel.com> wrote:
>> On 05/06/2013 04:01 PM, Paul Turner wrote:
>>> On Sun, May 5, 2013 at 6:45 PM, Alex Shi <alex.shi@intel.com> wrote:
>>>> The following variables were covered under CONFIG_SMP in struct cfs_rq.
>>>> but similar runnable variables work for UP in struct rq and task_group.
>>>> like rq->avg, task_group->load_avg.
>>>> So move them out, they also can work with UP.
>>>
>>> Is there a proposed use-case for UP?  My apologies if I missed it in
>>> an alternate patch.
>>
>>> It would seem the only possibly useful thing there would the the
>>> per-rq average for p-state selection; but we can get that without the
>>> per-entity values already.
>>
>>
>> Do you mean to move the rq->avg and task_group->load_avg into CONFIG_SMP?
> 
> More generally:  Why do we need them in !CONFIG_SMP?
> 
> [ I was suggesting (potentially) using only rq->avg in the !CONFIG_SMP case. ]

If you were to have runnable_load_avg and blocked_load_avg  of cfs_rq
under CONFIG_SMP, how will tg->load_avg get updated? tg->load_avg is not
SMP dependent.

tg->load_avg in-turn is used to decide the CPU shares of the sched
entities on the processor right?

Thanks

Regards
Preeti U Murthy

