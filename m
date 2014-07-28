Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752823AbaG1NgH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 09:36:07 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:56408 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752703AbaG1NgD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 09:36:03 -0400
Date: Mon, 28 Jul 2014 15:35:45 +0200
From: Robert Richter <rric@kernel.org>
To: "Chen, Gong" <gong.chen@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, tglx@linutronix.de,
        paulus@samba.org, benh@kernel.crashing.org, tony.luck@intel.com,
        hpa@zytor.com, jkosina@suse.cz, rafael.j.wysocki@intel.com,
        bp@alien8.de, linux@arm.linux.org.uk, ralf@linux-mips.org,
        schwidefsky@de.ibm.com, davem@davemloft.net, viro@zeniv.linux.org.uk,
        fweisbec@gmail.com, cl@linux.com, akpm@linux-foundation.org,
        axboe@kernel.dk, JBottomley@parallels.com, neilb@suse.de,
        christoffer.dall@linaro.org, rostedt@goodmis.org,
        gregkh@linuxfoundation.org, mhocko@suse.cz, david@fromorbit.com
Subject: Re: [RFC PATCH v1 65/70] oprofile, timer_int: _FROZEN Cleanup
Message-ID: <20140728133545.GW4703@rric.localhost>
References: <1406080786-3938-1-git-send-email-gong.chen@linux.intel.com>
 <1406080786-3938-66-git-send-email-gong.chen@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1406080786-3938-66-git-send-email-gong.chen@linux.intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22.07.14 21:59:41, Chen, Gong wrote:
> Remove XXX_FROZEN state from oprofile/timer_int.
> 
> Signed-off-by: Chen, Gong <gong.chen@linux.intel.com>

Acked-by: Robert Richter <rric@kernel.org>

> ---
>  drivers/oprofile/timer_int.c | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
> 
> diff --git a/drivers/oprofile/timer_int.c b/drivers/oprofile/timer_int.c
> index 61be1d9..ab5a0a9 100644
> --- a/drivers/oprofile/timer_int.c
> +++ b/drivers/oprofile/timer_int.c
> @@ -79,14 +79,12 @@ static int oprofile_cpu_notify(struct notifier_block *self,
>  {
>  	long cpu = (long) hcpu;
>  
> -	switch (action) {
> +	switch (action & ~CPU_TASKS_FROZEN) {
>  	case CPU_ONLINE:
> -	case CPU_ONLINE_FROZEN:
>  		smp_call_function_single(cpu, __oprofile_hrtimer_start,
>  					 NULL, 1);
>  		break;
>  	case CPU_DEAD:
> -	case CPU_DEAD_FROZEN:
>  		__oprofile_hrtimer_stop(cpu);
>  		break;
>  	}
> -- 
> 2.0.0.rc2
> 
