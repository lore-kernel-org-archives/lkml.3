Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752176Ab3HTELA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 00:11:00 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:41611 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751903Ab3HTEK7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 00:10:59 -0400
Date: Mon, 19 Aug 2013 21:10:54 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Chen Gang <gang.chen@asianux.com>
Cc: dipankar@in.ibm.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] kernel/rcutree.c: deem to be lazy if there are no
 callbacks.
Message-ID: <20130820041054.GX29406@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <5212E76A.40903@asianux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5212E76A.40903@asianux.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13082004-5518-0000-0000-00001153CF1B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 20, 2013 at 11:50:02AM +0800, Chen Gang wrote:
> According to the comment above rcu_cpu_has_callbacks(): "If there are
> no callbacks, all of them are deemed to be lazy".
> 
> So when both 'hc' and 'al' are false, '*all_lazy' should be true, not
> false.

If there are no callbacks, what must the value of "al" be at this
point in the code?  Given this, what is the effect of your patch?

							Thanx, Paul

> Signed-off-by: Chen Gang <gang.chen@asianux.com>
> ---
>  kernel/rcutree.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/kernel/rcutree.c b/kernel/rcutree.c
> index 5b53a89..9ee9565 100644
> --- a/kernel/rcutree.c
> +++ b/kernel/rcutree.c
> @@ -2725,7 +2725,7 @@ static int rcu_cpu_has_callbacks(int cpu, bool *all_lazy)
>  			hc = true;
>  	}
>  	if (all_lazy)
> -		*all_lazy = al;
> +		*all_lazy = !hc ? true : al;
>  	return hc;
>  }
> 
> -- 
> 1.7.7.6
> 

