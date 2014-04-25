Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752823AbaDYQGQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 12:06:16 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:51911 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752637AbaDYQGE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 12:06:04 -0400
Date: Fri, 25 Apr 2014 18:05:53 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Vincent Guittot <vincent.guittot@linaro.org>
Cc: Dietmar Eggemann <dietmar.eggemann@arm.com>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "tony.luck@intel.com" <tony.luck@intel.com>,
        "fenghua.yu@intel.com" <fenghua.yu@intel.com>,
        "schwidefsky@de.ibm.com" <schwidefsky@de.ibm.com>,
        "cmetcalf@tilera.com" <cmetcalf@tilera.com>,
        "benh@kernel.crashing.org" <benh@kernel.crashing.org>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "preeti@linux.vnet.ibm.com" <preeti@linux.vnet.ibm.com>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>
Subject: Re: [PATCH v4 5/5] sched: ARM: create a dedicated scheduler topology
 table
Message-ID: <20140425160553.GW13658@twins.programming.kicks-ass.net>
References: <1397209481-28542-1-git-send-email-vincent.guittot@linaro.org>
 <1397209481-28542-6-git-send-email-vincent.guittot@linaro.org>
 <5357A802.1030804@arm.com>
 <CAKfTPtDnw-OZZekdE3oNGS11m6dfpS4veMNZ_Bezs-Lm7zn6QQ@mail.gmail.com>
 <5357DBA5.1010106@arm.com>
 <CAKfTPtAOZqnP=sWeJuqFAqrGT8vLQZKj+tpqiwOTG37paXoGjg@mail.gmail.com>
 <53590835.9090803@arm.com>
 <CAKfTPtAq8PXS-n7A0W6ESe08m-6O3u84BcY3==+-0+63+uca9g@mail.gmail.com>
 <20140425160419.GL11096@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140425160419.GL11096@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 25, 2014 at 06:04:19PM +0200, Peter Zijlstra wrote:
> > The example above is consistent because CPU2 mask and CPU0 mask are
> > fully exclusive
> > 
> > so
> > CPU0: cpu_corepower_mask=0-1
> > CPU2: cpu_corepower_mask=2
> > are consistent
> > 
> > CPU0: cpu_corepower_mask=0-2
> > CPU2: cpu_corepower_mask=0-2
> > are also consistent
> > 
> > but
> > 
> > CPU0: cpu_corepower_mask=0-1
> > CPU2: cpu_corepower_mask=0-2
> > are not consistent
> > 
> > and your example uses the last configuration
> > 
> > To be more precise, the rule above applies on default SDT definition
> > but the flag SD_OVERLAP enables such kind of overlap between group.
> > Have you tried it ?
> 
> I've never tried degenerate stuff with SD_OVERLAP, it might horribly
> explode -- its not actually meant to work.
> 
> The SD_OVERLAP comes from not fully connected NUMA topologies; suppose
> something like:
> 
>         0------1
>         |      |
>         |      |
>         2------3
> 
> or:
> 
>  ( 10 20 20  0 )
>  ( 20 10  0 20 )
>  ( 20  0 10 20 )
>  (  0 20 20 10 )

d'0h: s/0/30/

0 <-> 3 is 2 hops, too focused on the single hop case

> Your domain level that models the single-hop/20 distance has overlapping
> masks:
> 
> N0: 0-2
> N1: 0,1,3
> N2: 0,2,3
> N3: 1-3
> 
> I've never tried to construct a NUMA topology that would be overlapping
> and have redundant bits in.
