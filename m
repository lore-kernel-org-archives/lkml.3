Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935103AbaFTQjr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 12:39:47 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:59411 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932155AbaFTQjq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 12:39:46 -0400
Date: Fri, 20 Jun 2014 09:43:47 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Vincent Heuken <me@vincentheuken.com>
Cc: thomas_75@safe-mail.net, himangi774@gmail.com,
        paul.gortmaker@windriver.com, aybuke.147@gmail.com, arnd@arndb.de,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging: serqt_usb2: fixed frivolous else statement
 warnings
Message-ID: <20140620164347.GA23197@kroah.com>
References: <1403281888-12873-1-git-send-email-me@vincentheuken.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1403281888-12873-1-git-send-email-me@vincentheuken.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 20, 2014 at 09:31:28AM -0700, Vincent Heuken wrote:
> This is a patch to the serqt_usb2.c file that fixes two instances
> of the following checkpatch.pl warning:
> WARNING: else is not generally useful after a break or return
> 
> Signed-off-by: Vincent Heuken <me@vincentheuken.com>
> ---
>  drivers/staging/serqt_usb2/serqt_usb2.c | 47 +++++++++++++++++----------------
>  1 file changed, 24 insertions(+), 23 deletions(-)
> 
> diff --git a/drivers/staging/serqt_usb2/serqt_usb2.c b/drivers/staging/serqt_usb2/serqt_usb2.c
> index 998c384..98e9736 100644
> --- a/drivers/staging/serqt_usb2/serqt_usb2.c
> +++ b/drivers/staging/serqt_usb2/serqt_usb2.c
> @@ -981,9 +981,8 @@ static void qt_block_until_empty(struct tty_struct *tty,
>  		if (wait == 0) {
>  			dev_dbg(&qt_port->port->dev, "%s - TIMEOUT", __func__);
>  			return;
> -		} else {
> -			wait = 30;
>  		}
> +		wait = 30;
>  	}
>  }
>  
> @@ -1130,27 +1129,29 @@ static int qt_ioctl(struct tty_struct *tty,
>  			/* this never wakes up */
>  			interruptible_sleep_on(&qt_port->msr_wait);
>  #endif
> +
> +			char diff;

A variable definition should be at the beginning of the function, not in
the middle.

thanks,

greg k-h
