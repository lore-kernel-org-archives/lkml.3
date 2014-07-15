Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758163AbaGOJ1q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 05:27:46 -0400
Received: from mail-ob0-f171.google.com ([209.85.214.171]:56942 "EHLO
	mail-ob0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757990AbaGOJ1n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 05:27:43 -0400
MIME-Version: 1.0
In-Reply-To: <20140711161344.GD26542@e103034-lin>
References: <1404144343-18720-1-git-send-email-vincent.guittot@linaro.org>
 <1404144343-18720-10-git-send-email-vincent.guittot@linaro.org>
 <20140710131646.GB3935@laptop> <CAKfTPtDzxyrzVmX016VB8j_y19wcCBVB1Rj46FYngMA+Ajft6g@mail.gmail.com>
 <20140711161344.GD26542@e103034-lin>
From: Vincent Guittot <vincent.guittot@linaro.org>
Date: Tue, 15 Jul 2014 11:27:19 +0200
Message-ID: <CAKfTPtDeTnPVM5nFR19eWRQZMtAZ3B2dB36q4qGNH=URgfLfHw@mail.gmail.com>
Subject: Re: [PATCH v3 09/12] Revert "sched: Put rq's sched_avg under CONFIG_FAIR_GROUP_SCHED"
To: Morten Rasmussen <morten.rasmussen@arm.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        LAK <linux-arm-kernel@lists.infradead.org>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        Mike Galbraith <efault@gmx.de>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Dietmar Eggemann <Dietmar.Eggemann@arm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11 July 2014 18:13, Morten Rasmussen <morten.rasmussen@arm.com> wrote:

[snip]

>
> In this example using rq->avg leads to imbalance whereas unweighted load
> would not. Correct me if I missed anything.

You just miss to take into account how the imbalance is computed

>
> Coming back to the previous example. I'm not convinced that inflation of
> the unweighted load sum when tasks overlap in time is a bad thing. I
> have mentioned this before. The average cpu utilization over the 40ms
> period is 50%. However the true compute capacity demand is 200% for the
> first 15ms of the period, 100% for the next 5ms and 0% for the remaining
> 25ms. The cpu is actually overloaded for 15ms every 40ms. This fact is
> factored into the unweighted load whereas rq->avg would give you the
> same utilization no matter if the tasks are overlapped or not. Hence
> unweighted load would give us an indication that the mix of tasks isn't
> optimal even if the cpu has spare cycles.
>
> If you don't care about overlap and latency, the unweighted sum of task
> running time (that Peter has proposed a number of times) is better
> metric, IMHO. As long the cpu isn't fully utilized.
>
> Morten
