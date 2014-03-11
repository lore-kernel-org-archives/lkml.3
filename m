Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755370AbaCKKcE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 06:32:04 -0400
Received: from merlin.infradead.org ([205.233.59.134]:48191 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752753AbaCKKcA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 06:32:00 -0400
Date: Tue, 11 Mar 2014 11:31:19 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Vincent Guittot <vincent.guittot@linaro.org>
Cc: Dietmar Eggemann <dietmar.eggemann@arm.com>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "tony.luck@intel.com" <tony.luck@intel.com>,
        "fenghua.yu@intel.com" <fenghua.yu@intel.com>,
        "schwidefsky@de.ibm.com" <schwidefsky@de.ibm.com>,
        "james.hogan@imgtec.com" <james.hogan@imgtec.com>,
        "cmetcalf@tilera.com" <cmetcalf@tilera.com>,
        "benh@kernel.crashing.org" <benh@kernel.crashing.org>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "preeti@linux.vnet.ibm.com" <preeti@linux.vnet.ibm.com>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>
Subject: Re: [PATCH 2/6] sched: rework of sched_domain topology definition
Message-ID: <20140311103119.GW9987@twins.programming.kicks-ass.net>
References: <1394003906-11630-1-git-send-email-vincent.guittot@linaro.org>
 <1394003906-11630-3-git-send-email-vincent.guittot@linaro.org>
 <53175A3C.8010100@arm.com>
 <CAKfTPtC1_t78hvOw9u-t1BqUZj_dO3WFYp2OjX=RFZP-A7zSbg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKfTPtC1_t78hvOw9u-t1BqUZj_dO3WFYp2OjX=RFZP-A7zSbg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 06, 2014 at 04:32:35PM +0800, Vincent Guittot wrote:
> > Never got the new name DIE for CPU? Might confuse people when they use
> > /proc/sys/kernel/sched_domain/cpuX/domainY/name or sched_domain_debug_one().
> 
> In fact, CPU is also confusing because it's used for different things.
> But if it makes things even more confusing, i can come back to CPU

Yeah, not sure DIE is the right thing either; because there's multi-die
packages that get classified under CPU :-)

Take for example the Core 2 Quad, which was 2 dual core dies glued
together in a single package.

There's also the AMD bulldozer which glued two dies into a single
package; but for those its not a problem because each die is a separate
numa node, so there DIE would actually be the correct term and PACKAGE
would be wrong.

So while CPU sucks, I'm not sure we can come up with anything that's
actually correct. That said; we could try for something less wrong than
CPU :-)

I'm not sure there are a lot of people who see/know the names of these
domains to be bothered by a change in them; it might be limited to just
us for all I know.
