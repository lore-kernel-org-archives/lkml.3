Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751815AbaKFIXq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 03:23:46 -0500
Received: from bes.se.axis.com ([195.60.68.10]:46760 "EHLO bes.se.axis.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751757AbaKFIXl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 03:23:41 -0500
Date: Thu, 6 Nov 2014 09:23:34 +0100
From: Jesper Nilsson <jesper.nilsson@axis.com>
To: Peter Hurley <peter@hurleysoftware.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mikael Starvik <starvik@axis.com>, Jesper Nilsson <jespern@axis.com>
Subject: Re: [PATCH -next 6/9] cris: Remove obsolete ASYNC_SPLIT_TERMIOS
 behavior
Message-ID: <20141106082334.GL30087@axis.com>
References: <1415208392-16189-1-git-send-email-peter@hurleysoftware.com>
 <1415208392-16189-7-git-send-email-peter@hurleysoftware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1415208392-16189-7-git-send-email-peter@hurleysoftware.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 05, 2014 at 06:26:29PM +0100, Peter Hurley wrote:
> ASYNC_SPLIT_TERMIOS behavior is a remnant of the long-dead /dev/cuaXX
> callout device. Split termios handling was removed tree-wide in v2.5.71 by:
> 
> commit 99a21edebbfd8c29e39ee7fcc8a1ffa423657290
> Author: Alexander Viro <viro@www.linux.org.uk>
> Date:   Wed Jun 11 07:41:28 2003 -0700
> 
>     [PATCH] tty_driver refcounting
> 
>     killed the last remnants of callout stuff - we don't need to mess with
>     storing termios privately anymore.
> 
> which pre-dated the re-introduction into the cris serial driver
> in v2.6.7 by:
> 
> commit 311a5ffeda8ccb3f1f3840069f37234e043092d4
> Author: Andrew Morton <akpm@osdl.org>
> Date:   Mon May 31 18:52:29 2004 -0700
> 
>     [PATCH] CRIS architecture update
> 
>     From: "Mikael Starvik" <mikael.starvik@axis.com>
> 
>     - Lots of fixes from 2.4.
> 
>     - Updated for 2.6.6.
> 
>     - Added IDE driver
> 
> Cc: Mikael Starvik <starvik@axis.com>

Agreed.

Acked-by: Jesper Nilsson <jesper.nilsson@axis.com>

> Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
> ---
>  drivers/tty/serial/crisv10.c | 12 ------------
>  drivers/tty/serial/crisv10.h |  1 -
>  2 files changed, 13 deletions(-)
> 
> diff --git a/drivers/tty/serial/crisv10.c b/drivers/tty/serial/crisv10.c
> index 58e6f61..0c1825b 100644
> --- a/drivers/tty/serial/crisv10.c
> +++ b/drivers/tty/serial/crisv10.c
> @@ -3676,12 +3676,6 @@ rs_close(struct tty_struct *tty, struct file * filp)
>  	}
>  	info->port.flags |= ASYNC_CLOSING;
>  	/*
> -	 * Save the termios structure, since this port may have
> -	 * separate termios for callout and dialin.
> -	 */
> -	if (info->port.flags & ASYNC_NORMAL_ACTIVE)
> -		info->normal_termios = tty->termios;
> -	/*
>  	 * Now we wait for the transmit buffer to clear; and we notify
>  	 * the line discipline to only process XON/XOFF characters.
>  	 */
> @@ -4076,11 +4070,6 @@ rs_open(struct tty_struct *tty, struct file * filp)
>  		return retval;
>  	}
>  
> -	if ((info->port.count == 1) && (info->port.flags & ASYNC_SPLIT_TERMIOS)) {
> -		tty->termios = info->normal_termios;
> -		change_speed(info);
> -	}
> -
>  #ifdef SERIAL_DEBUG_OPEN
>  	printk("rs_open ttyS%d successful...\n", info->line);
>  #endif
> @@ -4327,7 +4316,6 @@ static int __init rs_init(void)
>  		info->custom_divisor = 0;
>  		info->x_char = 0;
>  		info->event = 0;
> -		info->normal_termios = driver->init_termios;
>  		info->xmit.buf = NULL;
>  		info->xmit.tail = info->xmit.head = 0;
>  		info->first_recv_buffer = info->last_recv_buffer = NULL;
> diff --git a/drivers/tty/serial/crisv10.h b/drivers/tty/serial/crisv10.h
> index 7599014..15a52ee 100644
> --- a/drivers/tty/serial/crisv10.h
> +++ b/drivers/tty/serial/crisv10.h
> @@ -98,7 +98,6 @@ struct e100_serial {
>  
>  	struct work_struct	work;
>  	struct async_icount	icount;   /* error-statistics etc.*/
> -	struct ktermios		normal_termios;
>  
>  	unsigned long char_time_usec;       /* The time for 1 char, in usecs */
>  	unsigned long flush_time_usec;      /* How often we should flush */
> -- 
> 2.1.3

/^JN - Jesper Nilsson
-- 
               Jesper Nilsson -- jesper.nilsson@axis.com
