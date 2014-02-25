Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753509AbaBYUxA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 15:53:00 -0500
Received: from merlin.infradead.org ([205.233.59.134]:53134 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753093AbaBYUw7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 15:52:59 -0500
Date: Tue, 25 Feb 2014 21:52:53 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Dietmar Eggemann <dietmar.eggemann@arm.com>
Cc: Ben Segall <bsegall@google.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sched: put rq's sched_avg under CONFIG_FAIR_GROUP_SCHED
Message-ID: <20140225205253.GB18404@twins.programming.kicks-ass.net>
References: <1393328862-19997-1-git-send-email-dietmar.eggemann@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1393328862-19997-1-git-send-email-dietmar.eggemann@arm.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 25, 2014 at 11:47:42AM +0000, Dietmar Eggemann wrote:
> +++ b/kernel/sched/sched.h
> @@ -630,7 +630,9 @@ struct rq {
>  	struct llist_head wake_list;
>  #endif
>  
> +#ifdef CONFIG_FAIR_GROUP_SCHED
>  	struct sched_avg avg;
> +#endif
>  };

There is already a CONFIG_FAIR_GROUP_SCHED #ifdef in that structure;
does it make sense to move this variable in there instead of adding yet
another #ifdef?
