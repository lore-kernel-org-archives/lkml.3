Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759519Ab3HOSj6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Aug 2013 14:39:58 -0400
Received: from merlin.infradead.org ([205.233.59.134]:60487 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755750Ab3HOSj5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Aug 2013 14:39:57 -0400
Date: Thu, 15 Aug 2013 20:39:49 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Paul Turner <pjt@google.com>
Cc: Lei Wen <adrian.wenl@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Lei Wen <leiwen@marvell.com>
Subject: Re: false nr_running check in load balance?
Message-ID: <20130815183949.GW24092@twins.programming.kicks-ass.net>
References: <CALZhoSQgw_-UaF0VOMjMqRJC8D4oQTBp4Bv=zJS+x0Wu97f2FQ@mail.gmail.com>
 <20130812144309.GK27162@twins.programming.kicks-ass.net>
 <CALZhoSRyfE78GbiJqVRvUrbJRq_NhSqYbK8vnxNP8kS9xz9qVQ@mail.gmail.com>
 <20130813073842.GP27162@twins.programming.kicks-ass.net>
 <CAPM31R+FDXUNb_X9R6O+kqjsAJftEzmyk+Ji=KoAyzEsTDWLew@mail.gmail.com>
 <20130815173953.GU24092@twins.programming.kicks-ass.net>
 <CAPM31RLqDC4HpkhV_E83Ny3m6MpGdOjuUswEQTdy58AtVP3z_w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPM31RLqDC4HpkhV_E83Ny3m6MpGdOjuUswEQTdy58AtVP3z_w@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 15, 2013 at 11:23:53AM -0700, Paul Turner wrote:
> On Thu, Aug 15, 2013 at 10:39 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> > On Tue, Aug 13, 2013 at 01:08:17AM -0700, Paul Turner wrote:
> >> On Tue, Aug 13, 2013 at 12:38 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> >> > On Tue, Aug 13, 2013 at 12:45:12PM +0800, Lei Wen wrote:
> >> >> > Not quite right; I think you need busiest->cfs.h_nr_running.
> >> >> > cfs.nr_running is the number of entries running in this 'group'. If
> >> >> > you've got nested groups like:
> >> >> >
> >> >> >  'root'
> >> >> >    \
> >> >> >    'A'
> >> >> >    / \
> >> >> >   t1 t2
> >> >> >
> >> >> > root.nr_running := 1 'A', even though you've got multiple running tasks.
> >
> > One thing though; doesn't h_nr_running over count the number of tasks?
> > That is, doesn't it count the runnable entities so the above case would
> > give root.h_nr_running := 3, where we would only have 2 runnable tasks.
> >
> > Double check this and be careful when doing the conversion.
> 
> This should be ok: it's accounted like rq->nr_running, not cfs_rq->nr_running.
> Specifically: both only account tasks; group-entities do not contribute.

Ah, ok. I should have looked at the code I guess... :-)

> The fact that this distinction exists, despite the very similar names
> is unfortunate.
> We could consider renaming to h_nr_{running_,}tasks for clarity.
> The same applies to rq->nr_running, although that would involve more churn.

Yah.. that would clarify, although longer variable names will also get
us into more line-breaks I'm sure.

Lets keep it as is. Maybe a comment somewhere would be enough.
