Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753865AbaG2OxM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 10:53:12 -0400
Received: from casper.infradead.org ([85.118.1.10]:37949 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753224AbaG2OxK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 10:53:10 -0400
Date: Tue, 29 Jul 2014 16:53:08 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: riel@redhat.com
Cc: linux-kernel@vger.kernel.org, vincent.guittot@linaro.org,
        mikey@neuling.org, mingo@kernel.org, jhladky@redhat.com,
        ktkhai@parallels.com, tim.c.chen@linux.intel.com,
        nicolas.pitre@linaro.org
Subject: Re: [PATCH 1/2] sched: fix and clean up calculate_imbalance
Message-ID: <20140729145308.GV12054@laptop.lan>
References: <1406571388-3227-1-git-send-email-riel@redhat.com>
 <1406571388-3227-2-git-send-email-riel@redhat.com>
 <20140729144952.GG3935@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140729144952.GG3935@laptop>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 29, 2014 at 04:49:52PM +0200, Peter Zijlstra wrote:
> > @@ -6247,32 +6247,15 @@ static inline void calculate_imbalance(struct lb_env *env, struct sd_lb_stats *s
> >  		return fix_small_imbalance(env, sds);
> >  	}
> >  
> > -	if (!busiest->group_imb) {
> > -		/*
> > -		 * Don't want to pull so many tasks that a group would go idle.
> > -		 * Except of course for the group_imb case, since then we might
> > -		 * have to drop below capacity to reach cpu-load equilibrium.
> > -		 */
> > -		load_above_capacity =
> > -			(busiest->sum_nr_running - busiest->group_capacity_factor);
> > -
> > -		load_above_capacity *= (SCHED_LOAD_SCALE * SCHED_CAPACITY_SCALE);
> > -		load_above_capacity /= busiest->group_capacity;
> > -	}
> 
> I think we want to retain that, esp. for the overloaded case. So that
> wants to be:
> 
> 	if (busiest->sum_nr_running > busiest->group_capacity_factor)
> 
> Clearly it doesn't make sense for the !overload case, and we explicitly
> want to avoid it in the imb case.

Ah, wait, I think I see why you want that gone. I was only expecting a
correction fix wrt changing pick_busiest(), not also behaviour changes.

Lemme reconsider.
