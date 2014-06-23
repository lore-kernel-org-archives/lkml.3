Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752927AbaFWKHc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 06:07:32 -0400
Received: from casper.infradead.org ([85.118.1.10]:46770 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752326AbaFWKHb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 06:07:31 -0400
Date: Mon, 23 Jun 2014 12:07:24 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Kirill Tkhai <ktkhai@parallels.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        tkhai@yandex.ru, Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Mike Galbraith <umgwanakikbuti@gmail.com>,
        Konstantin Khorenko <khorenko@parallels.com>
Subject: Re: [PATCH 1/3] sched/fair: Disable runtime_enabled on dying rq
Message-ID: <20140623100724.GU19860@laptop.programming.kicks-ass.net>
References: <20140617130442.29933.54945.stgit@tkhai>
 <1403011450.27674.44.camel@tkhai>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1403011450.27674.44.camel@tkhai>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 17, 2014 at 05:24:10PM +0400, Kirill Tkhai wrote:
> @@ -3790,6 +3803,12 @@ static void __maybe_unused unthrottle_offline_cfs_rqs(struct rq *rq)
>  		cfs_rq->runtime_remaining = 1;
>  		if (cfs_rq_throttled(cfs_rq))
>  			unthrottle_cfs_rq(cfs_rq);
> +
> +		/*
> +		 * Offline rq is schedulable till cpu is completely disabled
> +		 * in take_cpu_down(), so we prevent new cfs throttling here.
> +		 */
> +		cfs_rq->runtime_enabled = 0;

Does it make sense to clear this before calling unthrottle_cfs_rq()?
Just to make sure they're in the right order..

>  	}
>  }
