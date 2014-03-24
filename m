Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751164AbaCXAY7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2014 20:24:59 -0400
Received: from mail-pd0-f182.google.com ([209.85.192.182]:54915 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750855AbaCXAY5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2014 20:24:57 -0400
Date: Sun, 23 Mar 2014 17:24:54 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Julia Lawall <Julia.Lawall@lip6.fr>,
        Andrew Morton <akpm@linux-foundation.org>,
        input <linux-input@vger.kernel.org>
Subject: Re: [patch 16/16] input: serio: hp_sdc: Use del_timer_sync() in exit
 path
Message-ID: <20140324002454.GA5581@core.coreip.homeip.net>
References: <20140323150557.288925975@linutronix.de>
 <20140323150754.381232240@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140323150754.381232240@linutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 23, 2014 at 03:09:33PM -0000, Thomas Gleixner wrote:
> Make sure that no callback is running before we teardown the module.
> 

Applied, thank you Thomas.

> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
> Cc: input <linux-input@vger.kernel.org>
> ---
>  drivers/input/serio/hp_sdc.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> Index: tip/drivers/input/serio/hp_sdc.c
> ===================================================================
> --- tip.orig/drivers/input/serio/hp_sdc.c
> +++ tip/drivers/input/serio/hp_sdc.c
> @@ -984,7 +984,7 @@ static void hp_sdc_exit(void)
>  	free_irq(hp_sdc.irq, &hp_sdc);
>  	write_unlock_irq(&hp_sdc.lock);
>  
> -	del_timer(&hp_sdc.kicker);
> +	del_timer_sync(&hp_sdc.kicker);
>  
>  	tasklet_kill(&hp_sdc.task);
>  
> 
> 

-- 
Dmitry
