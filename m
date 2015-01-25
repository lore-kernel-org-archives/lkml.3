Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755113AbbAYQWG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2015 11:22:06 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:54745 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754066AbbAYQPh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2015 11:15:37 -0500
Date: Sun, 25 Jan 2015 19:52:37 +0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Murilo Opsfelder Araujo <mopsfelder@gmail.com>
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org
Subject: Re: [PATCH] staging: rtl8192u: r8192U_core: Fix compile issue when
 CONFIG_WIRELESS_EXT is not defined
Message-ID: <20150125115237.GA12221@kroah.com>
References: <1422126702-27357-1-git-send-email-mopsfelder@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1422126702-27357-1-git-send-email-mopsfelder@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 24, 2015 at 05:11:42PM -0200, Murilo Opsfelder Araujo wrote:
> This patch gets rid of the following error when compiling r8192U_core.c
> and CONFIG_WIRELESS_EXT is not defined:
> 
> drivers/staging/rtl8192u/r8192U_core.c: In function ‘rtl8192_usb_probe’:
> drivers/staging/rtl8192u/r8192U_core.c:4697:5: error: ‘struct net_device’ has no member named ‘wireless_handlers’
>   dev->wireless_handlers = (struct iw_handler_def *) &r8192_wx_handlers_def;
>      ^
> 
> Signed-off-by: Murilo Opsfelder Araujo <mopsfelder@gmail.com>
> ---
>  drivers/staging/rtl8192u/r8192U_core.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/staging/rtl8192u/r8192U_core.c b/drivers/staging/rtl8192u/r8192U_core.c
> index e031a25..396a11f 100644
> --- a/drivers/staging/rtl8192u/r8192U_core.c
> +++ b/drivers/staging/rtl8192u/r8192U_core.c
> @@ -4694,7 +4694,9 @@ static int rtl8192_usb_probe(struct usb_interface *intf,
>  
>  	dev->netdev_ops = &rtl8192_netdev_ops;
>  
> +#ifdef CONFIG_WIRELESS_EXT
>  	dev->wireless_handlers = (struct iw_handler_def *) &r8192_wx_handlers_def;
> +#endif

It's almost never correct to put a #ifdef in a .c file, so what is going
on here?  How do other drivers handle this in a more "proper" way?

Is this something new?  Should this driver just depend on this Kconfig
option?

I can't take this as-is, sorry.

greg k-h
