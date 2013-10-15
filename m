Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758615Ab3JOK0y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 06:26:54 -0400
Received: from merlin.infradead.org ([205.233.59.134]:52402 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753362Ab3JOK0x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 06:26:53 -0400
Date: Tue, 15 Oct 2013 12:26:21 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Juri Lelli <juri.lelli@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>, tglx@linutronix.de, mingo@redhat.com,
        rostedt@goodmis.org, oleg@redhat.com, fweisbec@gmail.com,
        darren@dvhart.com, johan.eker@ericsson.com, p.faure@akatech.ch,
        linux-kernel@vger.kernel.org, claudio@evidence.eu.com,
        michael@amarulasolutions.com, fchecconi@gmail.com,
        tommaso.cucinotta@sssup.it, nicola.manica@disi.unitn.it,
        luca.abeni@unitn.it, dhaval.giani@gmail.com, hgu1972@gmail.com,
        paulmck@linux.vnet.ibm.com, raistlin@linux.it, insop.song@gmail.com,
        liming.wang@windriver.com, jkacur@redhat.com,
        harald.gustafsson@ericsson.com, vincent.guittot@linaro.org,
        bruce.ashfield@windriver.com--no-chain-reply-to
Subject: Re: [PATCH 12/14] sched: make dl_bw a sub-quota of rt_bw
Message-ID: <20131015102621.GE10651@twins.programming.kicks-ass.net>
References: <1381747426-31334-1-git-send-email-juri.lelli@gmail.com>
 <1381747426-31334-13-git-send-email-juri.lelli@gmail.com>
 <20131014140618.GA26604@gmail.com>
 <525D1234.5060001@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <525D1234.5060001@gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 15, 2013 at 12:00:20PM +0200, Juri Lelli wrote:
> On 10/14/2013 04:06 PM, Ingo Molnar wrote:
> > 
> > * Juri Lelli <juri.lelli@gmail.com> wrote:
> > 
> >> +#ifdef CONFIG_SMP
> >> +		struct dl_bw *dl_b = &cpu_rq(i)->rd->dl_bw;
> >> +#else
> >> +		struct dl_bw *dl_b = &cpu_rq(i)->dl.dl_bw;
> >> +#endif
> > 
> >> +#ifdef CONFIG_SMP
> >> +		struct dl_bw *dl_b = &cpu_rq(i)->rd->dl_bw;
> >> +#else
> >> +		struct dl_bw *dl_b = &cpu_rq(i)->dl.dl_bw;
> >> +#endif
> > 
> > Btw., this kind of SMP/UP assymetry pattern really sucks. Why not make UP 
> > use the SMP data structure, even if it's degenerate?
> > 
> 
> Yes, I don't like it either, but that comes from the fact that it seemed to me
> that, semantically, bandwidth for -deadline tasks has to be associated to the
> single runqueue in UP and to the root_domain for SMP. In UP root_domain is
> compiled out, so I'm not sure to understand what you suggest. I could probably
> let dl_bw live on runqueues with the assumption that all the runqueues from the
> same root_domain have the same dl_bw, that represents the dl_bw of the
> root_domain. But I don't like this replication either :(.

#ifdef CONFIG_SMP

static inline struct dl_bw *dl_bw_of(int i)
{
	return &cpu_rq(i)->rd->dl_bw;
}

#else

static inline struct dl_bw *dl_bw_of(int i)
{
	return &cpu_rq(i)->dl.dl_bw;
}

#endif

?
