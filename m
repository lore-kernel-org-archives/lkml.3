Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754612Ab3KKQjd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 11:39:33 -0500
Received: from merlin.infradead.org ([205.233.59.134]:38506 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753946Ab3KKQjY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 11:39:24 -0500
Date: Mon, 11 Nov 2013 17:38:59 +0100
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
Message-ID: <20131111163859.GE26898@twins.programming.kicks-ass.net>
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
> My understanding from the recent discussions is that the scheduler
> should decide directly on the C-state (or rather the deepest C-state
> possible since we don't want to duplicate the backend logic for
> synchronising CPUs going up or down). This means that the scheduler
> needs to know about C-state target residency, wake-up latency (I think
> we can leave coupled C-states to the backend, there is some complex
> synchronisation which I wouldn't duplicate).
> 
> Alternatively (my preferred approach), we get the scheduler to predict
> and pass the expected residency and latency requirements down to a
> power driver and read back the actual C-states for making task
> placement decisions. Some of the menu governor prediction logic could
> be turned into a library and used by the scheduler. Basically what
> this tries to achieve is better scheduler awareness of the current
> C-states decided by a cpuidle/power driver based on the scheduler
> constraints.

Ah yes.. so I _think_ the scheduler wants to eventually know about idle
topology constraints. But we can get there in a gradual fashion I hope.

Like the package C states on x86 -- for those to be effective the
scheduler needs to pack tasks and keep entire packages idle for as long
as possible.


