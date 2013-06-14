Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753293Ab3FNOAD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jun 2013 10:00:03 -0400
Received: from mga02.intel.com ([134.134.136.20]:55572 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753099Ab3FNOAB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jun 2013 10:00:01 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,866,1363158000"; 
   d="scan'208";a="353459569"
Message-ID: <51BB21D8.6000109@intel.com>
Date: Fri, 14 Jun 2013 21:59:52 +0800
From: Alex Shi <alex.shi@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120912 Thunderbird/15.0.1
MIME-Version: 1.0
To: Lei Wen <adrian.wenl@gmail.com>
CC: mingo@redhat.com, peterz@infradead.org, tglx@linutronix.de,
        akpm@linux-foundation.org, bp@alien8.de, pjt@google.com,
        namhyung@kernel.org, efault@gmx.de, morten.rasmussen@arm.com,
        vincent.guittot@linaro.org, preeti@linux.vnet.ibm.com,
        viresh.kumar@linaro.org, linux-kernel@vger.kernel.org, mgorman@suse.de,
        riel@redhat.com, wangyun@linux.vnet.ibm.com,
        Jason Low <jason.low2@hp.com>,
        Changlong Xie <changlongx.xie@intel.com>, sgruszka@redhat.com,
        fweisbec@gmail.com
Subject: Re: [patch v8 3/9] sched: set initial value of runnable avg for new
 forked task
References: <1370589652-24549-1-git-send-email-alex.shi@intel.com> <1370589652-24549-4-git-send-email-alex.shi@intel.com> <CALZhoSS=xMgW8sgjL4qS+LkqAucFptJnOa2Yt53rNwJPEpA0Hg@mail.gmail.com>
In-Reply-To: <CALZhoSS=xMgW8sgjL4qS+LkqAucFptJnOa2Yt53rNwJPEpA0Hg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/14/2013 06:02 PM, Lei Wen wrote:
>> >         enqueue_entity
>> >             enqueue_entity_load_avg
>> >
>> > and make forking balancing imbalance since incorrect load_avg_contrib.
>> >
>> > Further more, Morten Rasmussen notice some tasks were not launched at
>> > once after created. So Paul and Peter suggest giving a start value for
>> > new task runnable avg time same as sched_slice().
> I am confused at this comment, how set slice to runnable avg would change
> the behavior of "some tasks were not launched at once after created"?

I also don't know the details on Morten's machine. but just guess, there
are much tasks on in the run queue. the minimum load avg make the new
task wait its time...
> 
> IMHO, I could only tell that for the new forked task, it could be run if current
> task already be set as need_resched, and preempt_schedule or
> preempt_schedule_irq
> is called.
> 
> Since the set slice to avg behavior would not affect this task's vruntime,
> and hence cannot make current running task be need_sched, if
> previously it cannot.
> 
> Could you help correct if I am wrong at somewhere? ....
> 
> Thanks,


-- 
Thanks
    Alex
