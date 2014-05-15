Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753265AbaEOQGo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 12:06:44 -0400
Received: from mail-qg0-f41.google.com ([209.85.192.41]:43278 "EHLO
	mail-qg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751662AbaEOQGn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 12:06:43 -0400
Date: Thu, 15 May 2014 12:06:40 -0400 (EDT)
From: Nicolas Pitre <nicolas.pitre@linaro.org>
To: Vincent Guittot <vincent.guittot@linaro.org>
cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Morten Rasmussen <morten.rasmussen@arm.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>
Subject: Re: [PATCH 3/6] sched/fair.c: disambiguate existing/remaining
 "capacity" usage
In-Reply-To: <CAKfTPtDueiEzqL_1kVvScvLvGmeNTMqX5mCU-2JdZ=Uth=nd-g@mail.gmail.com>
Message-ID: <alpine.LFD.2.11.1405151204090.17310@knanqh.ubzr>
References: <1400101030-17717-1-git-send-email-nicolas.pitre@linaro.org> <1400101030-17717-4-git-send-email-nicolas.pitre@linaro.org> <CAKfTPtDueiEzqL_1kVvScvLvGmeNTMqX5mCU-2JdZ=Uth=nd-g@mail.gmail.com>
User-Agent: Alpine 2.11 (LFD 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 May 2014, Vincent Guittot wrote:

> On 14 May 2014 22:57, Nicolas Pitre <nicolas.pitre@linaro.org> wrote:
> > We have "power" (which should actually become "capacity") and "capacity"
> > which is a scaled down "capacity factor" in terms of possible tasks.
> > Let's use "capa_factor" to make room for proper usage of "capacity"
> > later.
> >
> > Signed-off-by: Nicolas Pitre <nico@linaro.org>
> > ---
> >  kernel/sched/fair.c | 42 +++++++++++++++++++++---------------------
> >  1 file changed, 21 insertions(+), 21 deletions(-)
> >
> > diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> > index 0eda4c527e..2633c42692 100644
> > --- a/kernel/sched/fair.c
> > +++ b/kernel/sched/fair.c
> > @@ -5487,7 +5487,7 @@ struct sg_lb_stats {
> >         unsigned long load_per_task;
> >         unsigned long group_power;
> >         unsigned int sum_nr_running; /* Nr tasks running in the group */
> > -       unsigned int group_capacity;
> > +       unsigned int group_capa_factor;
> 
> As it is mainly compared to sum_nr_running, you might rename it to
> group_nr_capacity instead of group_capa_factor

But what actual meaning would "group_nr_capacity" convey?  This could be 
interpreted as the total number of groups possible for example.


Nicolas
