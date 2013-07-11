Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932272Ab3GKLAA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 07:00:00 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:43221 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932081Ab3GKK76 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 06:59:58 -0400
Date: Thu, 11 Jul 2013 11:58:43 +0100
From: Will Deacon <will.deacon@arm.com>
To: Vince Weaver <vincent.weaver@maine.edu>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Michael Ellerman <michael@ellerman.id.au>,
        Vince Weaver <vince@deater.net>,
        Runzhen Wang <runzhen@linux.vnet.ibm.com>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "paulus@samba.org" <paulus@samba.org>,
        "acme@redhat.com" <acme@redhat.com>,
        "mingo@kernel.org" <mingo@kernel.org>,
        Stephane Eranian <eranian@google.com>,
        "sukadev@linux.vnet.ibm.com" <sukadev@linux.vnet.ibm.com>,
        "xiaoguangrong@linux.vnet.ibm.com" <xiaoguangrong@linux.vnet.ibm.com>
Subject: Re: [PATCH v2 2/2] perf tools: Make Power7 events available for perf
Message-ID: <20130711105843.GG32197@mudshark.cambridge.arm.com>
References: <1372170933-4538-1-git-send-email-runzhen@linux.vnet.ibm.com>
 <1372170933-4538-3-git-send-email-runzhen@linux.vnet.ibm.com>
 <alpine.DEB.2.02.1306251240440.25443@pianoman.cluster.toy>
 <20130704125218.GA21134@concordia>
 <20130704125700.GM18898@dyad.programming.kicks-ass.net>
 <20130709012952.GA7185@concordia>
 <alpine.DEB.2.10.1307082204550.26280@vincent-weaver-1.um.maine.edu>
 <20130709081434.GI25631@dyad.programming.kicks-ass.net>
 <alpine.DEB.2.10.1307091059270.675@vincent-weaver-1.um.maine.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.10.1307091059270.675@vincent-weaver-1.um.maine.edu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 09, 2013 at 04:05:30PM +0100, Vince Weaver wrote:
> On Tue, 9 Jul 2013, Peter Zijlstra wrote:
> 
> > On Mon, Jul 08, 2013 at 10:24:34PM -0400, Vince Weaver wrote:
> > > 
> > > So something like they have on ARM?
> > > 
> > > vince@pandaboard:/sys/bus/event_source/devices$ ls -l
> > > lrwxrwxrwx 1 root root 0 Jul  8 21:57 ARMv7 Cortex-A9 -> ../../../devices/ARMv7 Cortex-A9
> > > lrwxrwxrwx 1 root root 0 Jul  8 21:57 breakpoint -> ../../../devices/breakpoint
> > > lrwxrwxrwx 1 root root 0 Jul  8 21:57 software -> ../../../devices/software
> > > lrwxrwxrwx 1 root root 0 Jul  8 21:57 tracepoint -> ../../../devices/tracepoint
> > 
> > Right so what I remember of the ARM case is that their /proc/cpuinfo isn't
> > sufficient to identify their PMU. And they don't have a cpuid like instruction
> > at all.
> 
> libpfm4 uses the
>    CPU part	: 0xc09
> line in /proc/cpuinfo on ARM, and that's enough for the processors PAPI 
> supports (Cortex A8/A9/A15 plus the 1176 on the raspberry-pi).  I'm 
> guessing it wouldn't be enough if we wanted to support *all* ARMs with
> PMUs.

The CPU part you cite is actually A9-specific, so you probably want to
probe each CPU specifically. Take a look at the cpuinfo parsing in OProfile
(used by operf).

> And speaking of ARM, I should be railing at them for breaking the ABI too, 
> with their (understandable yet still ABI breaking) decision to remove 
> BogoMIPS from /proc/cpuinfo.  That change will impact PAPI as well as 
> various other programs I maintain that have the misfortune of parsing that 
> file.

Really? Why are you checking for that line at all?

Will
