Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753820Ab3GWF4N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 01:56:13 -0400
Received: from ozlabs.org ([203.10.76.45]:45666 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751688Ab3GWF4M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 01:56:12 -0400
Message-ID: <1374558969.5545.30.camel@concordia>
Subject: Re: [tip:perf/core] perf tools: Make Power7 events available for
 perf
From: Michael Ellerman <michael@ellerman.id.au>
To: Vince Weaver <vince@deater.net>
Cc: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com,
        runzhen@linux.vnet.ibm.com, runzhew@clemson.edu,
        xiaoguangrong@linux.vnet.ibm.com, sukadev@linux.vnet.ibm.com,
        tglx@linutronix.de, linux-tip-commits@vger.kernel.org
Date: Tue, 23 Jul 2013 15:56:09 +1000
In-Reply-To: <alpine.DEB.2.02.1307230129350.18266@pianoman.cluster.toy>
References: <1372407297-6996-3-git-send-email-runzhen@linux.vnet.ibm.com>
	 <tip-cfe0d8ba14a1d98245b371e486c68f37eba1ca52@git.kernel.org>
	 <alpine.DEB.2.02.1307230129350.18266@pianoman.cluster.toy>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-07-23 at 01:33 -0400, Vince Weaver wrote:
> On Fri, 19 Jul 2013, tip-bot for Runzhen Wang wrote:
> 
> > perf tools: Make Power7 events available for perf
> > 
> > This patch makes all the POWER7 events available in sysfs.  So we can
> > instead specify these as:
> > 
> > $ size arch/powerpc/perf/power7-pmu.o
> >    text          data     bss     dec     hex filename
> >    3073          2720       0    5793    16a1 arch/powerpc/perf/power7-pmu.o
> > 
> > and after the patch is applied, it is:
> > 
> > $ size arch/powerpc/perf/power7-pmu.o
> >    text          data     bss     dec     hex filename
> >   15950         31112       0   47062    b7d6 arch/powerpc/perf/power7-pmu.o
> 
> 
> so we're really going down this road?

_We_ are going down this road, at least until there is a better
solution. You'll notice I haven't merged any events for power8.

> If x86 follows this precedent we're going to end up with 300k+ of
> event names in the kernel.  And as a reminder, perf_event cannot
> be disabled on x86, nor can it be compiled as a module.  So that would
> be 300k of event names in every kernel for everyone, even those not using 
> perf.

x86 can do what it wants. I don't think anyone in x86 land has proposed
putting all the events in the kernel, so you can stop worrying about
your 300k of memory.


I thought it was pretty clear from the last thread that folks agreed the
event _lists_ should be in userspace. The discovery of the PMUs should
be done in the kernel, and that should be communicated to userspace via
something in sys.

What it needs now is someone with some free time to actually code it up.
Right now that's not me.

cheers


