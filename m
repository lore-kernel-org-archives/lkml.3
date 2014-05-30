Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934381AbaE3R0G (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 13:26:06 -0400
Received: from relay2.sgi.com ([192.48.180.65]:58599 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933239AbaE3R0D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 13:26:03 -0400
X-Greylist: delayed 651 seconds by postgrey-1.27 at vger.kernel.org; Fri, 30 May 2014 13:26:02 EDT
Date: Fri, 30 May 2014 12:15:07 -0500
From: Dimitri Sivanich <sivanich@sgi.com>
To: Manuel =?iso-8859-1?Q?Sch=F6lling?= <manuel.schoelling@gmx.de>
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH RESEND] sgi-gru: use time_before()
Message-ID: <20140530171507.GA85969@sgi.com>
References: <1401457259-17401-1-git-send-email-manuel.schoelling@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1401457259-17401-1-git-send-email-manuel.schoelling@gmx.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Acked-by: Dimitri Sivanich <sivanich@sgi.com>

On Fri, May 30, 2014 at 03:40:59PM +0200, Manuel Schölling wrote:
> To be future-proof and for better readability the time comparisons are
> modified to use time_before() instead of plain, error-prone math.
> 
> Signed-off-by: Manuel Schölling <manuel.schoelling@gmx.de>
> ---
>  drivers/misc/sgi-gru/grumain.c |    4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/misc/sgi-gru/grumain.c b/drivers/misc/sgi-gru/grumain.c
> index ae16c8c..1525870 100644
> --- a/drivers/misc/sgi-gru/grumain.c
> +++ b/drivers/misc/sgi-gru/grumain.c
> @@ -930,6 +930,7 @@ int gru_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
>  {
>  	struct gru_thread_state *gts;
>  	unsigned long paddr, vaddr;
> +	unsigned long expires;
>  
>  	vaddr = (unsigned long)vmf->virtual_address;
>  	gru_dbg(grudev, "vma %p, vaddr 0x%lx (0x%lx)\n",
> @@ -954,7 +955,8 @@ again:
>  			mutex_unlock(&gts->ts_ctxlock);
>  			set_current_state(TASK_INTERRUPTIBLE);
>  			schedule_timeout(GRU_ASSIGN_DELAY);  /* true hack ZZZ */
> -			if (gts->ts_steal_jiffies + GRU_STEAL_DELAY < jiffies)
> +			expires = gts->ts_steal_jiffies + GRU_STEAL_DELAY;
> +			if (time_before(expires, jiffies))
>  				gru_steal_context(gts);
>  			goto again;
>  		}
> -- 
> 1.7.10.4
