Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756765Ab3EGGR5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 02:17:57 -0400
Received: from mga09.intel.com ([134.134.136.24]:11499 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754175Ab3EGGR4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 02:17:56 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,627,1363158000"; 
   d="scan'208";a="309371005"
Message-ID: <51889C8A.5000806@intel.com>
Date: Tue, 07 May 2013 14:17:46 +0800
From: Alex Shi <alex.shi@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Paul Turner <pjt@google.com>, Ingo Molnar <mingo@redhat.com>,
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
Subject: Re: [PATCH v5 5/7] sched: compute runnable load avg in cpu_load and
 cpu_avg_load_per_task
References: <1367804711-30308-1-git-send-email-alex.shi@intel.com> <1367804711-30308-6-git-send-email-alex.shi@intel.com> <CAPM31RLJe19FH+RYipwm4kwtzmFHoS2xGTx4iZ9+qwDJZ_pf3A@mail.gmail.com> <20130506101936.GE13861@dyad.programming.kicks-ass.net> <CAPM31RJg87C0nO_tAaOGLaDCUAB+QmfV4LkNcwnk9j9voNocfg@mail.gmail.com> <20130506111041.GA15446@dyad.programming.kicks-ass.net>
In-Reply-To: <20130506111041.GA15446@dyad.programming.kicks-ass.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/06/2013 07:10 PM, Peter Zijlstra wrote:
>> > The runnable_avgs themselves actually have a fair bit of history in
>> > them already (50% is last 32ms); but given that they don't need to be
>> > cut-off to respond to load being migrated I'm guessing we could
>> > actually potentially get by with just "instaneous" and "use averages"
>> > where appropriate?
> Sure,. worth a try. If things fall over we can always look at it again.
> 
>> > We always end up having to re-pick/tune them based on a variety of
>> > workloads; if we can eliminate them I think it would be a win.
> Agreed, esp. the plethora of weird idx things we currently have. If we need to
> re-introduce something it would likely only be the busy case and for that we
> can immediately link to the balance interval or so.
> 
> 
> 

I like to have try bases on this patchset. :)

First, we can remove the idx, to check if the removing is fine for our
benchmarks, kbuild, dbench, tbench, hackbench, aim7, specjbb etc.

If there are some regression. we can think more.

-- 
Thanks
    Alex
