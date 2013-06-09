Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753683Ab3FIJr5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Jun 2013 05:47:57 -0400
Received: from ozlabs.org ([203.10.76.45]:33494 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750889Ab3FIJrz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Jun 2013 05:47:55 -0400
From: Michael Neuling <mikey@neuling.org>
To: Guenter Roeck <linux@roeck-us.net>
cc: Greg KH <gregkh@linuxfoundation.org>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org, lwn@lwn.net,
        Jiri Slaby <jslaby@suse.cz>, Paul Mackerras <paulus@samba.org>,
        linuxppc-dev@lists.ozlabs.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: Linux 3.9.5 [patch to fix powerpc build error attached]
In-reply-to: <20130608143055.GA21207@roeck-us.net>
References: <20130607195816.GA28479@kroah.com> <20130608143055.GA21207@roeck-us.net>
Comments: In-reply-to Guenter Roeck <linux@roeck-us.net>
   message dated "Sat, 08 Jun 2013 07:30:55 -0700."
X-Mailer: MH-E 8.2; nmh 1.5; GNU Emacs 23.4.1
Date: Sun, 09 Jun 2013 19:47:54 +1000
Message-ID: <26857.1370771274@ale.ozlabs.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Guenter Roeck <linux@roeck-us.net> wrote:

> On Fri, Jun 07, 2013 at 12:58:16PM -0700, Greg KH wrote:
> > I'm announcing the release of the 3.9.5 kernel.
> > 
> > All users of the 3.9 kernel series must upgrade.
> > 
> > The updated 3.9.y git tree can be found at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-3.9.y
> > and can be browsed at the normal kernel.org git web browser:
> > 	http://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary
> > 
> Powerpc build is fixed with the following patch.
> 
> From 8ce3edac0a86f103bd1037110662d5d80a42dd5b Mon Sep 17 00:00:00 2001
> From: Guenter Roeck <linux@roeck-us.net>
> Date: Sat, 8 Jun 2013 07:23:47 -0700
> Subject: [PATCH] powerpc: Fix build error in stable/3.9
> 
> Commit e71c42189 (powerpc/tm: Abort on emulation and alignment faults)
> introduced a powerpc build error in 3.9.5.

ACK.

Looks like ba12eed (powerpc: Exception hooks for context tracking
subsyste) was the cause (but not a prerequisite) that was introduced
post 3.9.

Thanks,
Mikey

> 
> Signed-off-by: Guenter Roeck <linux@roeck-us.net>
> ---
> No upstream commit. Compile tested only.
> 
>  arch/powerpc/kernel/traps.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/powerpc/kernel/traps.c b/arch/powerpc/kernel/traps.c
> index 1c22b2d..29857c6 100644
> --- a/arch/powerpc/kernel/traps.c
> +++ b/arch/powerpc/kernel/traps.c
> @@ -1151,7 +1151,7 @@ void alignment_exception(struct pt_regs *regs)
>  		local_irq_enable();
>  
>  	if (tm_abort_check(regs, TM_CAUSE_ALIGNMENT | TM_CAUSE_PERSISTENT))
> -		goto bail;
> +		return;
>  
>  	/* we don't implement logging of alignment exceptions */
>  	if (!(current->thread.align_ctl & PR_UNALIGN_SIGBUS))
> -- 
> 1.7.9.7
> 
