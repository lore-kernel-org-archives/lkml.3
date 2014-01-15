Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751785AbaAOJ1k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 04:27:40 -0500
Received: from mail-oa0-f53.google.com ([209.85.219.53]:48245 "EHLO
	mail-oa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751004AbaAOJ1g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 04:27:36 -0500
MIME-Version: 1.0
Date: Wed, 15 Jan 2014 14:57:36 +0530
Message-ID: <CAKohpomO+2WbNLceBznWwYRcv0e7RsPiaRF7ctRZ+6GFKtr4aA@mail.gmail.com>
Subject: [QUERY]: Is using CPU hotplug right for isolating CPUs?
From: Viresh Kumar <viresh.kumar@linaro.org>
To: =?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>,
        Kevin Hilman <khilman@linaro.org>
Cc: Vincent Guittot <vincent.guittot@linaro.org>,
        Amit Kucheria <amit.kucheria@linaro.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        Linaro Networking <linaro-networking@linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Again,

I am now successful in isolating a CPU completely using CPUsets,
NO_HZ_FULL and CPU hotplug..

My setup and requirements for those who weren't following the
earlier mails:

For networking machines it is required to run data plane threads on
some CPUs (i.e. one thread per CPU) and these CPUs shouldn't be
interrupted by kernel at all.

Earlier I tried CPUSets with NO_HZ by creating two groups with
load_balancing disabled between them and manually tried to move
all tasks out to CPU0 group. But even then there were interruptions
which were continuously coming on CPU1 (which I am trying to
isolate). These were some workqueue events, some timers (like
prandom), timer overflow events (As NO_HZ_FULL pushes hrtimer
to long ahead in future, 450 seconds, rather than disabling them
completely, and these hardware timers were overflowing their
counters after 90 seconds on Samsung Exynos board).

So after creating CPUsets I hotunplugged CPU1 and added it back
immediately. This moved all these interruptions away and now
CPU1 is running my single thread ("stress") for ever.

Now my question is: Is there anything particularly wrong about using
hotplugging here ? Will that lead to a disaster :)

Thanks in Advance.

--
viresh
