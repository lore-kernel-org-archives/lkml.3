Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752395Ab3EFI6I (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 04:58:08 -0400
Received: from mga14.intel.com ([143.182.124.37]:15889 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752066Ab3EFI6G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 04:58:06 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,620,1363158000"; 
   d="scan'208";a="329445660"
Message-ID: <5187708A.20103@intel.com>
Date: Mon, 06 May 2013 16:57:46 +0800
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
Subject: Re: [PATCH v5 2/7] sched: remove SMP cover for runnable variables
 in cfs_rq
References: <1367804711-30308-1-git-send-email-alex.shi@intel.com> <1367804711-30308-3-git-send-email-alex.shi@intel.com> <CAPM31R+oBDRF4geM451-ySCtkU1NpqFT_R1mtB95jV-pnLBimQ@mail.gmail.com>
In-Reply-To: <CAPM31R+oBDRF4geM451-ySCtkU1NpqFT_R1mtB95jV-pnLBimQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/06/2013 04:01 PM, Paul Turner wrote:
> On Sun, May 5, 2013 at 6:45 PM, Alex Shi <alex.shi@intel.com> wrote:
>> The following variables were covered under CONFIG_SMP in struct cfs_rq.
>> but similar runnable variables work for UP in struct rq and task_group.
>> like rq->avg, task_group->load_avg.
>> So move them out, they also can work with UP.
> 
> Is there a proposed use-case for UP?  My apologies if I missed it in
> an alternate patch.

> It would seem the only possibly useful thing there would the the
> per-rq average for p-state selection; but we can get that without the
> per-entity values already.


Do you mean to move the rq->avg and task_group->load_avg into CONFIG_SMP?

-- 
Thanks
    Alex
