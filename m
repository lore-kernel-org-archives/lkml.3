Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757414Ab3A1OoO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 09:44:14 -0500
Received: from mail.kernel.org ([198.145.19.201]:58731 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756969Ab3A1OoL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 09:44:11 -0500
Date: Mon, 28 Jan 2013 06:45:54 -0800
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Joe Millenbach <jmillenbach@gmail.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Felipe Balbi <balbi@ti.com>
Subject: Re: linux-next: manual merge of the usb tree with the tty tree
Message-ID: <20130128144554.GB2997@kroah.com>
References: <20130128211307.a235b6793587fea5e1fc5074@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130128211307.a235b6793587fea5e1fc5074@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 28, 2013 at 09:13:07PM +1100, Stephen Rothwell wrote:
> Hi Greg,
> 
> Today's linux-next merge of the usb tree got a conflict in
> drivers/usb/gadget/Kconfig between commit 4f73bc4dd3e8 ("tty: Added a
> CONFIG_TTY option to allow removal of TTY") from the tty tree and commit
> 3249ca22c088 ("usb: gadget: u_serial: convert into a module") from the
> usb tree.
> 
> I fixed it up (see below) and can carry the fix as necessary (no action
> is required).
> 
> -- 
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au
> 
> diff --cc drivers/usb/gadget/Kconfig
> index a1bd951,6665d25..0000000
> --- a/drivers/usb/gadget/Kconfig
> +++ b/drivers/usb/gadget/Kconfig
> @@@ -750,7 -760,8 +760,9 @@@ config USB_GADGET_TARGE
>   
>   config USB_G_SERIAL
>   	tristate "Serial Gadget (with CDC ACM and CDC OBEX support)"
>  +	depends on TTY
> + 	select USB_U_SERIAL
> + 	select USB_F_ACM

Looks good, thanks.

greg k-h
