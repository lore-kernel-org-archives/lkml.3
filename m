Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755520AbaAFQWU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 11:22:20 -0500
Received: from merlin.infradead.org ([205.233.59.134]:35078 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754824AbaAFQWS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 11:22:18 -0500
Date: Mon, 6 Jan 2014 17:21:45 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Vincent Guittot <vincent.guittot@linaro.org>
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, pjt@google.com,
        Morten.Rasmussen@arm.com, cmetcalf@tilera.com, tony.luck@intel.com,
        alex.shi@linaro.org, preeti@linux.vnet.ibm.com,
        linaro-kernel@lists.linaro.org, rjw@sisk.pl,
        paulmck@linux.vnet.ibm.com, corbet@lwn.net, tglx@linutronix.de,
        len.brown@intel.com, arjan@linux.intel.com, amit.kucheria@linaro.org,
        james.hogan@imgtec.com, schwidefsky@de.ibm.com,
        heiko.carstens@de.ibm.com, Dietmar.Eggemann@arm.com
Subject: Re: [RFC] sched: CPU topology try
Message-ID: <20140106162145.GL31570@twins.programming.kicks-ass.net>
References: <20131105222752.GD16117@laptop.programming.kicks-ass.net>
 <1387372431-2644-1-git-send-email-vincent.guittot@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1387372431-2644-1-git-send-email-vincent.guittot@linaro.org>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 18, 2013 at 02:13:51PM +0100, Vincent Guittot wrote:
> This patch applies on top of the two patches [1][2] that have been proposed by
> Peter for creating a new way to initialize sched_domain. It includes some minor
> compilation fixes and a trial of using this new method on ARM platform.
> [1] https://lkml.org/lkml/2013/11/5/239
> [2] https://lkml.org/lkml/2013/11/5/449
> 
> Based on the results of this tests, my feeling about this new way to init the
> sched_domain is a bit mitigated.

Yay :-)

> We can add more levels that will describe other dependency/independency like
> the frequency scaling dependency and as a result the final sched_domain
> topology will have additional levels (if they have not been removed during
> the degenerate sequence)

Yeah, this 'creative' use of degenerate domains is pretty neat ;-)

> My concern is about the configuration of the table that is used to create the
> sched_domain. Some levels are "duplicated" with different flags configuration
> which make the table not easily readable and we must also take care of the
> order  because parents have to gather all cpus of its childs. So we must
> choose which capabilities will be a subset of the other one. The order is
> almost straight forward when we describe 1 or 2 kind of capabilities
> (package ressource sharing and power sharing) but it can become complex if we
> want to add more.

I think I see what you're saying, although I hope that won't actually
happen in real hardware -- that said, people do tend to do crazy with
these ARM chips :/

We should also try and be conservative in the topology flags we want to
add, which should further reduce the amount of pain here.

For now I do think this is a viable approach.. Yes its a bit cumbersome
for these asymmetric systems but it does give us enough to start
playing.

I yet have to read Morton's emails on the P and C states, will try to
have a look at those tomorrow with a hopefully fresher brain -- somehow
its the end of the day already..
