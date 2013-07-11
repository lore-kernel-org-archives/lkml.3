Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755980Ab3GKRrg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 13:47:36 -0400
Received: from mail-ve0-f177.google.com ([209.85.128.177]:57208 "EHLO
	mail-ve0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752131Ab3GKRre (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 13:47:34 -0400
Date: Thu, 11 Jul 2013 13:53:11 -0400 (EDT)
From: Vince Weaver <vincent.weaver@maine.edu>
To: Will Deacon <will.deacon@arm.com>
cc: Vince Weaver <vincent.weaver@maine.edu>,
        Peter Zijlstra <peterz@infradead.org>,
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
Subject: Re: [PATCH v2 2/2] perf tools: Make Power7 events available for
 perf
In-Reply-To: <20130711105843.GG32197@mudshark.cambridge.arm.com>
Message-ID: <alpine.DEB.2.10.1307111340090.32218@vincent-weaver-1.um.maine.edu>
References: <1372170933-4538-1-git-send-email-runzhen@linux.vnet.ibm.com> <1372170933-4538-3-git-send-email-runzhen@linux.vnet.ibm.com> <alpine.DEB.2.02.1306251240440.25443@pianoman.cluster.toy> <20130704125218.GA21134@concordia>
 <20130704125700.GM18898@dyad.programming.kicks-ass.net> <20130709012952.GA7185@concordia> <alpine.DEB.2.10.1307082204550.26280@vincent-weaver-1.um.maine.edu> <20130709081434.GI25631@dyad.programming.kicks-ass.net> <alpine.DEB.2.10.1307091059270.675@vincent-weaver-1.um.maine.edu>
 <20130711105843.GG32197@mudshark.cambridge.arm.com>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 11 Jul 2013, Will Deacon wrote:
> On Tue, Jul 09, 2013 at 04:05:30PM +0100, Vince Weaver wrote:

> > libpfm4 uses the
> >    CPU part	: 0xc09
> > line in /proc/cpuinfo on ARM, and that's enough for the processors PAPI 
> 
> The CPU part you cite is actually A9-specific, so you probably want to
> probe each CPU specifically. Take a look at the cpuinfo parsing in OProfile
> (used by operf).

I meant we use the CPU part line to probe things.  I just cut and pasted
from a Cortex A9 I had handy as an example.

> > And speaking of ARM, I should be railing at them for breaking the ABI too, 
> > with their (understandable yet still ABI breaking) decision to remove 
> > BogoMIPS from /proc/cpuinfo.  That change will impact PAPI as well as 
> > various other programs I maintain that have the misfortune of parsing that 
> > file.
> 
> Really? Why are you checking for that line at all?

Old programs.

PAPI dates back to the day when processor frequency was meaningful (and 
stable).  In cases where MHz wasn't reported in cpuinfo (mostly MIPS and 
ARM) it tries to estimate it based on BogoMIPS.  Not the sanest thing to 
do, but it worked well enough at the time.  We recently fixed things so it 
should do something reasonable if BogoMIPS is missing, but if users wrote 
their code poorly they can get divide by zero errors if BogoMIPS suddenly 
goes missing from /proc/cpuinfo (and yes we have had a low but non-zero 
number of users report bugs of this type).

Other programs I have (like linux_logo and ll) are 15+ years old and 
simply print the BogoMIPS value for historical reasons.  So they won't 
break if the value goes away but it's still sad to see it go.

Vince

