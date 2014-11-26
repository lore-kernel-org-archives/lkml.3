Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753317AbaKZPNW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 10:13:22 -0500
Received: from mail-la0-f53.google.com ([209.85.215.53]:46257 "EHLO
	mail-la0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751565AbaKZPNU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 10:13:20 -0500
Date: Wed, 26 Nov 2014 16:13:16 +0100
From: Johan Hovold <johan@kernel.org>
To: Russell King <linux@arm.linux.org.uk>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Felipe Balbi <balbi@ti.com>, Johan Hovold <johan@kernel.org>
Subject: Re: [PATCH] ARM: remove redundant irq disable at halt and restart
Message-ID: <20141126151316.GE24767@localhost>
References: <1414177592-14547-1-git-send-email-johan@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1414177592-14547-1-git-send-email-johan@kernel.org>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 24, 2014 at 09:06:32PM +0200, Johan Hovold wrote:
> Remove redundant local_irq_disable() at machine halt and restart.
> 
> Since commit 44424c34049f ("ARM: 7803/1: Fix deadlock scenario with
> smp_send_stop()") interrupts are disabled before stopping secondary
> CPUs.
> 
> Signed-off-by: Johan Hovold <johan@kernel.org>

Russell, have you had a chance to look at this clean up?

Thanks,
Johan

> ---
>  arch/arm/kernel/process.c | 2 --
>  1 file changed, 2 deletions(-)
> 
> diff --git a/arch/arm/kernel/process.c b/arch/arm/kernel/process.c
> index a35f6ebbd2c2..5663ab57cf07 100644
> --- a/arch/arm/kernel/process.c
> +++ b/arch/arm/kernel/process.c
> @@ -195,7 +195,6 @@ void machine_halt(void)
>  	local_irq_disable();
>  	smp_send_stop();
>  
> -	local_irq_disable();
>  	while (1);
>  }
>  
> @@ -237,7 +236,6 @@ void machine_restart(char *cmd)
>  
>  	/* Whoops - the platform was unable to reboot. Tell the user! */
>  	printk("Reboot failed -- System halted\n");
> -	local_irq_disable();
>  	while (1);
>  }
