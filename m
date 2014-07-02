Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756832AbaGBRzp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 13:55:45 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:60845 "EHLO
	out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756635AbaGBRzn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 13:55:43 -0400
X-Sasl-enc: vOYghs+9h+8OSkgHwYE6DzpTNFuPyQ4CDlKE7KP6gefB 1404323742
Date: Wed, 2 Jul 2014 10:55:26 -0700
From: Greg KH <greg@kroah.com>
To: Stefan Klug <stefan.klug@baslerweb.com>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        stern@rowland.harvard.edu
Subject: Re: [PATCH][RFC] USB: zerocopy support for usbfs
Message-ID: <20140702175526.GA21063@kroah.com>
References: <53B42B14.7010303@baslerweb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53B42B14.7010303@baslerweb.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 02, 2014 at 05:53:56PM +0200, Stefan Klug wrote:
> Hi everybody,
> in short: The attached patch adds zerocopy support to the usbfs driver.
> I tested it on x86 and on a globalscale mirabox ARM board. Until now it
> works
> quite nice and I'd love to get some comments and feedback on the patch.

Very nice.

Minor non-technical issues here, your patch is corrupted (linewrapped
and tabs converted to spaces) and can't be applied at all.  Can you fix
your email client and try again?  Look at
Documentation/email_clients.txt for hints on how to do this.

> --- a/drivers/usb/core/devio.c
> +++ b/drivers/usb/core/devio.c
> @@ -4,6 +4,7 @@
>   *      devio.c  --  User space communication with USB devices.
>   *
>   *      Copyright (C) 1999-2000  Thomas Sailer (sailer@ife.ee.ethz.ch)
> + *      Copyright (C) 2014  Stefan Klug (stefan.klug@baslerweb.com)

According to legal advice given to me, this isn't needed / true, so can
you drop it?  Or, if you have different legal advice, might I ask for
what the legal justification is that this needs to be added?

>   *      This program is free software; you can redistribute it and/or
> modify
>   *      it under the terms of the GNU General Public License as published
> by
> @@ -30,6 +31,7 @@
>   *    04.01.2000   0.2   Turned into its own filesystem
>   *    30.09.2005   0.3   Fix user-triggerable oops in async URB delivery
>   *                 (CAN-2005-3055)
> + *    07.05.2014   0.4   Added zerocopy support

No need to do this, we use git now and that's where the changelog goes.
We should just delete this "fake changelog" entirely from this file.

thanks,

greg k-h
