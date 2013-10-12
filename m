Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754127Ab3JLAGJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 20:06:09 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:49498 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752071Ab3JLAGG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 20:06:06 -0400
Date: Fri, 11 Oct 2013 17:06:05 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Matthias Beyer <mail@beyermatthias.de>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/6] drivers: usb: core: devio.c: Coding style fixes
Message-ID: <20131012000605.GA26571@kroah.com>
References: <1381441292-6145-1-git-send-email-mail@beyermatthias.de>
 <1381441292-6145-5-git-send-email-mail@beyermatthias.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1381441292-6145-5-git-send-email-mail@beyermatthias.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 10, 2013 at 11:41:30PM +0200, Matthias Beyer wrote:
> @@ -1838,9 +1838,10 @@ static int proc_ioctl(struct dev_state *ps, struct usbdevfs_ioctl *ctl)
>  		return -ENODEV;
>  	}
>  
> -	if (ps->dev->state != USB_STATE_CONFIGURED)
> +	if (ps->dev->state != USB_STATE_CONFIGURED) {
>  		retval = -EHOSTUNREACH;
> -	else if (!(intf = usb_ifnum_to_if(ps->dev, ctl->ifno)))
> +	}
> +	else if (!(intf = usb_ifnum_to_if(ps->dev, ctl->ifno))) {
>  		retval = -EINVAL;
>  	else switch (ctl->ioctl_code) {

I don't think you actually built the code after you made this change :(

drivers/usb/core/devio.c: In function ‘proc_ioctl’:
drivers/usb/core/devio.c:1844:2: error: expected ‘}’ before ‘else’

Please be more careful.

thanks,

greg k-h
