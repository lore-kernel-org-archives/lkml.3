Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754193AbbAYQPm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2015 11:15:42 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:54755 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752869AbbAYQPi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2015 11:15:38 -0500
Date: Sun, 25 Jan 2015 19:57:55 +0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Heba Aamer <heba93aamer@gmail.com>
Cc: devel@driverdev.osuosl.org, florian.c.schilhabel@googlemail.com,
        thomas@grouk.net, tapaswenipathak@gmail.com,
        rickard_strandqvist@spectrumdigital.se, linux-kernel@vger.kernel.org,
        sudipm.mukherjee@gmail.com, Larry.Finger@lwfinger.net
Subject: Re: [PATCH] staging: rtl8712: fix Prefer [subsystem eg:
 netdev]_info([subsystem]dev, ... then dev_info(dev, ... then pr_info(...  to
 printk(KERN_INFO ...
Message-ID: <20150125115755.GA1369@kroah.com>
References: <20150124202053.GA1641@mohammed-Inspiron-3537>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150124202053.GA1641@mohammed-Inspiron-3537>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 24, 2015 at 10:20:53PM +0200, Heba Aamer wrote:
> This patch fixes the following checkpatch.pl warning:
> fix Prefer [subsystem eg: netdev]_info([subsystem]dev, ... then
> dev_info(dev, ... then pr_info(...  to printk(KERN_INFO ...
> 
> netdev_info was used since it is a network subsystem
> 
> Signed-off-by: Heba Aamer <heba93aamer@gmail.com>
> ---
>  drivers/staging/rtl8712/usb_intf.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/staging/rtl8712/usb_intf.c b/drivers/staging/rtl8712/usb_intf.c
> index 7d0d171..7748a75 100644
> --- a/drivers/staging/rtl8712/usb_intf.c
> +++ b/drivers/staging/rtl8712/usb_intf.c
> @@ -366,7 +366,7 @@ static int r871xu_drv_init(struct usb_interface *pusb_intf,
>  	struct net_device *pnetdev;
>  	struct usb_device *udev;
>  
> -	printk(KERN_INFO "r8712u: Staging version\n");
> +	netdev_info(pnetdev, "r8712u: Staging version\n");
>  	/* In this probe function, O.S. will provide the usb interface pointer
>  	 * to driver. We have to increase the reference count of the usb device
>  	 * structure by using the usb_get_dev function.

Please don't send patches that you do not at least test-build, it's a
bit rude and wastes people's time.

Oh, and also ensure that your patch is correct, hint, this one does not
work at all :(

greg k-h
