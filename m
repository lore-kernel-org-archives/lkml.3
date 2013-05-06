Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754202Ab3EFLMi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 07:12:38 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:33925
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754001Ab3EFLMh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 07:12:37 -0400
Date: Mon, 6 May 2013 13:10:41 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Paul Turner <pjt@google.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Alex Shi <alex.shi@intel.com>,
        Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
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
Message-ID: <20130506111041.GA15446@dyad.programming.kicks-ass.net>
References: <1367804711-30308-1-git-send-email-alex.shi@intel.com>
 <1367804711-30308-6-git-send-email-alex.shi@intel.com>
 <CAPM31RLJe19FH+RYipwm4kwtzmFHoS2xGTx4iZ9+qwDJZ_pf3A@mail.gmail.com>
 <20130506101936.GE13861@dyad.programming.kicks-ass.net>
 <CAPM31RJg87C0nO_tAaOGLaDCUAB+QmfV4LkNcwnk9j9voNocfg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPM31RJg87C0nO_tAaOGLaDCUAB+QmfV4LkNcwnk9j9voNocfg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 06, 2013 at 03:33:45AM -0700, Paul Turner wrote:
> Yeah, most of the rationale is super hand-wavy; especially the fairly
> arbitrary choice of periods (e.g. busy_idx vs newidle).
> 
> I think the other rationale is:
>   For smaller indicies (e.g. newidle) we speed up response time by
> also cutting motion out of the averages.
> 
> The runnable_avgs themselves actually have a fair bit of history in
> them already (50% is last 32ms); but given that they don't need to be
> cut-off to respond to load being migrated I'm guessing we could
> actually potentially get by with just "instaneous" and "use averages"
> where appropriate?

Sure,. worth a try. If things fall over we can always look at it again.

> We always end up having to re-pick/tune them based on a variety of
> workloads; if we can eliminate them I think it would be a win.

Agreed, esp. the plethora of weird idx things we currently have. If we need to
re-introduce something it would likely only be the busy case and for that we
can immediately link to the balance interval or so.



