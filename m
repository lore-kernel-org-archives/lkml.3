Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756021Ab3GYNll (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 09:41:41 -0400
Received: from ozlabs.org ([203.10.76.45]:60933 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755510Ab3GYNlj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 09:41:39 -0400
Date: Thu, 25 Jul 2013 23:41:36 +1000
From: Michael Ellerman <michael@ellerman.id.au>
To: Vince Weaver <vince@deater.net>
Cc: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com,
        runzhen@linux.vnet.ibm.com, runzhew@clemson.edu,
        xiaoguangrong@linux.vnet.ibm.com, sukadev@linux.vnet.ibm.com,
        tglx@linutronix.de, linux-tip-commits@vger.kernel.org,
        torvalds@linux-foundation.org
Subject: Re: [tip:perf/core] perf tools: Make Power7 events available for perf
Message-ID: <20130725134135.GA14744@concordia>
References: <1372407297-6996-3-git-send-email-runzhen@linux.vnet.ibm.com>
 <tip-cfe0d8ba14a1d98245b371e486c68f37eba1ca52@git.kernel.org>
 <alpine.DEB.2.02.1307230129350.18266@pianoman.cluster.toy>
 <1374558969.5545.30.camel@concordia>
 <alpine.DEB.2.02.1307231731020.27628@pianoman.cluster.toy>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1307231731020.27628@pianoman.cluster.toy>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 23, 2013 at 05:38:21PM -0400, Vince Weaver wrote:
> 
> I wish I were as good as cursing as Linus, ccing him in case he's willing 
> to donate a few choice expressions.

Well cursing is what witches do, but if you need someone to swear a bit
I can help you out, I am fuckin Australian after all.

> On Tue, 23 Jul 2013, Michael Ellerman wrote:
> 
> > On Tue, 2013-07-23 at 01:33 -0400, Vince Weaver wrote:
> 
> > > > $ size arch/powerpc/perf/power7-pmu.o
> > > >    text          data     bss     dec     hex filename
> > > >    3073          2720       0    5793    16a1 arch/powerpc/perf/power7-pmu.o
> > > > 
> > > > and after the patch is applied, it is:
> > > > 
> > > > $ size arch/powerpc/perf/power7-pmu.o
> > > >    text          data     bss     dec     hex filename
> > > >   15950         31112       0   47062    b7d6 arch/powerpc/perf/power7-pmu.o
> > > 
> > > 
> > > so we're really going down this road?
> > 
> > _We_ are going down this road, at least until there is a better
> > solution. You'll notice I haven't merged any events for power8.
> 
> No, you are going down this road permanently, because if you commit this, 
> it becomes ABI, and we have to maintain it forever.

Yes I understand what an ABI is. What I meant is we have only added the
events for the Power7 PMU, and hopefully we will not have to add any for
future PMUs.

> > x86 can do what it wants. I don't think anyone in x86 land has proposed
> > putting all the events in the kernel, so you can stop worrying about
> > your 300k of memory.
> 
> I thought the prime directive of perf_event was nothing in the kernel that 
> wasn't generic and applied to all architectures?  Why is Power7 special?

Sure perf tries to abstract things, and for the vast majority of users
that's all they want or need.

But there are ~50 generic events in Linux, and our PMU supports ~500.
And our hardware designers use perf, and they need to test all 500
events. And they're getting sick of using raw event codes.

> Abusing sysfs to waste 100k of non-swappable kernel memory on every 
> running Linux kernel everwhere 

It's great that you're so concerned about memory wastage on _powerpc_
systems.

> to hold static event tables that could be a 
> simple CSV file in the perf tools directory is crazy.

I agree 100% that it could be a CSV file in the perf directory. But up
until we sent this patch every attempt to do something like that had
been NAKed.

> Especially as it's likely this becomes stable ABI, and then you'll 
> promptly break it as has already happenend in the last kernel release 
> with the existing in-kernel powerpc events.

You're becoming the boy who cried "ABI break" Vince. Yes we renamed one
event, we knew full well that nothing was using it - not even trinity.

> > I thought it was pretty clear from the last thread that folks agreed the
> > event _lists_ should be in userspace. The discovery of the PMUs should
> > be done in the kernel, and that should be communicated to userspace via
> > something in sys.
> 
> I agree.  So why is this patch in tip?

Because acme picked it up before that thread got going.

> > What it needs now is someone with some free time to actually code it up.
> > Right now that's not me.
> 
> The code exists; it's called libpfm4.  Just becase you're lazy doesn't 
> mean we commit garbage code into the kenrel.

Don't call me lazy.

If the code is called libpfm4 why doesn't perf use it? There are patches
out there to integrate the two, why don't you get them merged?
