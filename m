Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932125AbaD2NJb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 09:09:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:15240 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751167AbaD2NJ2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 09:09:28 -0400
Date: Tue, 29 Apr 2014 09:09:23 -0400
From: Don Zickus <dzickus@redhat.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Aaron Tomlin <atomlin@redhat.com>
Subject: Re: linux-next: build failure after merge of the akpm-current tree
Message-ID: <20140429130923.GA32375@redhat.com>
References: <20140429171321.69409c76a15ad2a97761585c@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140429171321.69409c76a15ad2a97761585c@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 29, 2014 at 05:13:21PM +1000, Stephen Rothwell wrote:
> Hi Andrew,
> 
> After merging the akpm tree, today's linux-next build (sparc64 defconfig)
> failed like this:
> 
> arch/sparc/kernel/process_64.c: In function 'arch_trigger_all_cpu_backtrace':
> arch/sparc/kernel/process_64.c:267:3: error: ISO C90 forbids mixed declarations and code [-Werror=declaration-after-statement]
> cc1: all warnings being treated as errors
> 
> Caused by commit dd0063a16aa1 ("nmi: provide the option to issue an NMI
> back trace to every cpu but current").
> 
> I have no idea why I did not see this yesterday.
> 
> I applied the following fix up patch:

I apologize for that.  The downsides of making changes without having a
cross compiler.  Thanks for the fixup!

Cheers,
Don

> 
> From: Stephen Rothwell <sfr@canb.auug.org.au>
> Date: Tue, 29 Apr 2014 17:10:00 +1000
> Subject: [PATCH] nmi-provide-the-option-to-issue-an-nmi-back-trace-to-every-cpu-but-current-fix
> 
> Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
> ---
>  arch/sparc/kernel/process_64.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/sparc/kernel/process_64.c b/arch/sparc/kernel/process_64.c
> index 65b405c36421..9975a6dbca0a 100644
> --- a/arch/sparc/kernel/process_64.c
> +++ b/arch/sparc/kernel/process_64.c
> @@ -261,10 +261,12 @@ void arch_trigger_all_cpu_backtrace(bool include_self)
>  	smp_fetch_global_regs();
>  
>  	for_each_online_cpu(cpu) {
> +		struct global_reg_snapshot *gp;
> +
>  		if (!include_self && cpu == this_cpu)
>  			continue;
>  
> -		struct global_reg_snapshot *gp = &global_cpu_snapshot[cpu].reg;
> +		gp = &global_cpu_snapshot[cpu].reg;
>  
>  		__global_reg_poll(gp);
>  
> -- 
> 2.0.0.rc0
> 
> -- 
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au


