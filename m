Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751216Ab3GZEY5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 00:24:57 -0400
Received: from smtpauth12.mfg.siteprotect.com ([64.26.60.150]:37131 "EHLO
	smtpauth02.mfg.siteprotect.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750793Ab3GZEYx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 00:24:53 -0400
Date: Fri, 26 Jul 2013 00:25:51 -0400 (EDT)
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
In-Reply-To: <20130725134135.GA14744@concordia>
Message-ID: <alpine.DEB.2.02.1307260012270.26524@pianoman.cluster.toy>
References: <1372407297-6996-3-git-send-email-runzhen@linux.vnet.ibm.com> <tip-cfe0d8ba14a1d98245b371e486c68f37eba1ca52@git.kernel.org> <alpine.DEB.2.02.1307230129350.18266@pianoman.cluster.toy> <1374558969.5545.30.camel@concordia>
 <alpine.DEB.2.02.1307231731020.27628@pianoman.cluster.toy> <20130725134135.GA14744@concordia>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-CTCH-Spam: Unknown
X-CTCH-RefID: str=0001.0A02020A.51F1FA15.0037,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 25 Jul 2013, Michael Ellerman wrote:

> On Tue, Jul 23, 2013 at 05:38:21PM -0400, Vince Weaver wrote:
>
> Well cursing is what witches do, but if you need someone to swear a bit
> I can help you out, I am fuckin Australian after all.

I should point out the cursing is directed at the code in question and the 
overall downhill direction in the perf_event interface, and not directed 
at anyone personally.

I've been fighting a (losing) battle for the past 5 years trying to keep 
event definitions out of the kernel, I just didn't expect defeat to come 
so swiftly and so suddenly from an unexpected corner (the power arch).

> But there are ~50 generic events in Linux, and our PMU supports ~500.
> And our hardware designers use perf, and they need to test all 500
> events. And they're getting sick of using raw event codes.

And writing a small wrapper utility or patching perf is somehow harder 
than sticking the whole mess in the kernel?  I get annoyed having to look 
up the value of ANSI color escape codes now and then, but I don't expect 
to submit a patch for /sys/tty/colors/red to the kernel and have it 
accepted.

> > Abusing sysfs to waste 100k of non-swappable kernel memory on every 
> > running Linux kernel everwhere 
> 
> It's great that you're so concerned about memory wastage on _powerpc_
> systems.

It's a slippery slope.

> > Especially as it's likely this becomes stable ABI, and then you'll 
> > promptly break it as has already happenend in the last kernel release 
> > with the existing in-kernel powerpc events.
> 
> You're becoming the boy who cried "ABI break" Vince. Yes we renamed one
> event, we knew full well that nothing was using it - not even trinity.

Yes, the interface has only been around for one kernel version and you've 
already broken the ABI once.  Not a very good track record.  Event name 
renaming is a lot bigger problem on x86 where certain vendors like to fuss 
with the event names every 3 months or so.

trinity is just an example as the users tend to use -rc kernels and thus 
find the breakages faster.  The main problem is tools like PAPI that deal 
with events in much more critical fashion, but the kernel devs don't 
really seem to care much about HPC use cases.

> > I agree.  So why is this patch in tip?
> 
> Because acme picked it up before that thread got going.

once a patch gets into tip in my experience all public mailing list review 
is done with, and the patch is more or less guaranteed to appear in the 
next major release unless there's some sort of regression in linux-next.

Hence this last attempt to get people to discuss this.  It will likely be 
ignored, but at least I can feel like I tried.

Vince


