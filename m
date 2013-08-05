Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755025Ab3HEHVi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 03:21:38 -0400
Received: from lgeamrelo02.lge.com ([156.147.1.126]:59025 "EHLO
	LGEAMRELO02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754936Ab3HEHVf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 03:21:35 -0400
X-AuditID: 9c93017e-b7b62ae000000eeb-5e-51ff527df0ed
Date: Mon, 5 Aug 2013 16:21:44 +0900
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Preeti U Murthy <preeti@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>, "'Ingo Molnar'" <mingo@redhat.com>,
        linux-kernel@vger.kernel.org, "'Mike Galbraith'" <efault@gmx.de>,
        "'Paul Turner'" <pjt@google.com>, "'Alex Shi'" <alex.shi@intel.com>,
        "'Vincent Guittot'" <vincent.guittot@linaro.org>,
        "'Morten Rasmussen'" <morten.rasmussen@arm.com>,
        "'Namhyung Kim'" <namhyung@kernel.org>
Subject: Re: [PATCH v2 2/3] sched: factor out code to should_we_balance()
Message-ID: <20130805072144.GA27240@lge.com>
References: <1375408223-10934-1-git-send-email-iamjoonsoo.kim@lge.com>
 <1375408223-10934-3-git-send-email-iamjoonsoo.kim@lge.com>
 <51FB341B.7060104@linux.vnet.ibm.com>
 <001601ce8f5f$7cbe1460$763a3d20$@lge.com>
 <51FB7B36.8030909@linux.vnet.ibm.com>
 <20130802103247.GL27162@twins.programming.kicks-ass.net>
 <51FF2884.4000802@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51FF2884.4000802@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 05, 2013 at 09:52:28AM +0530, Preeti U Murthy wrote:
> On 08/02/2013 04:02 PM, Peter Zijlstra wrote:
> > On Fri, Aug 02, 2013 at 02:56:14PM +0530, Preeti U Murthy wrote:
> >>>> You need to iterate over all the groups of the sched domain env->sd and
> >>>> not just the first group of env->sd like you are doing above. This is to
> >>>
> >>> I don't think so.
> >>> IIRC, env->sd->groups always means local group,
> >>> so we don't need to find our group by iterating over all the groups.
> >>
> >> Take a look at update_sd_lb_stats(). That should clarify this. There is
> >> an exclusive
> >> local_group check there.
> >>
> >> sd->groups points to the first group in the list of groups under this sd.
> > 
> > Take a look at: 88b8dac0a
> > 
> Ah ok! Thanks for this pointer.
> 
> Apologies for having overlooked the fact that the sd->groups always
> points to the group to which the balance_cpu belongs. And subsequent
> dst_cpus for retries of load balancing also belong to the same group as
> the balance_cpu.
> 
> This patch thus looks fine to me.

Okay!

> 
> Regards
> Preeti U Murthy
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
