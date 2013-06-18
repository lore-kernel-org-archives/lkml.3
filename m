Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932490Ab3FRPUC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 11:20:02 -0400
Received: from merlin.infradead.org ([205.233.59.134]:47397 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755567Ab3FRPUA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 11:20:00 -0400
Date: Tue, 18 Jun 2013 17:19:54 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: mingo@redhat.com, linaro-kernel@lists.linaro.org, patches@linaro.org,
        linux-kernel@vger.kernel.org, robin.randhawa@arm.com,
        Steve.Bannister@arm.com, Liviu.Dudau@arm.com,
        charles.garcia-tobin@arm.com, arvind.chauhan@arm.com
Subject: Re: [PATCH 2/3] sched: don't call get_group() for covered cpus
Message-ID: <20130618151954.GB16094@twins.programming.kicks-ass.net>
References: <cover.1370948150.git.viresh.kumar@linaro.org>
 <7a61e955abdcbb1dfa9fe493f11a5ec53a11ddd3.1370948150.git.viresh.kumar@linaro.org>
 <20130618100306.GL3204@twins.programming.kicks-ass.net>
 <CAKohpo=oAa=mdkZk9yq4W7v-hQpCAM00rTJTWOn-eCBreEqTdA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKohpo=oAa=mdkZk9yq4W7v-hQpCAM00rTJTWOn-eCBreEqTdA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 18, 2013 at 03:45:15PM +0530, Viresh Kumar wrote:
> On 18 June 2013 15:33, Peter Zijlstra <peterz@infradead.org> wrote:
> > On Tue, Jun 11, 2013 at 04:32:44PM +0530, Viresh Kumar wrote:
> >> In build_sched_groups() we don't need to call get_group() for cpus which are
> >> already covered in previous iterations. So, call get_group() after checking if
> >> cpu is covered or not.
> >>
> >
> > Aside from not needing it; doing it would mark the group used and
> > eventually leak it since we wouldn't connect it and not find it again to
> > free it, right?
> >
> > So effectively this fixes a memory leak?
> 
> Exactly. To be precise: In cases where sg->cpumask contained more
> than one cpu (For any topology level), this patch helps freeing sg's
> memory for all cpus leaving the group leader.
> 
> May I update the logs again?

Sure. Just send a new patch and I'll substitute.
