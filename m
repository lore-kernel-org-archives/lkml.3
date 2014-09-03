Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932681AbaICJ7U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 05:59:20 -0400
Received: from mga09.intel.com ([134.134.136.24]:1989 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932645AbaICJ7M convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 05:59:12 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,456,1406617200"; 
   d="scan'208";a="474867570"
From: "Liu, Chuansheng" <chuansheng.liu@intel.com>
To: Peter Zijlstra <peterz@infradead.org>,
        Andy Lutomirski <luto@amacapital.net>
CC: "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        "Wang, Xiaoming" <xiaoming.wang@intel.com>,
        Ingo Molnar <mingo@redhat.com>,
        "Chakravarty, Souvik K" <souvik.k.chakravarty@intel.com>,
        "Liu, Changcheng" <changcheng.liu@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 1/3] sched: Add new API wake_up_if_idle() to wake up the
 idle cpu
Thread-Topic: [PATCH 1/3] sched: Add new API wake_up_if_idle() to wake up
 the idle cpu
Thread-Index: AQHPx10ObrW7VCSGJEyzwycJ5tUKy5vvLGZQ
Date: Wed, 3 Sep 2014 09:58:56 +0000
Message-ID: <27240C0AC20F114CBF8149A2696CBE4A01E69C5E@SHSMSX101.ccr.corp.intel.com>
References: <1408351052-25075-1-git-send-email-chuansheng.liu@intel.com>
 <CALCETrWns2cPzS+goDmXjhVuxzD2OczxTF9UtARBFnw3hibjZg@mail.gmail.com>
 <20140903095410.GJ4783@worktop.ger.corp.intel.com>
In-Reply-To: <20140903095410.GJ4783@worktop.ger.corp.intel.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Peter Zijlstra [mailto:peterz@infradead.org]
> Sent: Wednesday, September 03, 2014 5:54 PM
> To: Andy Lutomirski
> Cc: Liu, Chuansheng; linux-pm@vger.kernel.org; Rafael J. Wysocki; Daniel
> Lezcano; Wang, Xiaoming; Ingo Molnar; Chakravarty, Souvik K; Liu, Changcheng;
> linux-kernel@vger.kernel.org
> Subject: Re: [PATCH 1/3] sched: Add new API wake_up_if_idle() to wake up the
> idle cpu
> 
> On Thu, Aug 21, 2014 at 02:21:51PM -0700, Andy Lutomirski wrote:
> > On Aug 18, 2014 3:52 AM, "Chuansheng Liu" <chuansheng.liu@intel.com>
> wrote:
> 
> > > +void wake_up_if_idle(int cpu)
> > > +{
> > > +       struct rq *rq = cpu_rq(cpu);
> > > +       unsigned long flags;
> > > +
> > > +       if (set_nr_if_polling(rq->idle)) {
> > > +               trace_sched_wake_idle_without_ipi(cpu);
> > > +       } else {
> > > +
> >
> > FWIW, adding:
> >
> > if (rq->curr != rq->idle)
> >     return;
> >
> > Right here could improve performance on large, mostly non-idle
> > systems.  It would skip the spinlock in most cases.
> >
> 
>  !is_idle_task() :-)
Thanks Peter and Andy, will refine the patches again:)


