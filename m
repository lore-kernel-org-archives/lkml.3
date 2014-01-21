Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754293AbaAUJtl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 04:49:41 -0500
Received: from mail-ob0-f181.google.com ([209.85.214.181]:58884 "EHLO
	mail-ob0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754158AbaAUJtj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 04:49:39 -0500
MIME-Version: 1.0
In-Reply-To: <20140120154058.GA9436@localhost.localdomain>
References: <CAKohpomO+2WbNLceBznWwYRcv0e7RsPiaRF7ctRZ+6GFKtr4aA@mail.gmail.com>
	<CALZhoSRvhqJXU=z=h30SS6USjHFe3yKLsJN9WzQr6ch0sxoN-g@mail.gmail.com>
	<CAKohpokbb3ko3sW4kuDKZSoY1qJ6apVVR3-jpv=7m5ZX__YP8Q@mail.gmail.com>
	<20140120154058.GA9436@localhost.localdomain>
Date: Tue, 21 Jan 2014 15:19:36 +0530
Message-ID: <CAKohpon=VagQfYauMfb-UH7MQCHATO5i0xDL1_3r=zzpJ4w9zw@mail.gmail.com>
Subject: Re: [QUERY]: Is using CPU hotplug right for isolating CPUs?
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Lei Wen <adrian.wenl@gmail.com>, Kevin Hilman <khilman@linaro.org>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Linaro Networking <linaro-networking@linaro.org>,
        Tejun Heo <tj@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20 January 2014 21:11, Frederic Weisbecker <fweisbec@gmail.com> wrote:
> But for workqueues having a global affinity, I think they can be rescheduled later
> on the old CPUs. Although I'm not sure about that, I'm Cc'ing Tejun.

Works queued on workqueues with WQ_UNBOUND flag set are run on any cpu
and is decided by scheduler, whereas works queued on workqueues with this
flag not set and without a cpu number mentioned while queuing work,
runs on local
CPU always.

> Also, one of the plan is to extend the sysfs interface of workqueues to override
> their affinity. If any of you guys want to try something there, that would be welcome.
> Also we want to work on the timer affinity. Perhaps we don't need a user interface
> for that, or maybe something on top of full dynticks to outline that we want the unbound
> timers to run on housekeeping CPUs only.

What about a quiesce option as mentioned by PeterZ? With that we can move
all UNBOUND timers and workqueues away. But to guarantee that we don't get
them queued again later we need to make similar updates in workqueue/timer
subsystem to disallow queuing any such stuff on such cpusets.
