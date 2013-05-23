Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759774Ab3EWP1H (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 May 2013 11:27:07 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:34246
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759756Ab3EWP1E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 May 2013 11:27:04 -0400
Date: Thu, 23 May 2013 17:26:57 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Vince Weaver <vincent.weaver@maine.edu>
Cc: linux-kernel@vger.kernel.org, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        trinity@vger.kernel.org
Subject: Re: WARNING in arch/x86/kernel/cpu/perf_event.c
Message-ID: <20130523152657.GF23650@twins.programming.kicks-ass.net>
References: <alpine.DEB.2.10.1305231023240.17701@vincent-weaver-1.um.maine.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.10.1305231023240.17701@vincent-weaver-1.um.maine.edu>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 23, 2013 at 10:29:07AM -0400, Vince Weaver wrote:
> Hello,
> 
> so now that I got past the OOPS in perf_mmap_close() I re-ran
> the fuzzer and quickly encountered the following WARNing.
> 
> It happens here:
> 
> static void x86_pmu_start(struct perf_event *event, int flags)
> {
>         struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
>         int idx = event->hw.idx;
> 
>         if (WARN_ON_ONCE(!(event->hw.state & PERF_HES_STOPPED)))
>                 return;
> 
> 
> Is it worth trying to come up with a reproducible case for this one?
> 
> I never know how seriously to take WARN_ON_ONCE dumps.

Its not supposed to happen, you're trying to start an already running
event. I'll put it on the todo list.
