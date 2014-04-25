Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753876AbaDYNQc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 09:16:32 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:52500 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751825AbaDYNQY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 09:16:24 -0400
Date: Fri, 25 Apr 2014 15:16:20 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Roman Gushchin <klamm@yandex-team.ru>
Cc: LKML <linux-kernel@vger.kernel.org>, "mingo@redhat.com" <mingo@redhat.com>,
        "tkhai@yandex.ru" <tkhai@yandex.ru>
Subject: Re: Real-time scheduling policies and hyper-threading
Message-ID: <20140425131620.GB11096@twins.programming.kicks-ass.net>
References: <36851398363372@webcorp2g.yandex-team.ru>
 <20140424185858.GB26782@laptop.programming.kicks-ass.net>
 <17051398423889@webcorp2e.yandex-team.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <17051398423889@webcorp2e.yandex-team.ru>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 25, 2014 at 03:04:49PM +0400, Roman Gushchin wrote:
> 24.04.2014, 22:59, "Peter Zijlstra" <peterz@infradead.org>:
> > On Thu, Apr 24, 2014 at 10:16:12PM +0400, Roman Gushchin wrote:
> >
> >>  Are there any known solutions of this problem except disabling
> >>  hyper-threading and frequency scaling at all?
> >
> > This is what we generally tell people to do; disable HT in the BIOS,
> > offline the siblings or similar approaches.
> 
> It's a good, but expensive approach, if you have many machines.

Expensive how? If you require the latency, there's really no option.

That said, if only a small part of your workload is RT then you don't
need to disable all SMT siblings, you can only disable the few that are
in your RT partition.

> > You, and only you, know your workload and can devise a correct placement
> > policy. We have cpusets and cpu affinity available to carve up your
> > system for this.
> 
> The problem here is that _all_ userspace tasks should care about cpu placement.
> In reality, there is always a number of monitoring/administration/system tasks,
> which execution increases latencies. Use of nice/SCHED_BATCH/... doesn't solve
> the problem, because of hyper-threading.

The thing is, normal tasks don't care and its perfectly fine to have
heuristics that work more or less most of the time.

But realtime does care, it must absolutely always work in a predictable
fashion.

> Of course, it's possible to divide cpus statically via cpusets/partitioning,
> but it's also not cheap in terms of overall performance utilization.

Well, realtime isn't about getting full utilization from your hardware
to begin with. Its about getting deterministic behaviour from your
hardware.

If your workload allows both, then yay, but its absolutely not true in
general.

> Probably, it's important, that CPU load in our case is never 100% for a period 
> longer than few hundreds milliseconds.

Yeah, that's not a problem. Pegging the CPU for 10s of seconds and
upwards will get funny real quick though.
