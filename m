Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754035Ab3GIO75 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jul 2013 10:59:57 -0400
Received: from mail-vb0-f54.google.com ([209.85.212.54]:65263 "EHLO
	mail-vb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753861Ab3GIO7y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jul 2013 10:59:54 -0400
Date: Tue, 9 Jul 2013 11:05:30 -0400 (EDT)
From: Vince Weaver <vincent.weaver@maine.edu>
To: Peter Zijlstra <peterz@infradead.org>
cc: Vince Weaver <vincent.weaver@maine.edu>,
        Michael Ellerman <michael@ellerman.id.au>,
        Vince Weaver <vince@deater.net>,
        Runzhen Wang <runzhen@linux.vnet.ibm.com>,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        paulus@samba.org, acme@redhat.com, mingo@kernel.org,
        Stephane Eranian <eranian@google.com>, sukadev@linux.vnet.ibm.com,
        xiaoguangrong@linux.vnet.ibm.com, Will Deacon <will.deacon@arm.com>
Subject: Re: [PATCH v2 2/2] perf tools: Make Power7 events available for
 perf
In-Reply-To: <20130709081434.GI25631@dyad.programming.kicks-ass.net>
Message-ID: <alpine.DEB.2.10.1307091059270.675@vincent-weaver-1.um.maine.edu>
References: <1372170933-4538-1-git-send-email-runzhen@linux.vnet.ibm.com> <1372170933-4538-3-git-send-email-runzhen@linux.vnet.ibm.com> <alpine.DEB.2.02.1306251240440.25443@pianoman.cluster.toy> <20130704125218.GA21134@concordia>
 <20130704125700.GM18898@dyad.programming.kicks-ass.net> <20130709012952.GA7185@concordia> <alpine.DEB.2.10.1307082204550.26280@vincent-weaver-1.um.maine.edu> <20130709081434.GI25631@dyad.programming.kicks-ass.net>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 9 Jul 2013, Peter Zijlstra wrote:

> On Mon, Jul 08, 2013 at 10:24:34PM -0400, Vince Weaver wrote:
> > 
> > So something like they have on ARM?
> > 
> > vince@pandaboard:/sys/bus/event_source/devices$ ls -l
> > lrwxrwxrwx 1 root root 0 Jul  8 21:57 ARMv7 Cortex-A9 -> ../../../devices/ARMv7 Cortex-A9
> > lrwxrwxrwx 1 root root 0 Jul  8 21:57 breakpoint -> ../../../devices/breakpoint
> > lrwxrwxrwx 1 root root 0 Jul  8 21:57 software -> ../../../devices/software
> > lrwxrwxrwx 1 root root 0 Jul  8 21:57 tracepoint -> ../../../devices/tracepoint
> 
> Right so what I remember of the ARM case is that their /proc/cpuinfo isn't
> sufficient to identify their PMU. And they don't have a cpuid like instruction
> at all.

libpfm4 uses the
   CPU part	: 0xc09
line in /proc/cpuinfo on ARM, and that's enough for the processors PAPI 
supports (Cortex A8/A9/A15 plus the 1176 on the raspberry-pi).  I'm 
guessing it wouldn't be enough if we wanted to support *all* ARMs with
PMUs.

And speaking of ARM, I should be railing at them for breaking the ABI too, 
with their (understandable yet still ABI breaking) decision to remove 
BogoMIPS from /proc/cpuinfo.  That change will impact PAPI as well as 
various other programs I maintain that have the misfortune of parsing that 
file.

Vince
