Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756398Ab3IZKFV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 06:05:21 -0400
Received: from merlin.infradead.org ([205.233.59.134]:45926 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752238Ab3IZKFU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 06:05:20 -0400
Date: Thu, 26 Sep 2013 12:05:11 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Mike Galbraith <bitbucket@online.de>
Cc: Ingo Molnar <mingo@kernel.org>, Paul Turner <pjt@google.com>,
        Rik van Riel <riel@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH] sched: Avoid select_idle_sibling() for
 wake_affine(.sync=true)
Message-ID: <20130926100511.GJ26785@twins.programming.kicks-ass.net>
References: <20130925075341.GB3081@twins.programming.kicks-ass.net>
 <1380099377.8523.9.camel@marge.simpson.net>
 <20130926095812.GR3081@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130926095812.GR3081@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 26, 2013 at 11:58:12AM +0200, Peter Zijlstra wrote:
> @@ -3429,6 +3440,9 @@ select_task_rq_fair(struct task_struct *p, int sd_flag, int wake_flags)
>  	int want_affine = 0;
>  	int sync = wake_flags & WF_SYNC;
>  
> +	if (sync)
> +		p->se.last_sync_wakeup = sched_clock_cpu(cpu);
> +
>  	if (p->nr_cpus_allowed == 1)
>  		return prev_cpu;
>  

Oh, I suppose something like:

 if (sync && !p->se.last_sync_wakeup)
 	p->se.last_sync_wakeup = sched_clock_cpu(cpu);

is also a nice variation to try..
