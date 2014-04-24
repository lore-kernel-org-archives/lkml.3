Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754541AbaDXKaz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 06:30:55 -0400
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:44896 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752988AbaDXKav (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 06:30:51 -0400
Date: Thu, 24 Apr 2014 11:30:59 +0100
From: Morten Rasmussen <morten.rasmussen@arm.com>
To: Jason Low <jason.low2@hp.com>
Cc: "mingo@kernel.org" <mingo@kernel.org>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "daniel.lezcano@linaro.org" <daniel.lezcano@linaro.org>,
        "alex.shi@linaro.org" <alex.shi@linaro.org>,
        "preeti@linux.vnet.ibm.com" <preeti@linux.vnet.ibm.com>,
        "efault@gmx.de" <efault@gmx.de>,
        "vincent.guittot@linaro.org" <vincent.guittot@linaro.org>,
        "aswin@hp.com" <aswin@hp.com>,
        "chegu_vinod@hp.com" <chegu_vinod@hp.com>
Subject: Re: [PATCH 3/3] sched, fair: Stop searching for tasks in newidle
 balance if there are runnable tasks
Message-ID: <20140424103059.GL2500@e103034-lin>
References: <1398303035-18255-1-git-send-email-jason.low2@hp.com>
 <1398303035-18255-4-git-send-email-jason.low2@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1398303035-18255-4-git-send-email-jason.low2@hp.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 24, 2014 at 02:30:35AM +0100, Jason Low wrote:
> @@ -6704,7 +6703,12 @@ static int idle_balance(struct rq *this_rq)
>  		interval = msecs_to_jiffies(sd->balance_interval);
>  		if (time_after(next_balance, sd->last_balance + interval))
>  			next_balance = sd->last_balance + interval;
> -		if (pulled_task)
> +
> +		/*
> +		 * Stop searching for tasks to pull if there are
> +		 * now runnable tasks on this rq.
> +		 */
> +		if (pulled_task || this_rq->nr_running > 0)

Should this be cfs tasks instead?

+		if (pulled_task || this_rq->cfs.h_nr_running > 0)

3.15-rc2 commit 35805ff8f4fc535ac85330170d3c56829c87c677 seems to
indicate that using rq->nr_running may lead to trouble.

The other two patches look good to me.

Morten
