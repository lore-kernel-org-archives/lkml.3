Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752002AbaH3UkL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Aug 2014 16:40:11 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:53768 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751898AbaH3UkJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Aug 2014 16:40:09 -0400
Date: Sat, 30 Aug 2014 13:40:09 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Miguel Oliveira <cmroliv@gmail.com>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        davem@davemloft.net, Larry.Finger@lwfinger.net
Subject: Re: [PATCH 1/4] staging: rtl8188eu: os_intfs.c
Message-ID: <20140830204009.GA16168@kroah.com>
References: <1408703558-32167-1-git-send-email-cmroliv@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1408703558-32167-1-git-send-email-cmroliv@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Your subject does not say what is going on in this patch, only the file
being modified :(


On Fri, Aug 22, 2014 at 11:32:38AM +0100, Miguel Oliveira wrote:
> void rtw_proc_remove_one(struct net_device *dev)
> {
> }
> void rtw_proc_init_one(struct net_device *dev)
>   /* TODO: Convert these to /sys */
> 
> Converting the above from proc into debugfs.
> Convert all rtw_proc_xxx references to rtw_sys_xxx

I don't understand, what exactly are you doing here?

Are you moving stuff to debugfs or to sysfs?  And what exactly are you
moving?  And why?  And if sysfs, you need to document the files.

> 
> Signed-off-by: Miguel Oliveira <cmroliv@gmail.com>
> ---
>  drivers/staging/rtl8188eu/os_dep/os_intfs.c |  517 +++++++++++++++++----------
>  1 file changed, 326 insertions(+), 191 deletions(-)
> 
> diff --git a/drivers/staging/rtl8188eu/os_dep/os_intfs.c b/drivers/staging/rtl8188eu/os_dep/os_intfs.c
> index c7a44ab..49b441a 100644
> --- a/drivers/staging/rtl8188eu/os_dep/os_intfs.c
> +++ b/drivers/staging/rtl8188eu/os_dep/os_intfs.c
> @@ -29,6 +29,8 @@
>  
>  #include <usb_hal.h>
>  
> +#include <linux/debugfs.h>
> +
>  MODULE_LICENSE("GPL");
>  MODULE_DESCRIPTION("Realtek Wireless Lan Driver");
>  MODULE_AUTHOR("Realtek Semiconductor Corp.");
> @@ -166,50 +168,254 @@ MODULE_PARM_DESC(rtw_notch_filter, "0:Disable, 1:Enable, 2:Enable only for P2P")
>  module_param_named(debug, rtw_debug, int, 0444);
>  MODULE_PARM_DESC(debug, "Set debug level (1-9) (default 1)");
>  
> -/* dummy routines */
> -void rtw_proc_remove_one(struct net_device *dev)
> -{
> -}
> +static const struct file_operations drv_version = {
> +	.owner =	THIS_MODULE,
> +	.read =		sys_get_drv_version,
> +	.llseek =	default_llseek,
> +};

<snip>

You do know that debugfs can handle single variables very easily, with
no need for a file_operations structure, right?  Are you sure you need
all of these new structures?

thanks,

greg k-h
