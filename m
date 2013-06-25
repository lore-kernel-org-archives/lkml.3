Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752803Ab3FYKv1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 06:51:27 -0400
Received: from anubis.se.axis.com ([195.60.68.12]:46515 "EHLO
	anubis.se.axis.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752536Ab3FYKv0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 06:51:26 -0400
X-Greylist: delayed 524 seconds by postgrey-1.27 at vger.kernel.org; Tue, 25 Jun 2013 06:51:25 EDT
Date: Tue, 25 Jun 2013 12:42:37 +0200
From: Jesper Nilsson <jesper.nilsson@axis.com>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mikael Starvik <starvik@axis.com>, Jesper Nilsson <jespern@axis.com>,
        linux-cris-kernel <linux-cris-kernel@axis.com>
Subject: Re: [PATCH 16/32] cris: delete __cpuinit usage from all cris files
Message-ID: <20130625104236.GA23735@axis.com>
References: <1372102237-8757-1-git-send-email-paul.gortmaker@windriver.com>
 <1372102237-8757-17-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1372102237-8757-17-git-send-email-paul.gortmaker@windriver.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 24, 2013 at 09:30:21PM +0200, Paul Gortmaker wrote:
> The __cpuinit type of throwaway sections might have made sense
> some time ago when RAM was more constrained, but now the savings
> do not offset the cost and complications.  For example, the fix in
> commit 5e427ec2d0 ("x86: Fix bit corruption at CPU resume time")
> is a good example of the nasty type of bugs that can be created
> with improper use of the various __init prefixes.
> 
> After a discussion on LKML[1] it was decided that cpuinit should go
> the way of devinit and be phased out.  Once all the users are gone,
> we can then finally remove the macros themselves from linux/init.h.
> 
> Note that some harmless section mismatch warnings may result, since
> notify_cpu_starting() and cpu_up() are arch independent (kernel/cpu.c)
> are flagged as __cpuinit  -- so if we remove the __cpuinit from
> arch specific callers, we will also get section mismatch warnings.
> As an intermediate step, we intend to turn the linux/init.h cpuinit
> content into no-ops as early as possible, since that will get rid
> of these warnings.  In any case, they are temporary and harmless.
> 
> This removes all the arch/cris uses of the __cpuinit macros from
> all C files.  Currently cris does not have any __CPUINIT used in
> assembly files.
> 
> [1] https://lkml.org/lkml/2013/5/20/589
> 
> Cc: Mikael Starvik <starvik@axis.com>

Acked-by: Jesper Nilsson <jesper.nilsson@axis.com>

> Cc: linux-cris-kernel@axis.com
> Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
> ---
> 
> [This commit is part of the __cpuinit removal work.  If you don't see
>  any problems with it, then you don't have to do anything ; it will be
>  submitted with all the rest of the __cpuinit removal work.  On the
>  other hand, if you want to carry this patch in with your other pending
>  changes so as to handle conflicts with other pending work yourself, then
>  that is fine too, as the commits can largely be treated independently.
>  For more information, please see: https://lkml.org/lkml/2013/6/20/513 ]
> 
>  arch/cris/arch-v32/kernel/smp.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/cris/arch-v32/kernel/smp.c b/arch/cris/arch-v32/kernel/smp.c
> index cdd1202..fe8e603 100644
> --- a/arch/cris/arch-v32/kernel/smp.c
> +++ b/arch/cris/arch-v32/kernel/smp.c
> @@ -197,7 +197,7 @@ int setup_profiling_timer(unsigned int multiplier)
>   */
>  unsigned long cache_decay_ticks = 1;
>  
> -int __cpuinit __cpu_up(unsigned int cpu, struct task_struct *tidle)
> +int __cpu_up(unsigned int cpu, struct task_struct *tidle)
>  {
>  	smp_boot_one_cpu(cpu, tidle);
>  	return cpu_online(cpu) ? 0 : -ENOSYS;
> -- 
> 1.8.1.2

/^JN - Jesper Nilsson
-- 
               Jesper Nilsson -- jesper.nilsson@axis.com
