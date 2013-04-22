Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752325Ab3DVL7r (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Apr 2013 07:59:47 -0400
Received: from merlin.infradead.org ([205.233.59.134]:35903 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751837Ab3DVL7q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Apr 2013 07:59:46 -0400
Message-ID: <1366631983.4443.11.camel@laptop>
Subject: Re: [PATCH v2 2/6] sched: explicitly cpu_idle_type checking in
 rebalance_domains()
From: Peter Zijlstra <peterz@infradead.org>
To: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
Date: Mon, 22 Apr 2013 13:59:43 +0200
In-Reply-To: <1364277700-7509-3-git-send-email-iamjoonsoo.kim@lge.com>
References: <1364277700-7509-1-git-send-email-iamjoonsoo.kim@lge.com>
	 <1364277700-7509-3-git-send-email-iamjoonsoo.kim@lge.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-03-26 at 15:01 +0900, Joonsoo Kim wrote:
> @@ -5506,10 +5506,10 @@ static void rebalance_domains(int cpu, enum
> cpu_idle_type idle)
>                 if (time_after_eq(jiffies, sd->last_balance +
> interval)) {
>                         if (load_balance(cpu, rq, sd, idle, &balance))
> {
>                                 /*
> -                                * We've pulled tasks over so either
> we're no
> -                                * longer idle.
> +                                * We've pulled tasks over so either
> we may
> +                                * be no longer idle.
>                                  */

That comment didn't make sense and it does even less now.

How about we make that:

  /*
   * The LBF_SOME_PINNED logic could have changed
   * env->dst_cpu, so we can't know our idle state
   * even if we migrated tasks; update it.
   */

> -                               idle = CPU_NOT_IDLE;
> +                               idle = idle_cpu(cpu) ? CPU_IDLE :
> CPU_NOT_IDLE;
>                         }
>                         sd->last_balance = jiffies;
>                 }


