Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760585AbaJ3OpA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 10:45:00 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:40081 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760250AbaJ3Oo6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 10:44:58 -0400
Date: Thu, 30 Oct 2014 15:44:50 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Len Brown <lenb@kernel.org>
Cc: Daniel Lezcano <daniel.lezcano@linaro.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        axboe@kernel.dk, "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Ingo Molnar <mingo@kernel.org>, preeti@linux.vnet.ibm.com,
        Morten Rasmussen <Morten.Rasmussen@arm.com>, mturquette@linaro.org,
        Tuukka Tikkanen <tuukka.tikkanen@linaro.org>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Patch Tracking <patches@linaro.org>
Subject: Re: [RFD PATCH 01/10] sched: add io latency framework
Message-ID: <20141030144450.GG23531@worktop.programming.kicks-ass.net>
References: <1413986273-28522-1-git-send-email-daniel.lezcano@linaro.org>
 <1413986273-28522-2-git-send-email-daniel.lezcano@linaro.org>
 <CAJvTdKkF1Z9eUwjv4-idzCUTzD_MdEeZWOxkB+VmGoEcnJfk-A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJvTdKkF1Z9eUwjv4-idzCUTzD_MdEeZWOxkB+VmGoEcnJfk-A@mail.gmail.com>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 27, 2014 at 11:19:49PM -0400, Len Brown wrote:
> > There is a rb tree per cpu. Each time a task is blocked on an IO, it
> > is inserted into the tree. When the IO is complete and the task is
> > woken up, its avg latency is updated with the time spent to wait the
> > IO and it is removed from the tree. The next time, it will be inserted
> > into the tree again in case of io_schedule.
> 
> Is there an assumption built-in here that the device interrupt is targeted
> at the same CPU as where the task is queued?

Yes, I pointed out that this is unlikely to be true during his
presentation in DUS.

My suggestion was to track interrupts per device and use the IRQ routing
to map them to CPUs.

The benchmarking of the approach was done on a UP (or rather, everything
affinity bound to cpu0) which did obviously not expose this particular
issue.


