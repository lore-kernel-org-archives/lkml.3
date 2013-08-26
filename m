Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756751Ab3HZLjW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 07:39:22 -0400
Received: from merlin.infradead.org ([205.233.59.134]:34543 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756707Ab3HZLjR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 07:39:17 -0400
Date: Mon, 26 Aug 2013 13:38:59 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Paul Turner <pjt@google.com>
Cc: Ingo Molnar <mingo@kernel.org>, Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Mike Galbraith <efault@gmx.de>,
        Alex Shi <alex.shi@intel.com>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Morten Rasmussen <morten.rasmussen@arm.com>,
        Namhyung Kim <namhyung@kernel.org>, Lei Wen <leiwen@marvell.com>,
        Rik van Riel <riel@surriel.com>, Joonsoo Kim <js1304@gmail.com>
Subject: Re: [PATCH 03/10] sched: Clean-up struct sd_lb_stat
Message-ID: <20130826113859.GI31370@twins.programming.kicks-ass.net>
References: <20130819160058.539049611@infradead.org>
 <20130819160425.230612223@infradead.org>
 <CAPM31RJtQKZzb-POVY_ffoZ++vF2uZC9TkPiib-FXUrXF5UEKw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPM31RJtQKZzb-POVY_ffoZ++vF2uZC9TkPiib-FXUrXF5UEKw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 24, 2013 at 03:09:38AM -0700, Paul Turner wrote:
> On Mon, Aug 19, 2013 at 9:01 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> > +       struct sg_lb_stats *this, *busiest;
> 
> "this" is a little confusing to read; mainly because elsewhere we've
> tied this to "this cpu" whereas the local sched group is arger.  (Not
> to mention the obvious OOP-land overloading of "this->".)
> 
> Perhaps %s/this/local/ for sg_lb_stat references?  Including this_stat
> -> local_stat on sd_lb_stats?

fair enough, I'll edit the thing to be local.

> > @@ -4952,15 +4950,16 @@ find_busiest_group(struct lb_env *env)
> >                  * there is no imbalance between this and busiest group
> >                  * wrt to idle cpu's, it is balanced.
> >                  */
> > -               if ((sds.this_idle_cpus <= sds.busiest_idle_cpus + 1) &&
> > -                   sds.busiest_nr_running <= sds.busiest_group_weight)
> > +               if ((this->idle_cpus <= busiest->idle_cpus + 1) &&
> > +                   busiest->sum_nr_running <= busiest->group_weight)
> 
> While we're improving readability:  idle_cpus < busiest->idle_cpus ?

Right, took that.

> This check has always been a little oddly asymmetric in that:
>   group_weight - sum_nr_running <= idle_cpus
> 
> This allows the case where our group has pulled lots of work to one of
> its cpus, but not yet spread that out, but still keep trying to
> balance because idle_cpus is high.
> 
> This is more food for thought since this patch is not changing functionality.

Right, I saw the same and made a note to look at it later. I suppose
later never happens though :/ 


