Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755914AbaICJyg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 05:54:36 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:48224 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753125AbaICJyf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 05:54:35 -0400
Date: Wed, 3 Sep 2014 11:54:10 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Chuansheng Liu <chuansheng.liu@intel.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        "Wang, Xiaoming" <xiaoming.wang@intel.com>,
        Ingo Molnar <mingo@redhat.com>,
        "Chakravarty, Souvik K" <souvik.k.chakravarty@intel.com>,
        "Liu, Changcheng" <changcheng.liu@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/3] sched: Add new API wake_up_if_idle() to wake up the
 idle cpu
Message-ID: <20140903095410.GJ4783@worktop.ger.corp.intel.com>
References: <1408351052-25075-1-git-send-email-chuansheng.liu@intel.com>
 <CALCETrWns2cPzS+goDmXjhVuxzD2OczxTF9UtARBFnw3hibjZg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrWns2cPzS+goDmXjhVuxzD2OczxTF9UtARBFnw3hibjZg@mail.gmail.com>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 21, 2014 at 02:21:51PM -0700, Andy Lutomirski wrote:
> On Aug 18, 2014 3:52 AM, "Chuansheng Liu" <chuansheng.liu@intel.com> wrote:

> > +void wake_up_if_idle(int cpu)
> > +{
> > +       struct rq *rq = cpu_rq(cpu);
> > +       unsigned long flags;
> > +
> > +       if (set_nr_if_polling(rq->idle)) {
> > +               trace_sched_wake_idle_without_ipi(cpu);
> > +       } else {
> > +
> 
> FWIW, adding:
> 
> if (rq->curr != rq->idle)
>     return;
> 
> Right here could improve performance on large, mostly non-idle
> systems.  It would skip the spinlock in most cases.
> 

 !is_idle_task() :-)
