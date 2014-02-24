Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752214AbaBXKrg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 05:47:36 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:63048 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751175AbaBXKrd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 05:47:33 -0500
Date: Mon, 24 Feb 2014 10:46:35 +0000
From: Will Deacon <will.deacon@arm.com>
To: Vince Weaver <vincent.weaver@maine.edu>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Chad Paradis <chad.paradis@umit.maine.edu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Stephane Eranian <eranian@gmail.com>
Subject: Re: [patch/rfc] perf on raspberry-pi without overflow interrupt
Message-ID: <20140224104634.GA2553@mudshark.cambridge.arm.com>
References: <20140108225315.GG31570@twins.programming.kicks-ass.net>
 <alpine.DEB.2.10.1401082245120.22965@vincent-weaver-1.um.maine.edu>
 <20140109101921.GA26435@mudshark.cambridge.arm.com>
 <alpine.DEB.2.10.1401092304590.31813@vincent-weaver-1.um.maine.edu>
 <20140110094056.GK31570@twins.programming.kicks-ass.net>
 <alpine.DEB.2.10.1401132344570.20155@vincent-weaver-1.um.maine.edu>
 <20140114105721.GU7572@laptop.programming.kicks-ass.net>
 <alpine.DEB.2.10.1401161209280.1996@vincent-weaver-1.um.maine.edu>
 <20140116173110.GA9655@laptop.programming.kicks-ass.net>
 <alpine.DEB.2.10.1401170041350.4747@vincent-weaver-1.um.maine.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.10.1401170041350.4747@vincent-weaver-1.um.maine.edu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Vince,

On Fri, Jan 17, 2014 at 05:45:04AM +0000, Vince Weaver wrote:
> On Thu, 16 Jan 2014, Peter Zijlstra wrote:
> 
> > Yeah I suppose we could do something like that. Maybe something like:
> > 
> > # cat /sys/bus/event_source/devices/cpu/flags
> > int precise filter
> 
> wouldn't that violate the "one value per file" rule?
> 
> I guess we could also stick it in the mmap page somewhere, as tools like 
> PAPI already have to check there for things like rdpmc support.
> 
> 
> Anyway, here's a first pass at a generic fix for this issue.  I'm sure the 
> code is pretty horrible, I don't usually mess with the perf code at this 
> level.  I haven't tested yet as it touched enough files that the rasp-pi 
> is going to take a few hours to finish compiling.
> 
> Am I on the right track, or totally off here?

Where did we get to with this? If the generic changes are going to take some
time, I'm happy to take a temporary (non-invasive) fix in the ARM backend while
you sort out the core.

Will
