Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753976Ab3CHKY2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Mar 2013 05:24:28 -0500
Received: from smtp2.macqel.be ([194.78.208.39]:18225 "EHLO smtp2.macqel.be"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752505Ab3CHKY0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Mar 2013 05:24:26 -0500
Date: Fri, 8 Mar 2013 11:24:22 +0100
From: Philippe De Muyter <phdm@macqel.be>
To: Michael Neuling <mikey@neuling.org>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Subject: Re: 3.9-rc1 powerpc ptrace.c: 'brk.len' is used uninitialized
Message-ID: <20130308102422.GA25184@frolo.macqel>
References: <20130306060058.GA3106@frolo.macqel> <21084.1362607788@ale.ozlabs.ibm.com> <20130306223645.GA15484@frolo.macqel> <31862.1362611670@ale.ozlabs.ibm.com> <20130307095907.GA16489@frolo.macqel> <22285.1362695571@ale.ozlabs.ibm.com> <11606.1362697414@ale.ozlabs.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <11606.1362697414@ale.ozlabs.ibm.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 08, 2013 at 10:03:34AM +1100, Michael Neuling wrote:
> Michael Neuling <mikey@neuling.org> wrote:
> 
> diff --git a/arch/powerpc/kernel/ptrace.c b/arch/powerpc/kernel/ptrace.c
> index 245c1b6..8564515 100644
> --- a/arch/powerpc/kernel/ptrace.c
> +++ b/arch/powerpc/kernel/ptrace.c
> @@ -1428,6 +1428,7 @@ static long ppc_set_hwdebug(struct task_struct *child,
>  
>  	brk.address = bp_info->addr & ~7UL;
>  	brk.type = HW_BRK_TYPE_TRANSLATE;
> +	brk.len = 0;
>  	if (bp_info->trigger_type & PPC_BREAKPOINT_TRIGGER_READ)
>  		brk.type |= HW_BRK_TYPE_READ;
>  	if (bp_info->trigger_type & PPC_BREAKPOINT_TRIGGER_WRITE)

That's ok.  Thanks

Philippe
