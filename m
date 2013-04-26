Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757110Ab3DZTL0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Apr 2013 15:11:26 -0400
Received: from mail-qc0-f173.google.com ([209.85.216.173]:49270 "EHLO
	mail-qc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750987Ab3DZTLY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Apr 2013 15:11:24 -0400
Date: Fri, 26 Apr 2013 12:11:18 -0700
From: Tejun Heo <tj@kernel.org>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: Amit Kucheria <amit.kucheria@linaro.org>, davem@davemloft.net,
        linux-rt-users@vger.kernel.org, linux-kernel@vger.kernel.org,
        Robin Randhawa <robin.randhawa@arm.com>,
        Charles Garcia-Tobin <charles.garcia-tobin@arm.com>,
        Steve Bannister <Steve.Bannister@arm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Arvind Chauhan <arvind.chauhan@arm.com>,
        Patch Tracking <patches@linaro.org>, airlied@redhat.com,
        mingo@redhat.com, Jens Axboe <axboe@kernel.dk>,
        Liviu Dudau <Liviu.Dudau@arm.com>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>
Subject: Re: [PATCH V5 1/5] workqueues: Introduce new flag WQ_POWER_EFFICIENT
 for power oriented workqueues
Message-ID: <20130426191118.GD1433@mtj.dyndns.org>
References: <cover.1366803121.git.viresh.kumar@linaro.org>
 <480f5d6da920e2f2b868f311228c81635727799e.1366803121.git.viresh.kumar@linaro.org>
 <CAP245DWtwguSp8ubid_KJnLSOqvCbmTXN+0Bg_MtDrUhBqve-Q@mail.gmail.com>
 <CAKohpokN_o-RUX6MDwqqfzu4NKRysG-hSzmB=MHV7Y0aDbztuA@mail.gmail.com>
 <20130424161208.GA16991@mtj.dyndns.org>
 <CAP245DUGuaSQbP4026N8kgn6-NqXFJWR3zKoYud=HQ_b+v5+Xw@mail.gmail.com>
 <CAKohpo=U5OqN7SM7XyOWv-WoUHOoJvGc6wcGH61+uikPK3novg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKohpo=U5OqN7SM7XyOWv-WoUHOoJvGc6wcGH61+uikPK3novg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey, Viresh.

It's already too late for the upcoming merge window, but things
generally look good to me and I'll apply the patchset once wq/for-3.11
opens.  One nitpick tho.

On Thu, Apr 25, 2013 at 09:13:44AM +0530, Viresh Kumar wrote:
> +	workqueue.power_efficient
> +			Workqueues can be performance or power-oriented.
> +			Currently, most workqueues are bound to the CPU they
                                   ^^^^
                                   per-cpu would be better

> +			were created on. This gives good performance (due to
> +			cache effects) at the cost of potentially waking up
> +			otherwise idle cores just to process some work. To save
> +			power, we can allow the work to be rescheduled on a core
> +			that is already awake.

The above description is confusing to me.  As have been discussed
multiple times before, per-cpu workqueue in itself doesn't wake up the
CPU physically.  The timer may but per-cpu workqueue doesn't.  It was
confusing when this patchset was first posted and the above phrasing
is still confusing.  What the patchset tries to do is preventing the
scheduler from perceiving the CPU as active due to the activated
worker thread pinned to that CPU, right?  The knob doesn't really do
anything about waking up the processor in itself.  It just avoids
feeding the scheduler with noisy activation events and allows it to
allocate work item execution according to the scheduler's view of CPU
active/idleness.  As the scheduler has longer / larger scope of
overall CPU activities and means to regulate them, this leads to more
power-efficient allocation of work item executions, right?  It'd be
really great if the descriptions and the comment above the flag makes
this abundantly clear because it's not something too apparent.

Thanks.

-- 
tejun
