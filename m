Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933834Ab3GWVh0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 17:37:26 -0400
Received: from smtpauth03h.mfg.siteprotect.com ([64.26.60.134]:53293 "EHLO
	smtpauth03.mfg.siteprotect.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932832Ab3GWVhY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 17:37:24 -0400
Date: Tue, 23 Jul 2013 17:38:21 -0400 (EDT)
From: Vince Weaver <vince@deater.net>
X-X-Sender: vince@pianoman.cluster.toy
To: Michael Ellerman <michael@ellerman.id.au>
cc: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com,
        runzhen@linux.vnet.ibm.com, runzhew@clemson.edu,
        xiaoguangrong@linux.vnet.ibm.com, sukadev@linux.vnet.ibm.com,
        tglx@linutronix.de, linux-tip-commits@vger.kernel.org,
        torvalds@linux-foundation.org
Subject: Re: [tip:perf/core] perf tools: Make Power7 events available for
 perf
In-Reply-To: <1374558969.5545.30.camel@concordia>
Message-ID: <alpine.DEB.2.02.1307231731020.27628@pianoman.cluster.toy>
References: <1372407297-6996-3-git-send-email-runzhen@linux.vnet.ibm.com>  <tip-cfe0d8ba14a1d98245b371e486c68f37eba1ca52@git.kernel.org>  <alpine.DEB.2.02.1307230129350.18266@pianoman.cluster.toy> <1374558969.5545.30.camel@concordia>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-CTCH-Spam: Unknown
X-CTCH-RefID: str=0001.0A020205.51EEF794.0073,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I wish I were as good as cursing as Linus, ccing him in case he's willing 
to donate a few choice expressions.

On Tue, 23 Jul 2013, Michael Ellerman wrote:

> On Tue, 2013-07-23 at 01:33 -0400, Vince Weaver wrote:

> > > $ size arch/powerpc/perf/power7-pmu.o
> > >    text          data     bss     dec     hex filename
> > >    3073          2720       0    5793    16a1 arch/powerpc/perf/power7-pmu.o
> > > 
> > > and after the patch is applied, it is:
> > > 
> > > $ size arch/powerpc/perf/power7-pmu.o
> > >    text          data     bss     dec     hex filename
> > >   15950         31112       0   47062    b7d6 arch/powerpc/perf/power7-pmu.o
> > 
> > 
> > so we're really going down this road?
> 
> _We_ are going down this road, at least until there is a better
> solution. You'll notice I haven't merged any events for power8.

No, you are going down this road permanently, because if you commit this, 
it becomes ABI, and we have to maintain it forever.

> x86 can do what it wants. I don't think anyone in x86 land has proposed
> putting all the events in the kernel, so you can stop worrying about
> your 300k of memory.

I thought the prime directive of perf_event was nothing in the kernel that 
wasn't generic and applied to all architectures?  Why is Power7 special?

Abusing sysfs to waste 100k of non-swappable kernel memory on every 
running Linux kernel everwhere to hold static event tables that could be a 
simple CSV file in the perf tools directory is crazy.

Especially as it's likely this becomes stable ABI, and then you'll 
promptly break it as has already happenend in the last kernel release 
with the existing in-kernel powerpc events.

> I thought it was pretty clear from the last thread that folks agreed the
> event _lists_ should be in userspace. The discovery of the PMUs should
> be done in the kernel, and that should be communicated to userspace via
> something in sys.

I agree.  So why is this patch in tip?

> What it needs now is someone with some free time to actually code it up.
> Right now that's not me.

The code exists; it's called libpfm4.  Just becase you're lazy doesn't 
mean we commit garbage code into the kenrel.

For what it's worth, as the unofficial perf_event ABI documentation 
maintainer I strongly NAK this patch.

Vince


