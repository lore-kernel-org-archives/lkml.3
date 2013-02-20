Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935519Ab3BTNea (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 08:34:30 -0500
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:44546
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935090Ab3BTNe3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 08:34:29 -0500
Message-ID: <1361367264.10155.31.camel@laptop>
Subject: Re: [patch v5 06/15] sched: log the cpu utilization at rq
From: Peter Zijlstra <peterz@infradead.org>
To: Preeti U Murthy <preeti@linux.vnet.ibm.com>
Cc: Alex Shi <alex.shi@intel.com>, torvalds@linux-foundation.org,
        mingo@redhat.com, tglx@linutronix.de, akpm@linux-foundation.org,
        arjan@linux.intel.com, bp@alien8.de, pjt@google.com,
        namhyung@kernel.org, efault@gmx.de, vincent.guittot@linaro.org,
        gregkh@linuxfoundation.org, viresh.kumar@linaro.org,
        linux-kernel@vger.kernel.org, morten.rasmussen@arm.com
Date: Wed, 20 Feb 2013 14:34:24 +0100
In-Reply-To: <5124BD07.4050401@linux.vnet.ibm.com>
References: <1361164062-20111-1-git-send-email-alex.shi@intel.com>
	 <1361164062-20111-7-git-send-email-alex.shi@intel.com>
	 <1361352643.10155.4.camel@laptop> <5124BD07.4050401@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-02-20 at 17:39 +0530, Preeti U Murthy wrote:
> Hi,
> 
> >>  /*
> >>   * This is the main, per-CPU runqueue data structure.
> >>   *
> >> @@ -481,6 +484,7 @@ struct rq {
> >>  #endif
> >>  
> >>  	struct sched_avg avg;
> >> +	unsigned int util;
> >>  };
> >>  
> >>  static inline int cpu_of(struct rq *rq)
> > 
> > You don't actually compute the rq utilization, you only compute the
> > utilization as per the fair class, so if there's significant RT activity
> > it'll think the cpu is under-utilized, whihc I think will result in the
> > wrong thing.
> 
> Correct me if I am wrong,but isn't the current load balancer also
> disregarding the real time tasks to calculate the domain/group/cpu level
> load too?

Nope, the rt utilization affects the cpu_power, thereby correcting the
weight stuff.


