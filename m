Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751634AbaKCJuG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 04:50:06 -0500
Received: from mail-pa0-f54.google.com ([209.85.220.54]:51477 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750969AbaKCJuC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 04:50:02 -0500
Date: Mon, 3 Nov 2014 15:19:51 +0530
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] usb: yurex: fixed sparse warning of incorrect type
Message-ID: <20141103094951.GA3153@sudip-PC>
References: <1412945386-4781-1-git-send-email-sudipm.mukherjee@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1412945386-4781-1-git-send-email-sudipm.mukherjee@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 10, 2014 at 06:19:45PM +0530, Sudip Mukherjee wrote:
> fixed sparse warning of
> 	1) incorrect type (different address spaces)
> 	2) incorrect type in initializer
> 
> Signed-off-by: Sudip Mukherjee <sudip@vectorindia.org>
> ---
>  drivers/usb/misc/yurex.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/usb/misc/yurex.c b/drivers/usb/misc/yurex.c
> index c3a45da..343fa6f 100644
> --- a/drivers/usb/misc/yurex.c
> +++ b/drivers/usb/misc/yurex.c
> @@ -410,7 +410,8 @@ static int yurex_release(struct inode *inode, struct file *file)
>  	return 0;
>  }
>  
> -static ssize_t yurex_read(struct file *file, char *buffer, size_t count, loff_t *ppos)
> +static ssize_t yurex_read(struct file *file, char __user *buffer, size_t count,
> +			  loff_t *ppos)
>  {
>  	struct usb_yurex *dev;
>  	int retval = 0;
> @@ -444,7 +445,8 @@ exit:
>  	return retval;
>  }
>  
> -static ssize_t yurex_write(struct file *file, const char *user_buffer, size_t count, loff_t *ppos)
> +static ssize_t yurex_write(struct file *file, const char __user *user_buffer,
> +			   size_t count, loff_t *ppos)
>  {
>  	struct usb_yurex *dev;
>  	int i, set = 0, retval = 0;
> -- 
> 1.8.1.2
> 
gentle ping

thanks
sudip
