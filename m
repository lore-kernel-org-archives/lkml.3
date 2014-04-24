Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756610AbaDXMFe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 08:05:34 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:41898 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753473AbaDXMEi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 08:04:38 -0400
Date: Thu, 24 Apr 2014 14:04:15 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Preeti U Murthy <preeti@linux.vnet.ibm.com>
Cc: Jason Low <jason.low2@hp.com>, mingo@kernel.org,
        linux-kernel@vger.kernel.org, daniel.lezcano@linaro.org,
        alex.shi@linaro.org, efault@gmx.de, vincent.guittot@linaro.org,
        morten.rasmussen@arm.com, aswin@hp.com, chegu_vinod@hp.com
Subject: Re: [PATCH 1/3] sched, balancing: Update rq->max_idle_balance_cost
 whenever newidle balance is attempted
Message-ID: <20140424120415.GS11096@twins.programming.kicks-ass.net>
References: <1398303035-18255-1-git-send-email-jason.low2@hp.com>
 <1398303035-18255-2-git-send-email-jason.low2@hp.com>
 <5358E417.8090503@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5358E417.8090503@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 24, 2014 at 03:44:47PM +0530, Preeti U Murthy wrote:
> What about the update of next_balance field? See the code snippet below.
> This will also be skipped as a consequence of the commit e5fc6611 right?
> 
> 	   if (pulled_task || time_after(jiffies, this_rq->next_balance)) {
>                  /*
>                   * We are going idle. next_balance may be set based on
>                   * a busy processor. So reset next_balance.
>                   */
>                  this_rq->next_balance = next_balance;
>          }
> 
> Also the comment in the above snippet does not look right to me.
> It says "we are going idle" but the condition checks for pulled_task.

Yeah, that's odd indeed. Ingo did that back in dd41f596cda0d, I suspect
its an error, but..

So I think that should become !pulled_task || time_after().
