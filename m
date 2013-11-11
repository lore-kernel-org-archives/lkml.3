Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754476Ab3KKQhE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 11:37:04 -0500
Received: from merlin.infradead.org ([205.233.59.134]:38454 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753782Ab3KKQg4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 11:36:56 -0500
Date: Mon, 11 Nov 2013 17:36:30 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Vincent Guittot <vincent.guittot@linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Paul Turner <pjt@google.com>,
        Morten Rasmussen <Morten.Rasmussen@arm.com>,
        Chris Metcalf <cmetcalf@tilera.com>, Tony Luck <tony.luck@intel.com>,
        "alex.shi@intel.com" <alex.shi@intel.com>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        linaro-kernel <linaro-kernel@lists.linaro.org>,
        "len.brown@intel.com" <len.brown@intel.com>, l.majewski@samsung.com,
        Jonathan Corbet <corbet@lwn.net>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Arjan van de Ven <arjan@linux.intel.com>, linux-pm@vger.kernel.org
Subject: Re: [RFC][PATCH v5 00/14] sched: packing tasks
Message-ID: <20131111163630.GD26898@twins.programming.kicks-ass.net>
References: <1382097147-30088-1-git-send-email-vincent.guittot@linaro.org>
 <CAHkRjk69GNYtLGBSWCNcsCzkBHywKrD0qQQbNkJRpMbcdsCPyw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHkRjk69GNYtLGBSWCNcsCzkBHywKrD0qQQbNkJRpMbcdsCPyw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 11, 2013 at 11:33:45AM +0000, Catalin Marinas wrote:

tl;dr :-) Still trying to wrap my head around how to do that weird
topology Vincent raised..

> Question for Peter/Ingo: do you want the scheduler to decide on which
> C-state a CPU should be in or we still leave this to a cpuidle
> layer/driver?

I think the can leave most of that in a driver; right along with how to
prod the hardware to actually get into that state.

I think the most important parts are what is now 'generic' code; stuff
that guestimates the idle-time and so forth.

I think the scheduler simply wants to say: we expect to go idle for X
ns, we want a guaranteed wakeup latency of Y ns -- go do your thing.

I think you also raised the point in that we do want some feedback as to
the cost of waking up particular cores to better make decisions on which
to wake. That is indeed so.
