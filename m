Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753330AbbAYOO2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2015 09:14:28 -0500
Received: from mail-wg0-f48.google.com ([74.125.82.48]:43249 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751266AbbAYOO0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2015 09:14:26 -0500
Date: Sun, 25 Jan 2015 16:14:20 +0200
From: Aya Mahfouz <mahfouz.saif.elyazal@gmail.com>
To: Heba Aamer <heba93aamer@gmail.com>
Cc: devel@driverdev.osuosl.org, florian.c.schilhabel@googlemail.com,
        thomas@grouk.net, tapaswenipathak@gmail.com,
        gregkh@linuxfoundation.org, rickard_strandqvist@spectrumdigital.se,
        linux-kernel@vger.kernel.org, sudipm.mukherjee@gmail.com,
        Larry.Finger@lwfinger.net
Subject: Re: [PATCH] staging: rtl8712: fix Prefer [subsystem eg:
 netdev]_info([subsystem]dev, ... then dev_info(dev, ... then pr_info(...  to
 printk(KERN_INFO ...
Message-ID: <20150125141420.GA4046@localhost.localdomain>
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

I've applied your patch and there is one problem here, pnetdev is not initialized yet.
It's better to use pr_info for now.

Kind Regards,
Aya Saif El-yazal Mahfouz

>  	/* In this probe function, O.S. will provide the usb interface pointer
>  	 * to driver. We have to increase the reference count of the usb device
>  	 * structure by using the usb_get_dev function.
> -- 
> 1.7.9.5
> 
> _______________________________________________
> devel mailing list
> devel@linuxdriverproject.org
> http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel
