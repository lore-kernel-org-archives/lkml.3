Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753031AbaFMURI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 16:17:08 -0400
Received: from mga02.intel.com ([134.134.136.20]:32344 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751074AbaFMURH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 16:17:07 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,473,1400050800"; 
   d="scan'208";a="528258168"
Subject: Re: [PATCH] sched: Fast idling of CPU when system is partially
 loaded
From: Tim Chen <tim.c.chen@linux.intel.com>
To: Jason Low <jason.low2@hp.com>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Andi Kleen <andi@firstfloor.org>,
        Michel Lespinasse <walken@google.com>, Rik van Riel <riel@redhat.com>,
        Peter Hurley <peter@hurleysoftware.com>,
        Davidlohr Bueson <davidlohr@hp.com>, linux-kernel@vger.kernel.org
In-Reply-To: <1402687127.2431.6.camel@j-VirtualBox>
References: <1402608359.2970.548.camel@schen9-DESK>
	 <1402639311.9617.84.camel@j-VirtualBox>
	 <1402676882.2970.564.camel@schen9-DESK>
	 <1402687127.2431.6.camel@j-VirtualBox>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 13 Jun 2014 13:17:04 -0700
Message-ID: <1402690624.2970.567.camel@schen9-DESK>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-06-13 at 12:18 -0700, Jason Low wrote:

> 
> I see. In that case, if a CPU is going idle, it still needs to call
> idle_balance() to update rq->idle_stamp and rq->next_balance (even if we
> skip calling the expensive load_balance).
> 
> What do you think about moving the overload check to the top of
> idle_balance():
> 
>         this_rq->idle_stamp = rq_clock(this_rq);
>  
> -       if (this_rq->avg_idle < sysctl_sched_migration_cost) {
> +       if (this_rq->avg_idle < sysctl_sched_migration_cost ||
> +           !this_rq->rd->overload) {
>                 rcu_read_lock();
>                 sd = rcu_dereference_check_sched_domain(this_rq->sd);
>                 if (sd)
> 
> 

That's a good point.  I think moving the check as you suggested
is appropriate.  I'll update the code in my next version.

Tim

