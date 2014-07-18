Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761098AbaGRJaf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 05:30:35 -0400
Received: from mga03.intel.com ([143.182.124.21]:12449 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754996AbaGRJae (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 05:30:34 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,683,1400050800"; 
   d="scan'208";a="458543305"
Date: Fri, 18 Jul 2014 09:27:52 +0800
From: Yuyang Du <yuyang.du@intel.com>
To: Dietmar Eggemann <dietmar.eggemann@arm.com>
Cc: Vincent Guittot <vincent.guittot@linaro.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        LAK <linux-arm-kernel@lists.infradead.org>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        Morten Rasmussen <Morten.Rasmussen@arm.com>,
        Mike Galbraith <efault@gmx.de>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>
Subject: Re: [PATCH v3 09/12] Revert "sched: Put rq's sched_avg under
 CONFIG_FAIR_GROUP_SCHED"
Message-ID: <20140718012752.GE2901@intel.com>
References: <1404144343-18720-1-git-send-email-vincent.guittot@linaro.org>
 <1404144343-18720-10-git-send-email-vincent.guittot@linaro.org>
 <20140710131646.GB3935@laptop>
 <CAKfTPtDzxyrzVmX016VB8j_y19wcCBVB1Rj46FYngMA+Ajft6g@mail.gmail.com>
 <20140711151304.GD3935@laptop>
 <CAKfTPtCL6mta75k9eoK724wCm7S3w7E+psa1XDrxhN1YVDONPw@mail.gmail.com>
 <53C41943.2000601@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53C41943.2000601@arm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 14, 2014 at 06:54:11PM +0100, Dietmar Eggemann wrote:
> __update_entity_runnable_avg() has an additional parameter 'running' so
> that it can be called for
> 
> a) sched_entities in update_entity_load_avg():
> 
>   __update_entity_runnable_avg(..., se->on_rq, cfs_rq->curr == se))
> 
> 
> b) rq's in update_rq_runnable_avg():
> 
>   __update_entity_runnable_avg(..., runnable, runnable);
> 
> I can see how it gives us two different signals for a sched_entity but
> for a rq?
> 
For rq, 

__update_entity_runnable_avg(..., runnable, runnable > 0)

Then, first one would be effectively CPU ConCurrency (fair and !fair) and
second one would be CPU (has task) running (or about CPU utilization for
fair and !fair), :)

Thanks,
Yuyang
