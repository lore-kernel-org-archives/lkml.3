Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933916AbaDITes (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 15:34:48 -0400
Received: from merlin.infradead.org ([205.233.59.134]:53450 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933342AbaDITer (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 15:34:47 -0400
Date: Wed, 9 Apr 2014 21:34:44 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Lin Ming <minggr@gmail.com>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: current->sched_class->yield_task is NULL, any hint?
Message-ID: <20140409193444.GA26782@laptop.programming.kicks-ass.net>
References: <CAF1ivSbZKbDc+rzd+CUqCzNmSgZmZTE-QeSU-2WmSiuEs-Kw_w@mail.gmail.com>
 <20140409182553.GE10526@twins.programming.kicks-ass.net>
 <CAF1ivSYeQcGf2d9kB-0R0TmCy=zaFg4WeJ2mgG_=K41hsoizyA@mail.gmail.com>
 <CAF1ivSbVf0+PTzFdO+tNo33C6h6=HiBeKVF2jRvMQe=+RnPVxA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAF1ivSbVf0+PTzFdO+tNo33C6h6=HiBeKVF2jRvMQe=+RnPVxA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 09, 2014 at 11:49:17AM -0700, Lin Ming wrote:
> On Wed, Apr 9, 2014 at 11:32 AM, Lin Ming <minggr@gmail.com> wrote:
> > On Wed, Apr 9, 2014 at 11:25 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> >> On Wed, Apr 09, 2014 at 10:43:32AM -0700, Lin Ming wrote:
> >>> Hi Peter,
> >>>
> >>> I hit a panic in sys_sched_yield() because(for some unknown reason)
> >>> current->sched_class->yield_task is NULL.
> >>> It's an ARM embedded board with 3.4-rt kernel.
> >>>
> >>> Could you share any hint for the possible causes?
> >>
> >> What class does current->sched_class point to?
> >
> > [12890.088232] Process swapper/0 (pid: 0, stack limit = 0xc07042f0)
> >
> > It's idle task. I think it should be idle_sched_class.
> > But let me double check it.
> 
> idle_sched_class has no "yield_task" defined.
> Does it mean that idle task should not call yield() at all?

Indeed. The idle task should never call yield. In fact, it should only
ever run the idle loop code, and that had better bloody not include a
yield call.
