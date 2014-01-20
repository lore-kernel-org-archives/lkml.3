Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753745AbaATN7t (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jan 2014 08:59:49 -0500
Received: from mail-vb0-f41.google.com ([209.85.212.41]:35218 "EHLO
	mail-vb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750807AbaATN7p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jan 2014 08:59:45 -0500
MIME-Version: 1.0
In-Reply-To: <CAKohpomO+2WbNLceBznWwYRcv0e7RsPiaRF7ctRZ+6GFKtr4aA@mail.gmail.com>
References: <CAKohpomO+2WbNLceBznWwYRcv0e7RsPiaRF7ctRZ+6GFKtr4aA@mail.gmail.com>
Date: Mon, 20 Jan 2014 21:59:44 +0800
Message-ID: <CALZhoSRvhqJXU=z=h30SS6USjHFe3yKLsJN9WzQr6ch0sxoN-g@mail.gmail.com>
Subject: Re: [QUERY]: Is using CPU hotplug right for isolating CPUs?
From: Lei Wen <adrian.wenl@gmail.com>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: =?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>,
        Kevin Hilman <khilman@linaro.org>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Linaro Networking <linaro-networking@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Viresh,

On Wed, Jan 15, 2014 at 5:27 PM, Viresh Kumar <viresh.kumar@linaro.org> wrote:
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
>
> So after creating CPUsets I hotunplugged CPU1 and added it back
> immediately. This moved all these interruptions away and now
> CPU1 is running my single thread ("stress") for ever.

I have one question regarding unbounded workqueue migration in your case.
You use hotplug to migrate the unbounded work to other cpus, but its cpu mask
would still be 0xf, since cannot be changed by cpuset.

My question is how you could prevent this unbounded work migrate back
to your isolated cpu?
Seems to me there is no such mechanism in kernel, am I understand wrong?

Thanks,
Lei

>
> Now my question is: Is there anything particularly wrong about using
> hotplugging here ? Will that lead to a disaster :)
>
> Thanks in Advance.
>
> --
> viresh
>
> _______________________________________________
> linaro-kernel mailing list
> linaro-kernel@lists.linaro.org
> http://lists.linaro.org/mailman/listinfo/linaro-kernel
