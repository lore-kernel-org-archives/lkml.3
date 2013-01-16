Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755948Ab3APNcX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 08:32:23 -0500
Received: from mx1.redhat.com ([209.132.183.28]:65078 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753869Ab3APNcW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 08:32:22 -0500
Date: Wed, 16 Jan 2013 14:30:33 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Will Deacon <will.deacon@arm.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zij@mx0.arm.com>
Subject: Re: [RFC 0/4] perf tool: Adding ratios support
Message-ID: <20130116133033.GC1042@krava.brq.redhat.com>
References: <1358257194-8204-1-git-send-email-jolsa@redhat.com>
 <20130116131318.GF16543@mudshark.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130116131318.GF16543@mudshark.cambridge.arm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 16, 2013 at 01:13:18PM +0000, Will Deacon wrote:
> On Tue, Jan 15, 2013 at 01:39:50PM +0000, Jiri Olsa wrote:
> > hi,
> 
> Hi Jiri,
> 
> > adding support to predefine event ratios formulas so they could
> > be used easily in perf.
> > 
> > The formulas are handed in the config file with following format:
> > 
> >   set {
> >         events = {cycles,instructions,branch-instructions}:u
> > 
> >         cpi {
> >                 formula = cycles / instructions
> >                 desc = cycles per instruction
> >         }
> > 
> > 	branch-rate {
> >                 formula = branch-instructions / instructions
> >                 desc = branch rate
> >         }
> >   }
> > 
> >   The 'set' defines set of counter that share same events.
> >   Each 'set' defines:
> >     events   - event string that would go into stat/record -e option
> >     counters - any number of counters based on above events
> > 
> >   Each counter (cpi/branch-rate) defines
> >     formula - formula with that produce the counter number
> >               event names and numbers could be used
> >     desc    - text description of the counter
> > 
> > The formula can currently contain any event from the set::events
> > plus any number (int). There'll be support in future for outside
> > values runtime and other if needed.
> 
> Just to say that I *really* like this idea! If we extended it to include
> other operators then it would help us on ARM, where we often have events
> like 'cache accesses' and 'cache misses' but not 'cache hits'.

great, thanks for sharing this

The current operators set is just basic one to show the idea,
it can/will be expanded.

> 
> > My current thinking is to have generic formulas file(s) for architectural
> > events and add arch-specific ones once when we have the support for
> > non-architectural events (already sent RFC, v2 is on its way..).
> 
> Would the architectural formula files also be in userspace, or is there any
> merit to including useful PMU-specific formulae in sysfs, along with the
> other PMU files?

hum, isn't this too specific for sysfs files?

I think that's going to be the perf tool specific info.. so it's going
to be placed in its configuration files.


jirka
