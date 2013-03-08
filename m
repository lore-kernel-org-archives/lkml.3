Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933757Ab3CHJM0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Mar 2013 04:12:26 -0500
Received: from smtp1.telegraaf.nl ([217.196.45.193]:37619 "EHLO
	smtp1.telegraaf.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933331Ab3CHJMY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Mar 2013 04:12:24 -0500
X-Greylist: delayed 560 seconds by postgrey-1.27 at vger.kernel.org; Fri, 08 Mar 2013 04:12:24 EST
Date: Fri, 8 Mar 2013 10:03:01 +0100
From: Ard van Breemen <ard@telegraafnet.nl>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] init: Scream bloody murder if interrupts are enabled too
 early
Message-ID: <20130308090300.GM1585@telegraafnet.nl>
References: <1362694743.31874.66.camel@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1362694743.31874.66.camel@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, Mar 07, 2013 at 05:19:03PM -0500, Steven Rostedt wrote:
> diff --git a/init/main.c b/init/main.c
> index 63534a1..f0fe0a5 100644
> --- a/init/main.c
> +++ b/init/main.c
> @@ -539,7 +539,7 @@ asmlinkage void __init start_kernel(void)
>  	 * fragile until we cpu_idle() for the first time.
>  	 */
>  	preempt_disable();
> -	if (!irqs_disabled()) {
> +	if (WARN_ON(!irqs_disabled())) {
>  		printk(KERN_WARNING "start_kernel(): bug: interrupts were "
>  				"enabled *very* early, fixing it\n");
>  		local_irq_disable();
> 

The original code was a few versions before the WARN macros.
I think it's better to just change the printk to something like:
WARN(1,"interrupts were enabled *very* early, fixing it\n")

This will print the cause of the warning and then dump stack,
instead of having an unrelated message under the stackdump.

But: IANAM(acro)E(xpert), the real incantation might be
different.
But you are absolutely right that we should scream and shout.
This time in a way that's more in line with the others.

Regards,
Ard van Breemen.

