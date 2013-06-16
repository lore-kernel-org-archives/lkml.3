Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755448Ab3FPSLt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Jun 2013 14:11:49 -0400
Received: from mail-pb0-f43.google.com ([209.85.160.43]:33110 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752242Ab3FPSLs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Jun 2013 14:11:48 -0400
Date: Sun, 16 Jun 2013 11:11:46 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Rusty Russell <rusty@rustcorp.com.au>
cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 9/9] mm/oom_kill: remove weird use of
 ERR_PTR()/PTR_ERR().
In-Reply-To: <1371357768-4968-9-git-send-email-rusty@rustcorp.com.au>
Message-ID: <alpine.DEB.2.02.1306161111180.22688@chino.kir.corp.google.com>
References: <87ehc2rczo.fsf@rustcorp.com.au> <1371357768-4968-1-git-send-email-rusty@rustcorp.com.au> <1371357768-4968-9-git-send-email-rusty@rustcorp.com.au>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 16 Jun 2013, Rusty Russell wrote:

> diff --git a/mm/oom_kill.c b/mm/oom_kill.c
> index 79e451a..f9b9cd7 100644
> --- a/mm/oom_kill.c
> +++ b/mm/oom_kill.c
> @@ -288,7 +288,7 @@ enum oom_scan_t oom_scan_process_thread(struct task_struct *task,
>  
>  /*
>   * Simple selection loop. We chose the process with the highest
> - * number of 'points'.
> + * number of 'points'.  Returns -1 on scan abort.
>   *
>   * (not docbooked, we don't want this one cluttering up the manual)
>   */
> @@ -314,7 +314,7 @@ static struct task_struct *select_bad_process(unsigned int *ppoints,
>  			continue;
>  		case OOM_SCAN_ABORT:
>  			rcu_read_unlock();
> -			return ERR_PTR(-1UL);
> +			return (void *)(-1UL);
>  		case OOM_SCAN_OK:
>  			break;
>  		};

Any reason it's not struct task_struct *?

> @@ -657,7 +657,7 @@ void out_of_memory(struct zonelist *zonelist, gfp_t gfp_mask,
>  		dump_header(NULL, gfp_mask, order, NULL, mpol_mask);
>  		panic("Out of memory and no killable processes...\n");
>  	}
> -	if (PTR_ERR(p) != -1UL) {
> +	if (p != (void *)-1UL) {
>  		oom_kill_process(p, gfp_mask, order, points, totalpages, NULL,
>  				 nodemask, "Out of memory");
>  		killed = 1;
