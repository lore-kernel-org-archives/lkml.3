Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934129Ab3JPUkS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 16:40:18 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:37255 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761779Ab3JPUkO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 16:40:14 -0400
Date: Wed, 16 Oct 2013 13:40:13 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Matthias Beyer <mail@beyermatthias.de>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 3/5] drivers: usb: core: devio.c: Braces around
 if-elseif-else
Message-ID: <20131016204013.GA6701@kroah.com>
References: <20131014181214.GB6023@kroah.com>
 <1381780000-23327-1-git-send-email-mail@beyermatthias.de>
 <1381780000-23327-4-git-send-email-mail@beyermatthias.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1381780000-23327-4-git-send-email-mail@beyermatthias.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 14, 2013 at 09:46:38PM +0200, Matthias Beyer wrote:
> This patch applies the rules for braces to the if-elseif-else statement
> in proc_ioctl().
> 
> As the kernel styleguide says: If there is at least one multiline block
> in a if-else branching, we should add braces around all blocks. This
> includes braces around the switch-statement on the else branch, which
> needs a reindent after adding the braces.
> 
> Signed-off-by: Matthias Beyer <mail@beyermatthias.de>
> ---
>  drivers/usb/core/devio.c | 10 ++++++----
>  1 file changed, 6 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/usb/core/devio.c b/drivers/usb/core/devio.c
> index d15aa51..dd8701b 100644
> --- a/drivers/usb/core/devio.c
> +++ b/drivers/usb/core/devio.c
> @@ -1222,7 +1222,7 @@ static int proc_do_submiturb(struct dev_state *ps, struct usbdevfs_urb *uurb,
>  		return -ENOENT;
>  
>  	u = 0;
> -	switch(uurb->type) {
> +	switch (uurb->type) {
>  	case USBDEVFS_URB_TYPE_CONTROL:
>  		if (!usb_endpoint_xfer_control(&ep->desc))
>  			return -EINVAL;
> @@ -1838,11 +1838,12 @@ static int proc_ioctl(struct dev_state *ps, struct usbdevfs_ioctl *ctl)
>  		return -ENODEV;
>  	}
>  
> -	if (ps->dev->state != USB_STATE_CONFIGURED)
> +	if (ps->dev->state != USB_STATE_CONFIGURED) {
>  		retval = -EHOSTUNREACH;
> -	else if (!(intf = usb_ifnum_to_if(ps->dev, ctl->ifno)))
> +	} else if (!(intf = usb_ifnum_to_if(ps->dev, ctl->ifno))) {
>  		retval = -EINVAL;
> -	else switch (ctl->ioctl_code) {
> +	} else {
> +	switch (ctl->ioctl_code) {
>  
>  	/* disconnect kernel driver from interface */
>  	case USBDEVFS_DISCONNECT:
> @@ -1874,6 +1875,7 @@ static int proc_ioctl(struct dev_state *ps, struct usbdevfs_ioctl *ctl)
>  				retval = -ENOTTY;
>  		}
>  	}
> +	}

Two braces in line like that should scream at you that something is
wrong with the indentation here.

I'd leave it alone for the switch statement, as it's not needed.

Actually this whole thing should be fine, it's correct, right?

thanks,

greg k-h
