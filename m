Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751983Ab3KJStq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Nov 2013 13:49:46 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:41739 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751729Ab3KJStk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Nov 2013 13:49:40 -0500
Date: Sun, 10 Nov 2013 10:52:10 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Michal Nazarewicz <mpn@google.com>
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: go7007: fix use of uninitialised pointer
Message-ID: <20131110185210.GA9633@kroah.com>
References: <1384108677-23476-1-git-send-email-mpn@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1384108677-23476-1-git-send-email-mpn@google.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 10, 2013 at 07:37:57PM +0100, Michal Nazarewicz wrote:
> From: Michal Nazarewicz <mina86@mina86.com>
> 
> The go variable is declade without initialisation and invocation of
> dev_dbg immediatelly tries to dereference it.
> ---
>  drivers/staging/media/go7007/go7007-usb.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/staging/media/go7007/go7007-usb.c b/drivers/staging/media/go7007/go7007-usb.c
> index 58684da..457ab63 100644
> --- a/drivers/staging/media/go7007/go7007-usb.c
> +++ b/drivers/staging/media/go7007/go7007-usb.c
> @@ -1057,7 +1057,7 @@ static int go7007_usb_probe(struct usb_interface *intf,
>  	char *name;
>  	int video_pipe, i, v_urb_len;
>  
> -	dev_dbg(go->dev, "probing new GO7007 USB board\n");
> +	pr_debug("probing new GO7007 USB board\n");

Please either delete this entirely, or use the struct device in the
usb_interface pointer.

A driver should never have a "raw" pr_* call.

thanks,

greg k-h
