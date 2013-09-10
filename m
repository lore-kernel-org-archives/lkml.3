Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755196Ab3IJIGq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 04:06:46 -0400
Received: from merlin.infradead.org ([205.233.59.134]:40418 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754778Ab3IJIGn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 04:06:43 -0400
Date: Tue, 10 Sep 2013 10:06:35 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Dave Chinner <david@fromorbit.com>, linux-kernel@vger.kernel.org,
        Paul Turner <pjt@google.com>, Ingo Molnar <mingo@kernel.org>
Subject: Re: [performance regression, bisected] scheduler:
 should_we_balance() kills filesystem performance
Message-ID: <20130910080635.GJ26785@twins.programming.kicks-ass.net>
References: <20130910040254.GB12779@dastard>
 <20130910044759.GA24602@lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130910044759.GA24602@lge.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 10, 2013 at 01:47:59PM +0900, Joonsoo Kim wrote:
> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> index 7f0a5e6..9b3fe1c 100644
> --- a/kernel/sched/fair.c
> +++ b/kernel/sched/fair.c
> @@ -5151,7 +5151,7 @@ static int should_we_balance(struct lb_env *env)
>          * First idle cpu or the first cpu(busiest) in this sched group
>          * is eligible for doing load balancing at this and above domains.
>          */
> -       return balance_cpu != env->dst_cpu;
> +       return balance_cpu == env->dst_cpu;
>  }

Duh.. /me kicks himself for not seeing that.

Thanks!
