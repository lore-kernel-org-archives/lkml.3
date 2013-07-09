Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752289Ab3GIDeJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jul 2013 23:34:09 -0400
Received: from ozlabs.org ([203.10.76.45]:57503 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751648Ab3GIDeF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jul 2013 23:34:05 -0400
Date: Tue, 9 Jul 2013 13:34:02 +1000
From: Michael Ellerman <michael@ellerman.id.au>
To: Vince Weaver <vincent.weaver@maine.edu>
Cc: Peter Zijlstra <peterz@infradead.org>, Vince Weaver <vince@deater.net>,
        Runzhen Wang <runzhen@linux.vnet.ibm.com>,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        paulus@samba.org, acme@redhat.com, mingo@kernel.org,
        Stephane Eranian <eranian@google.com>, sukadev@linux.vnet.ibm.com,
        xiaoguangrong@linux.vnet.ibm.com
Subject: Re: [PATCH v2 2/2] perf tools: Make Power7 events available for perf
Message-ID: <20130709033402.GA8543@concordia>
References: <1372170933-4538-1-git-send-email-runzhen@linux.vnet.ibm.com>
 <1372170933-4538-3-git-send-email-runzhen@linux.vnet.ibm.com>
 <alpine.DEB.2.02.1306251240440.25443@pianoman.cluster.toy>
 <20130704125218.GA21134@concordia>
 <20130704125700.GM18898@dyad.programming.kicks-ass.net>
 <20130709012952.GA7185@concordia>
 <alpine.DEB.2.10.1307082204550.26280@vincent-weaver-1.um.maine.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.10.1307082204550.26280@vincent-weaver-1.um.maine.edu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 08, 2013 at 10:24:34PM -0400, Vince Weaver wrote:
> On Tue, 9 Jul 2013, Michael Ellerman wrote:
> 
> > On Thu, Jul 04, 2013 at 02:57:00PM +0200, Peter Zijlstra wrote:
> > > 
> > > Right; I think Stephane and Jiri are in favour of creating a 'new' project that
> > > includes just the event definitions in a plain text format and a little library
> > > with parser to be used by all interested parties.
> > 
> > OK that would be great.
> > 
> > The part that seems to be missing to make that work is we have no way of
> > matching the PMU that appears in /sys with a list of events.
> > 
> > Eg. on my system I have /sys/bus/event_source/devices/cpu - but there's
> > nothing in there to identify that it's a Sandy Bridge.
> 
> So something like they have on ARM?
> 
> vince@pandaboard:/sys/bus/event_source/devices$ ls -l
> lrwxrwxrwx 1 root root 0 Jul  8 21:57 ARMv7 Cortex-A9 -> ../../../devices/ARMv7 Cortex-A9
> lrwxrwxrwx 1 root root 0 Jul  8 21:57 breakpoint -> ../../../devices/breakpoint
> lrwxrwxrwx 1 root root 0 Jul  8 21:57 software -> ../../../devices/software
> lrwxrwxrwx 1 root root 0 Jul  8 21:57 tracepoint -> ../../../devices/tracepoint

Sort of. I wasn't thinking of using the name, rather adding an attribute
with a well defined list of values.

> > For the cpu you can obviously just detect what processor you're on with
> > cpuid or whatever, but it's a bit of a hack. And that really doesn't
> > work for non-cpu PMUs.
> 
> why is it a hack to use cpuid?

Because you're assuming that the PMU the kernel has exposed is for the
cpu you happen to be executing on.

But the real issue is with PMUs that are not in the CPU - there is no
easy way for userspace to detect them and determine which event list it
should be consulting.

> People have done event lists in userspace for years.  Why must it be the 
> kernel's job?

This whole thread is about making the event list not the kernel's job?

The part that _is_ the kernels job is detecting the hardware and
providing an API to access it. What I'm saying is that the kernel API
should include some sort of identifier so that userspace can reliably
determine the event list to use.

cheers
