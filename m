Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757617Ab3ANRlp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2013 12:41:45 -0500
Received: from fw-tnat.cambridge.arm.com ([217.140.96.21]:46415 "EHLO
	cam-smtp0.cambridge.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756495Ab3ANRlo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2013 12:41:44 -0500
Date: Mon, 14 Jan 2013 17:40:20 +0000
From: Will Deacon <will.deacon@arm.com>
To: Cong Ding <dinggnu@gmail.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] arm: kernel/perf_event_cpu.c: fix error null pointer
 dereference check
Message-ID: <20130114174020.GH31341@mudshark.cambridge.arm.com>
References: <1358183933-29160-1-git-send-email-dinggnu@gmail.com>
 <20130114172346.GK23505@n2100.arm.linux.org.uk>
 <20130114173826.GA917@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130114173826.GA917@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 14, 2013 at 05:38:26PM +0000, Cong Ding wrote:
> On Mon, Jan 14, 2013 at 05:23:46PM +0000, Russell King - ARM Linux wrote:
> > On Mon, Jan 14, 2013 at 05:18:53PM +0000, Cong Ding wrote:
> > > the pointer cpu_pmu is used without null pointer dereference check, and is
> > > checked after the using of it, so we move the null pointer check to before the
> > > first use.
> > 
> > The NULL pointer check is not necessary.  cpu_pmu_init() is called
> > after cpu_pmu has already been dereferenced by its caller:
> > 
> >         cpu_pmu = pmu;
> >         cpu_pmu->plat_device = pdev;
> >         cpu_pmu_init(cpu_pmu);
> > 
> > So...
> > 
> > > -	/* Ensure the PMU has sane values out of reset. */
> > > -	if (cpu_pmu && cpu_pmu->reset)
> > 
> > Just replace this with:
> > 	if (cpu_pmu->reset)
> Thanks Russell, I will send version 2.

No need, I've taken this into my perf/updates branch.

Thanks,

Will
