Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752701Ab3EFJIf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 05:08:35 -0400
Received: from mail-la0-f47.google.com ([209.85.215.47]:59645 "EHLO
	mail-la0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752825Ab3EFJId (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 05:08:33 -0400
MIME-Version: 1.0
In-Reply-To: <5187708A.20103@intel.com>
References: <1367804711-30308-1-git-send-email-alex.shi@intel.com>
 <1367804711-30308-3-git-send-email-alex.shi@intel.com> <CAPM31R+oBDRF4geM451-ySCtkU1NpqFT_R1mtB95jV-pnLBimQ@mail.gmail.com>
 <5187708A.20103@intel.com>
From: Paul Turner <pjt@google.com>
Date: Mon, 6 May 2013 02:08:02 -0700
Message-ID: <CAPM31R+-zeuquH7ozjjZEGX03aWoek1xJ5LgsaVP5j1WnxzzRw@mail.gmail.com>
Subject: Re: [PATCH v5 2/7] sched: remove SMP cover for runnable variables in cfs_rq
To: Alex Shi <alex.shi@intel.com>
Cc: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Borislav Petkov <bp@alien8.de>, Namhyung Kim <namhyung@kernel.org>,
        Mike Galbraith <efault@gmx.de>,
        Morten Rasmussen <morten.rasmussen@arm.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        LKML <linux-kernel@vger.kernel.org>, Mel Gorman <mgorman@suse.de>,
        Rik van Riel <riel@redhat.com>,
        Michael Wang <wangyun@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 6, 2013 at 1:57 AM, Alex Shi <alex.shi@intel.com> wrote:
> On 05/06/2013 04:01 PM, Paul Turner wrote:
>> On Sun, May 5, 2013 at 6:45 PM, Alex Shi <alex.shi@intel.com> wrote:
>>> The following variables were covered under CONFIG_SMP in struct cfs_rq.
>>> but similar runnable variables work for UP in struct rq and task_group.
>>> like rq->avg, task_group->load_avg.
>>> So move them out, they also can work with UP.
>>
>> Is there a proposed use-case for UP?  My apologies if I missed it in
>> an alternate patch.
>
>> It would seem the only possibly useful thing there would the the
>> per-rq average for p-state selection; but we can get that without the
>> per-entity values already.
>
>
> Do you mean to move the rq->avg and task_group->load_avg into CONFIG_SMP?

More generally:  Why do we need them in !CONFIG_SMP?

[ I was suggesting (potentially) using only rq->avg in the !CONFIG_SMP case. ]


>
> --
> Thanks
>     Alex
