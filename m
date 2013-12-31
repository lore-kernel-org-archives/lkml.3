Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753622Ab3LaPCT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Dec 2013 10:02:19 -0500
Received: from mail-wg0-f53.google.com ([74.125.82.53]:55056 "EHLO
	mail-wg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753421Ab3LaPCS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Dec 2013 10:02:18 -0500
Message-ID: <52C2DC76.4020209@linaro.org>
Date: Tue, 31 Dec 2013 16:02:14 +0100
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Preeti Murthy <preeti.lkml@gmail.com>
CC: mingo@redhat.com, Peter Zijlstra <peterz@infradead.org>,
        linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org
Subject: Re: [PATCH 4/7] sched: remove unused parameter in nohz_balancer_kick
 function
References: <1388411093-3413-1-git-send-email-daniel.lezcano@linaro.org>	<1388411093-3413-5-git-send-email-daniel.lezcano@linaro.org> <CAM4v1pP1=NaKcqki4yh=7gpyRJp8PD4UkQfXwFtd=LTnn7s5Pg@mail.gmail.com>
In-Reply-To: <CAM4v1pP1=NaKcqki4yh=7gpyRJp8PD4UkQfXwFtd=LTnn7s5Pg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/31/2013 12:17 PM, Preeti Murthy wrote:
> Hi Daniel,
>
> This patch looks correct to me.
> Reviewed-by: Preeti U Murthy <preeti@linux.vnet.ibm.com

Thanks Preeti for the review.

   -- Daniel

> <mailto:preeti@linux.vnet.ibm.com>>
>
>
> On Mon, Dec 30, 2013 at 7:14 PM, Daniel Lezcano
> <daniel.lezcano@linaro.org <mailto:daniel.lezcano@linaro.org>> wrote:
>
>     The cpu parameter is no longer needed in nohz_balancer_kick, let's
>     remove
>     the parameter.
>
>     Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org
>     <mailto:daniel.lezcano@linaro.org>>
>     ---
>       kernel/sched/fair.c |    6 ++----
>       1 file changed, 2 insertions(+), 4 deletions(-)
>
>     diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
>     index 1f7ed1a..c647c45 100644
>     --- a/kernel/sched/fair.c
>     +++ b/kernel/sched/fair.c
>     @@ -6517,7 +6517,7 @@ static inline int find_new_ilb(void)
>        * nohz_load_balancer CPU (if there is one) otherwise fallback to
>     any idle
>        * CPU (if there is one).
>        */
>     -static void nohz_balancer_kick(int cpu)
>     +static void nohz_balancer_kick(void)
>       {
>              int ilb_cpu;
>
>     @@ -6871,15 +6871,13 @@ static inline int on_null_domain(struct rq *rq)
>        */
>       void trigger_load_balance(struct rq *rq)
>       {
>     -       int cpu = rq->cpu;
>     -
>              /* Don't need to rebalance while attached to NULL domain */
>              if (time_after_eq(jiffies, rq->next_balance) &&
>                  likely(!on_null_domain(rq)))
>                      raise_softirq(SCHED_SOFTIRQ);
>       #ifdef CONFIG_NO_HZ_COMMON
>              if (nohz_kick_needed(rq) && likely(!on_null_domain(rq)))
>     -               nohz_balancer_kick(cpu);
>     +               nohz_balancer_kick();
>       #endif
>       }
>
>     --
>     1.7.9.5
>
>     --
>     To unsubscribe from this list: send the line "unsubscribe
>     linux-kernel" in
>     the body of a message to majordomo@vger.kernel.org
>     <mailto:majordomo@vger.kernel.org>
>     More majordomo info at http://vger.kernel.org/majordomo-info.html
>     Please read the FAQ at http://www.tux.org/lkml/
>
>


-- 
  <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

