Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753952Ab3BDRAw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 12:00:52 -0500
Received: from e9.ny.us.ibm.com ([32.97.182.139]:57407 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753654Ab3BDRAu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 12:00:50 -0500
Date: Mon, 4 Feb 2013 08:59:32 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Subject: Re: [PATCH] rcu: Have rcu torture test select trace_clock
Message-ID: <20130204165932.GW2632@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1359993141.5642.61.camel@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1359993141.5642.61.camel@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13020417-7182-0000-0000-000004EBF23D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 04, 2013 at 10:52:21AM -0500, Steven Rostedt wrote:
> The rcu torture test uses trace_clock, and requires that it be built
> into the kernel. If it is not, then we get the following build error:
> 
> ERROR: "trace_clock_local" [kernel/rcutorture.ko] undefined!
> 
> Reported-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

This would work, but would unnecessarily force trace_clock_local()
to be defined when RCU tracing is disabled.  So, would the alternative
patch I posted work for you?

							Thanx, Paul

> diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
> index 4057127..b542477 100644
> --- a/lib/Kconfig.debug
> +++ b/lib/Kconfig.debug
> @@ -942,6 +942,7 @@ config SPARSE_RCU_POINTER
>  config RCU_TORTURE_TEST
>  	tristate "torture tests for RCU"
>  	depends on DEBUG_KERNEL
> +	select TRACE_CLOCK
>  	default n
>  	help
>  	  This option provides a kernel module that runs torture tests
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

