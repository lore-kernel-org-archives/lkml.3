Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759124AbaCTQB0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 12:01:26 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:58011 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758994AbaCTQBX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 12:01:23 -0400
Date: Thu, 20 Mar 2014 09:03:28 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Suresh Gupta <suresh.gupta@freescale.com>
Cc: balbi@ti.com, linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] USB: Gadget: fsl driver pullup fix
Message-ID: <20140320160328.GB18120@kroah.com>
References: <1395347238-22518-1-git-send-email-suresh.gupta@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1395347238-22518-1-git-send-email-suresh.gupta@freescale.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 21, 2014 at 01:57:18AM +0530, Suresh Gupta wrote:
> This fix the fsl usb gadget driver in a way that the usb device
> will be only "pulled up" on requests only when vbus is powered
> 
> Signed-off-by: Suresh Gupta <suresh.gupta@freescale.com>
> ---
> Changes from previous version:
> * Removed re-factored code, Will send another patch for re-factoring
>   duplicated code
> * Changed Description 
> 
>  drivers/usb/gadget/fsl_udc_core.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/drivers/usb/gadget/fsl_udc_core.c b/drivers/usb/gadget/fsl_udc_core.c
> index 35cb972..49d66779 100644
> --- a/drivers/usb/gadget/fsl_udc_core.c
> +++ b/drivers/usb/gadget/fsl_udc_core.c
> @@ -1219,6 +1219,10 @@ static int fsl_pullup(struct usb_gadget *gadget, int is_on)
>  	struct fsl_udc *udc;
>  
>  	udc = container_of(gadget, struct fsl_udc, gadget);
> +
> +	if(!udc->vbus_active)
> +		return -EOPNOTSUPP;

Always run your patches through scripts/checkpatch.pl so they don't get
rejected for silly things like the wrong coding style...
