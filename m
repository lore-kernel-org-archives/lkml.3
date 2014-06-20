Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754985AbaFTP16 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 11:27:58 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:58583 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753294AbaFTP16 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 11:27:58 -0400
Date: Fri, 20 Jun 2014 08:31:59 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Vincent Heuken <me@vincentheuken.com>
Cc: thomas_75@safe-mail.net, paul.gortmaker@windriver.com,
        himangi774@gmail.com, arnd@arndb.de, aybuke.147@gmail.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging: serqt_usb2: fixed frivolous else statement
 warnings
Message-ID: <20140620153159.GA26048@kroah.com>
References: <1403270597-21694-1-git-send-email-me@vincentheuken.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1403270597-21694-1-git-send-email-me@vincentheuken.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 20, 2014 at 06:23:17AM -0700, Vincent Heuken wrote:
> This is a patch to the serqt_usb2.c file that fixes two instances
> of the following checkpatch.pl warning:
> WARNING: else is not generally useful after a break or return
> 
> Signed-off-by: Vincent Heuken <me@vincentheuken.com>
> ---
>  drivers/staging/serqt_usb2/serqt_usb2.c | 44 ++++++++++++++++-----------------
>  1 file changed, 21 insertions(+), 23 deletions(-)
> 
> diff --git a/drivers/staging/serqt_usb2/serqt_usb2.c b/drivers/staging/serqt_usb2/serqt_usb2.c
> index 998c384..c356542 100644
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
> @@ -1132,25 +1131,24 @@ static int qt_ioctl(struct tty_struct *tty,
>  #endif
>  			if (signal_pending(current))
>  				return -ERESTARTSYS;
> -			else {
> -				char diff = qt_port->diff_status;
> -
> -				if (diff == 0)
> -					return -EIO;	/* no change => error */
> -
> -				/* Consume all events */
> -				qt_port->diff_status = 0;
> -
> -				if (((arg & TIOCM_RNG)
> -				     && (diff & SERIAL_MSR_RI))
> -				    || ((arg & TIOCM_DSR)
> -					&& (diff & SERIAL_MSR_DSR))
> -				    || ((arg & TIOCM_CD)
> -					&& (diff & SERIAL_MSR_CD))
> -				    || ((arg & TIOCM_CTS)
> -					&& (diff & SERIAL_MSR_CTS))) {
> -					return 0;
> -				}
> +
> +			char diff = qt_port->diff_status;

This change causes a compiler warning, please be more careful in your
patches.  Can you fix this up and resend?

thanks,

greg k-h
