Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932607Ab3FQKAa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 06:00:30 -0400
Received: from mga11.intel.com ([192.55.52.93]:38664 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932373Ab3FQKA3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 06:00:29 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,880,1363158000"; 
   d="scan'208";a="354636971"
Message-ID: <51BEDE09.1050307@intel.com>
Date: Mon, 17 Jun 2013 17:59:37 +0800
From: Alex Shi <alex.shi@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Paul Turner <pjt@google.com>
CC: Vincent Guittot <vincent.guittot@linaro.org>,
        "mingo@redhat.com" <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Borislav Petkov <bp@alien8.de>, Namhyung Kim <namhyung@kernel.org>,
        Mike Galbraith <efault@gmx.de>,
        Morten Rasmussen <morten.rasmussen@arm.com>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Mel Gorman <mgorman@suse.de>, Rik van Riel <riel@redhat.com>,
        Michael Wang <wangyun@linux.vnet.ibm.com>,
        Jason Low <jason.low2@hp.com>
Subject: Re: [RFC patch 1/4] sched: change cfs_rq load avg to unsigned long
References: <1370590169-24804-1-git-send-email-alex.shi@intel.com> <1370590169-24804-2-git-send-email-alex.shi@intel.com> <CAKfTPtA=pVQ69pfv97kgcdawgHbQbkbXW4sFGN6_bAzZcD9b9Q@mail.gmail.com> <51B2948A.60309@intel.com> <CAPM31RK6+kdEcD3xqdvu0dsvL1THkgGnJoU3f7SLx_+9uqym-Q@mail.gmail.com>
In-Reply-To: <CAPM31RK6+kdEcD3xqdvu0dsvL1THkgGnJoU3f7SLx_+9uqym-Q@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/17/2013 05:49 PM, Paul Turner wrote:
>>> >> Hi Alex,
>>> >>
>>> >> I just want to point out that we can't have more than 48388 tasks with
>>> >> highest priority on a runqueue with an unsigned long on a 32 bits
>>> >> system.  I don't know if we can reach such kind of limit on a 32bits
>>> >> machine ? For sure, not on an embedded system.
> This should be ok.
> 
> Note that:
>   runnable_load_avg = \Sum se->load_avg_contrib <= \Sum
> se->load.weight = cfs_rq->load.weight
> 
> And load_weight uses unsigned longs also.
> 
> blocked_load_avg must be also safe since anything appearing in blocked
> load could have appeared in runnable load and we've said that was ok
> above.
> 
> Reviewed-By: Paul Turner <pjt@google.com>
> 

thanks for review!

-- 
Thanks
    Alex
