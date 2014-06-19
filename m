Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932377AbaFSKop (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 06:44:45 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:62686 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755462AbaFSKon (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 06:44:43 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 99.127.230.128
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19+wOR074PaWab9/jJfferc
Date: Thu, 19 Jun 2014 03:44:42 -0700
From: Tony Lindgren <tony@atomide.com>
To: George Cherian <george.cherian@ti.com>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-omap@vger.kernel.org, gregkh@linuxfoundation.org, balbi@ti.com,
        zonque@gmail.com, b-liu@ti.com
Subject: Re: [PATCH v6 1/5] usb: musb: core: Handle Babble condition only in
 HOST mode
Message-ID: <20140619104441.GD29055@atomide.com>
References: <1401096012-6895-1-git-send-email-george.cherian@ti.com>
 <1401096012-6895-2-git-send-email-george.cherian@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1401096012-6895-2-git-send-email-george.cherian@ti.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* George Cherian <george.cherian@ti.com> [140526 02:25]:
> BABBLE and RESET share the same interrupt. The interrupt
> is considered to be RESET if MUSB is in peripheral mode and
> as a BABBLE if MUSB is in HOST mode.
> 
> Handle babble condition iff MUSB is in HOST mode.

Please get this into mainline kernel for v3.16-rc.

Fixes: ca88fc2ef0d7 (usb: musb: add a work_struct to recover from babble errors)

Tested-by: Tony Lindgren <tony@atomide.com>
 
> Signed-off-by: George Cherian <george.cherian@ti.com>
> ---
>  drivers/usb/musb/musb_core.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/usb/musb/musb_core.c b/drivers/usb/musb/musb_core.c
> index 3c6043c..0ad9551 100644
> --- a/drivers/usb/musb/musb_core.c
> +++ b/drivers/usb/musb/musb_core.c
> @@ -849,7 +849,7 @@ b_host:
>  	}
>  
>  	/* handle babble condition */
> -	if (int_usb & MUSB_INTR_BABBLE)
> +	if (int_usb & MUSB_INTR_BABBLE && is_host_active(musb))
>  		schedule_work(&musb->recover_work);
>  
>  #if 0
> -- 
> 1.8.3.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
