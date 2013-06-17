Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755522Ab3FQOQB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 10:16:01 -0400
Received: from mga14.intel.com ([143.182.124.37]:33454 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751140Ab3FQOQA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 10:16:00 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,881,1363158000"; 
   d="scan'208";a="351087987"
Message-ID: <51BF19FE.80702@intel.com>
Date: Mon, 17 Jun 2013 22:15:26 +0800
From: Alex Shi <alex.shi@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120912 Thunderbird/15.0.1
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
        Michael Wang <wangyun@linux.vnet.ibm.com>,
        Jason Low <jason.low2@hp.com>,
        Changlong Xie <changlongx.xie@intel.com>, sgruszka@redhat.com,
        =?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>
Subject: Re: [patch v8 8/9] sched: consider runnable load average in move_tasks
References: <1370589652-24549-1-git-send-email-alex.shi@intel.com> <1370589652-24549-9-git-send-email-alex.shi@intel.com> <CAPM31RJs=A+j5NtSr4TXzQ8sAHMSkz+cNoZjOhsmc2p2HksZNg@mail.gmail.com> <51BF16C6.7070009@intel.com>
In-Reply-To: <51BF16C6.7070009@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/17/2013 10:01 PM, Alex Shi wrote:
> On 06/17/2013 06:58 PM, Paul Turner wrote:
>>>> +               unsigned long tmp_rla;
>>>> +               tmp_rla = tg->parent->cfs_rq[cpu]->runnable_load_avg + 1;
>>>> +
>>>>                 load = tg->parent->cfs_rq[cpu]->h_load;
>>>> -               load *= tg->se[cpu]->load.weight;
>>>> -               load /= tg->parent->cfs_rq[cpu]->load.weight + 1;
>>>> +               load *= tg->se[cpu]->avg.load_avg_contrib;
>>>> +               load /= tmp_rla;
>> Why do we need the temporary here?
>>
> 
> you'r right. tmp_rla is not necessary here.
> 

Sorry, not, tmp_rla is a imply type casting. otherwise long /= u64; has
building issue on 32 bit according to Morten.
and a clear type casting cross 2 lines.

-- 
Thanks
    Alex
