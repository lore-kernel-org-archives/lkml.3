Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751427AbaEYKiZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 May 2014 06:38:25 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:47419 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751342AbaEYKiY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 May 2014 06:38:24 -0400
Message-ID: <5381C70E.3030605@linux.vnet.ibm.com>
Date: Sun, 25 May 2014 16:03:50 +0530
From: Preeti U Murthy <preeti@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Vincent Guittot <vincent.guittot@linaro.org>, peterz@infradead.org
CC: mingo@kernel.org, linux-kernel@vger.kernel.org, linux@arm.linux.org.uk,
        linux-arm-kernel@lists.infradead.org, Morten.Rasmussen@arm.com,
        efault@gmx.de, nicolas.pitre@linaro.org,
        linaro-kernel@lists.linaro.org, daniel.lezcano@linaro.org
Subject: Re: [PATCH v2 01/11] sched: fix imbalance flag reset
References: <1400860385-14555-1-git-send-email-vincent.guittot@linaro.org> <1400860385-14555-2-git-send-email-vincent.guittot@linaro.org>
In-Reply-To: <1400860385-14555-2-git-send-email-vincent.guittot@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14052510-7182-0000-0000-00000AADA5D8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Vincent,

On 05/23/2014 09:22 PM, Vincent Guittot wrote:
> The imbalance flag can stay set whereas there is no imbalance.
> 
> Let assume that we have 3 tasks that run on a dual cores /dual cluster system.
> We will have some idle load balance which are triggered during tick.
> Unfortunately, the tick is also used to queue background work so we can reach
> the situation where short work has been queued on a CPU which already runs a
> task. The load balance will detect this imbalance (2 tasks on 1 CPU and an idle
> CPU) and will try to pull the waiting task on the idle CPU. The waiting task is
> a worker thread that is pinned on a CPU so an imbalance due to pinned task is
> detected and the imbalance flag is set.
> Then, we will not be able to clear the flag because we have at most 1 task on
> each CPU but the imbalance flag will trig to useless active load balance
> between the idle CPU and the busy CPU.

Why do we do active balancing today when there is at-most 1 task on the
busiest cpu? Shouldn't we be skipping load balancing altogether? If we
do active balancing when the number of tasks = 1, it will lead to a ping
pong right?

Regards
Preeti U Murthy

