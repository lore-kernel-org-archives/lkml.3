Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755632Ab3FQAep (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Jun 2013 20:34:45 -0400
Received: from mga03.intel.com ([143.182.124.21]:15704 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755553Ab3FQAeg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Jun 2013 20:34:36 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,876,1363158000"; 
   d="scan'208";a="350795001"
Message-ID: <51BE5958.6020602@intel.com>
Date: Mon, 17 Jun 2013 08:33:28 +0800
From: Alex Shi <alex.shi@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
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
References: <1370589652-24549-1-git-send-email-alex.shi@intel.com> <1370589652-24549-4-git-send-email-alex.shi@intel.com> <CALZhoSS=xMgW8sgjL4qS+LkqAucFptJnOa2Yt53rNwJPEpA0Hg@mail.gmail.com> <51BB21D8.6000109@intel.com> <CALZhoSTxKUD2oE7YUFvwASKqnpJBgPP6mnJG3KhFUre5OqYBFQ@mail.gmail.com>
In-Reply-To: <CALZhoSTxKUD2oE7YUFvwASKqnpJBgPP6mnJG3KhFUre5OqYBFQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/15/2013 08:09 PM, Lei Wen wrote:
>>>>> >>> > and make forking balancing imbalance since incorrect load_avg_contrib.
>>>>> >>> >
>>>>> >>> > Further more, Morten Rasmussen notice some tasks were not launched at
>>>>> >>> > once after created. So Paul and Peter suggest giving a start value for
>>>>> >>> > new task runnable avg time same as sched_slice().
>>> >> I am confused at this comment, how set slice to runnable avg would change
>>> >> the behavior of "some tasks were not launched at once after created"?
>> >
>> > I also don't know the details on Morten's machine. but just guess, there
>> > are much tasks on in the run queue. the minimum load avg make the new
>> > task wait its time...
> Is there some possibility that since task structure is allocated without being
> set to 0, and it cause the imbalance between runqueues. Then the new forked
> is migrated to other cpus, so that it cause its execution being delayed?

Is there sth weird happens?
The task should be running a while before migration. and periodic load
balance also need some time to happen. So generally, it has no such worries.

-- 
Thanks
    Alex
