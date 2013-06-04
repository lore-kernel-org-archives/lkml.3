Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753503Ab3FDJib (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 05:38:31 -0400
Received: from merlin.infradead.org ([205.233.59.134]:49703 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752717Ab3FDJiX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 05:38:23 -0400
Date: Tue, 4 Jun 2013 11:38:02 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Alexander Gordeev <agordeev@redhat.com>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Jiri Olsa <jolsa@redhat.com>, Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH RFC -tip 0/6] perf: IRQ-bound performance events
Message-ID: <20130604093802.GK8923@twins.programming.kicks-ass.net>
References: <20130603094132.GB30878@dhcp-26-207.brq.redhat.com>
 <20130603133618.GK30878@dhcp-26-207.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130603133618.GK30878@dhcp-26-207.brq.redhat.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 03, 2013 at 03:36:19PM +0200, Alexander Gordeev wrote:
> On Mon, Jun 03, 2013 at 11:41:32AM +0200, Alexander Gordeev wrote:
> > # ./tools/perf/perf stat -I 8 -a -e L1-dcache-load-misses:k sleep 1
> > 
> >  Performance counter stats for process id '8':
> > 
> >                  0 L1-dcache-load-misses                                       
> > 
> >        1.001235781 seconds time elapsed
> > 
> > # ./tools/perf/perf stat -I 8 -a -e L1-dcache-load-misses:k hwclock --test
> > Mon 03 Jun 2013 04:42:59 AM EDT  -0.891274 seconds
> > 
> >  Performance counter stats for process id '8':
> 
> Oops, the most interesting part did not make it in. Very sorry :) Here:
> 
> # ./tools/perf/perf stat -I 8 -a -e L1-dcache-load-misses:k hwclock --test
> Mon 03 Jun 2013 09:32:49 AM EDT  -0.719514 seconds
> 
>  Performance counter stats for process id '8':
> 
>                447 L1-dcache-load-misses                                       

I think that is very much expected; except in the case where you spend
_all_ your time in IRQ handlers, they'll pretty much always miss l1
cache.
