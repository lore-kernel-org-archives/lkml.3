Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759648Ab3FCST4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 14:19:56 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:15670 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758041Ab3FCSTy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 14:19:54 -0400
X-Authority-Analysis: v=2.0 cv=H8VZMpki c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=BFw3X0KoKuAA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=JuewwEqb0pcA:10 a=JAllzPzdEhjodErTgQYA:9 a=QEXdDO2ut3YA:10 a=jeBq3FmKZ4MA:10 a=NKw83YGDehwNsLGi:21 a=BU5RWUBgwgG95DyC:21 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1370283591.26799.95.camel@gandalf.local.home>
Subject: Re: [RFC][PATCH] rcu: Hotplug and PROVE_RCU_DELAY not playing well
 together
From: Steven Rostedt <rostedt@goodmis.org>
To: paulmck@linux.vnet.ibm.com
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Date: Mon, 03 Jun 2013 14:19:51 -0400
In-Reply-To: <20130602141814.GA24198@linux.vnet.ibm.com>
References: <1370035669.26799.85.camel@gandalf.local.home>
	 <20130602025425.GE3957@linux.vnet.ibm.com>
	 <20130602141814.GA24198@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2013-06-02 at 07:18 -0700, Paul E. McKenney wrote:

> ------------------------------------------------------------------------
> 
> diff --git a/kernel/rcutree.c b/kernel/rcutree.c
> index d12470e..9a08bdc 100644
> --- a/kernel/rcutree.c
> +++ b/kernel/rcutree.c
> @@ -1320,9 +1320,9 @@ static int rcu_gp_init(struct rcu_state *rsp)
>  					    rnp->grphi, rnp->qsmask);
>  		raw_spin_unlock_irq(&rnp->lock);
>  #ifdef CONFIG_PROVE_RCU_DELAY
> -		if ((prandom_u32() % (rcu_num_nodes * 8)) == 0 &&
> +		if ((prandom_u32() % (rcu_num_nodes + 1)) == 0 &&
>  		    system_state == SYSTEM_RUNNING)
> -			schedule_timeout_uninterruptible(2);
> +			udelay(200);
>  #endif /* #ifdef CONFIG_PROVE_RCU_DELAY */
>  		cond_resched();
>  	}

I ran this for a bit. Where it usually crashes in less than a minute,
this ran for over 10 minutes without issue.

Tested-by: Steven Rostedt <rostedt@goodmis.org>

-- Steve


