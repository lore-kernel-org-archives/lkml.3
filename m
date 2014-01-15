Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752668AbaAORRM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 12:17:12 -0500
Received: from mail-ee0-f52.google.com ([74.125.83.52]:44108 "EHLO
	mail-ee0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752157AbaAORRL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 12:17:11 -0500
Date: Wed, 15 Jan 2014 18:17:06 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: Kevin Hilman <khilman@linaro.org>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Amit Kucheria <amit.kucheria@linaro.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        Linaro Networking <linaro-networking@linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [QUERY]: Is using CPU hotplug right for isolating CPUs?
Message-ID: <20140115171704.GB21574@localhost.localdomain>
References: <CAKohpomO+2WbNLceBznWwYRcv0e7RsPiaRF7ctRZ+6GFKtr4aA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKohpomO+2WbNLceBznWwYRcv0e7RsPiaRF7ctRZ+6GFKtr4aA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 15, 2014 at 02:57:36PM +0530, Viresh Kumar wrote:
> Hi Again,
> 
> I am now successful in isolating a CPU completely using CPUsets,
> NO_HZ_FULL and CPU hotplug..
> 
> My setup and requirements for those who weren't following the
> earlier mails:
> 
> For networking machines it is required to run data plane threads on
> some CPUs (i.e. one thread per CPU) and these CPUs shouldn't be
> interrupted by kernel at all.
> 
> Earlier I tried CPUSets with NO_HZ by creating two groups with
> load_balancing disabled between them and manually tried to move
> all tasks out to CPU0 group. But even then there were interruptions
> which were continuously coming on CPU1 (which I am trying to
> isolate). These were some workqueue events, some timers (like
> prandom), timer overflow events (As NO_HZ_FULL pushes hrtimer
> to long ahead in future, 450 seconds, rather than disabling them
> completely, and these hardware timers were overflowing their
> counters after 90 seconds on Samsung Exynos board).

Are you sure about that? NO_HZ_FULL shouldn't touch much hrtimers.
Those are independant from the tick.

Although some of them seem to rely on the softirq, but that seem to
concern the tick hrtimer only.
