Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753674Ab3GIIPh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jul 2013 04:15:37 -0400
Received: from merlin.infradead.org ([205.233.59.134]:49717 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753098Ab3GIIPd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jul 2013 04:15:33 -0400
Date: Tue, 9 Jul 2013 10:14:34 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Vince Weaver <vincent.weaver@maine.edu>
Cc: Michael Ellerman <michael@ellerman.id.au>, Vince Weaver <vince@deater.net>,
        Runzhen Wang <runzhen@linux.vnet.ibm.com>,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        paulus@samba.org, acme@redhat.com, mingo@kernel.org,
        Stephane Eranian <eranian@google.com>, sukadev@linux.vnet.ibm.com,
        xiaoguangrong@linux.vnet.ibm.com
Subject: Re: [PATCH v2 2/2] perf tools: Make Power7 events available for perf
Message-ID: <20130709081434.GI25631@dyad.programming.kicks-ass.net>
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
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 08, 2013 at 10:24:34PM -0400, Vince Weaver wrote:
> 
> So something like they have on ARM?
> 
> vince@pandaboard:/sys/bus/event_source/devices$ ls -l
> lrwxrwxrwx 1 root root 0 Jul  8 21:57 ARMv7 Cortex-A9 -> ../../../devices/ARMv7 Cortex-A9
> lrwxrwxrwx 1 root root 0 Jul  8 21:57 breakpoint -> ../../../devices/breakpoint
> lrwxrwxrwx 1 root root 0 Jul  8 21:57 software -> ../../../devices/software
> lrwxrwxrwx 1 root root 0 Jul  8 21:57 tracepoint -> ../../../devices/tracepoint

Right so what I remember of the ARM case is that their /proc/cpuinfo isn't
sufficient to identify their PMU. And they don't have a cpuid like instruction
at all.

> > For the cpu you can obviously just detect what processor you're on with
> > cpuid or whatever, but it's a bit of a hack. And that really doesn't
> > work for non-cpu PMUs.
> 
> why is it a hack to use cpuid?

I agree, for x86 cpuid is perfectly fine, as would /proc/cpuinfo be, I suspect
that just the model number is sufficient in most cases, even for uncore stuff.
