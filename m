Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932489Ab3EGDZG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 23:25:06 -0400
Received: from mga03.intel.com ([143.182.124.21]:10816 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758975Ab3EGDZE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 23:25:04 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,625,1363158000"; 
   d="scan'208";a="237828096"
Message-ID: <51887404.4060102@intel.com>
Date: Tue, 07 May 2013 11:24:52 +0800
From: Alex Shi <alex.shi@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Paul Turner <pjt@google.com>
CC: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
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
Subject: Re: [PATCH v5 3/7] sched: set initial value of runnable avg for new
 forked task
References: <1367804711-30308-1-git-send-email-alex.shi@intel.com> <1367804711-30308-4-git-send-email-alex.shi@intel.com> <CAPM31RJg7t8f1H-dZwzP1c-0HHb_=8twidX74gS2NfyQhHUhCw@mail.gmail.com> <5187760D.8060900@intel.com> <CAPM31RKiCfSZ=hJ9P7WOH6AC8uj6b06mEM6K0WCTYXC7OJAq7A@mail.gmail.com> <51886460.3020009@intel.com> <CAPM31RLsip-PMY73oq58gyi42EQ+-upmPpMQFkukVBX6LTwtCw@mail.gmail.com>
In-Reply-To: <CAPM31RLsip-PMY73oq58gyi42EQ+-upmPpMQFkukVBX6LTwtCw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/07/2013 11:06 AM, Paul Turner wrote:
>> > Thanks Paul!
>> > It seems work with this change if new __sched_fork move after the
>> > p->sched_reset_on_fork setting.
>> >
>> > But why we initial avg sum to 1024? new task may goes to sleep, the
>> > initial 1024 give a unreasonable initial value.
>> >
>> > guess let the task accumulate itself avg sum and period is more natural.
> 1024 is a full single unit period representing ~1ms of time.
> 
> The reason to store a small initial "observation" here is so that as
> when we reach our next period edge our load converges (presumably
> down) towards its true target more smoothly; as well as providing a
> task additional protection from being considered "small" through
> start-up.
> 

It will give new forked task 1 ms extra running time. That will bring
incorrect info if the new forked goes to sleep a while.
But this info should benefit to some benchmarks like aim7,
pthread_cond_broadcast. So I am convinced. :)

What's your opinion of this, Peter?

-- 
Thanks
    Alex
