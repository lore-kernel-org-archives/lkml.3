Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756760AbaFAJbs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2014 05:31:48 -0400
Received: from mail-lb0-f173.google.com ([209.85.217.173]:62660 "EHLO
	mail-lb0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751346AbaFAJbq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2014 05:31:46 -0400
Date: Sun, 1 Jun 2014 11:31:17 +0200
From: Johan Hovold <jhovold@gmail.com>
To: Peter Senna Tschudin <peter.senna@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Oliver Neukum <oliver@neukum.org>, kernel-janitors@vger.kernel.org,
        Johan Hovold <jhovold@gmail.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/11 V2] USB: kl5kusb105: Remove klsi_105_tiocmset
 function
Message-ID: <20140601093117.GC14935@localhost>
References: <1401552180-9445-1-git-send-email-peter.senna@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1401552180-9445-1-git-send-email-peter.senna@gmail.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 31, 2014 at 01:03:00PM -0300, Peter Senna Tschudin wrote:
> This patch remove the function klsi_105_tiocmset which was only
> returning -EINVAL. It also removes the function prototype and
> the .tiocmset entry in the struct usb_serial_driver.
> 
> Verified by compilation only.
> 
> Signed-off-by: Peter Senna Tschudin <peter.senna@gmail.com>

Signed-off-by: Johan Hovold <jhovold@gmail.com>

> ---
> Changes from V1:
>  - remove the function klsi_105_tiocmset instead of simplifying it
>  - remove the function prototype
>  - remove the .tiocmset entry in the struct usb_serial_driver
>  - update commit message and subject

Thanks for the update, Peter.

Johan
 
> 
>  drivers/usb/serial/kl5kusb105.c |   23 +----------------------
>  1 file changed, 1 insertion(+), 22 deletions(-)
> 
> diff --git a/drivers/usb/serial/kl5kusb105.c b/drivers/usb/serial/kl5kusb105.c
> index d7440b7..e020ad2 100644
> --- a/drivers/usb/serial/kl5kusb105.c
> +++ b/drivers/usb/serial/kl5kusb105.c
> @@ -62,8 +62,6 @@ static void klsi_105_close(struct usb_serial_port *port);
>  static void klsi_105_set_termios(struct tty_struct *tty,
>  			struct usb_serial_port *port, struct ktermios *old);
>  static int  klsi_105_tiocmget(struct tty_struct *tty);
> -static int  klsi_105_tiocmset(struct tty_struct *tty,
> -			unsigned int set, unsigned int clear);
>  static void klsi_105_process_read_urb(struct urb *urb);
>  static int klsi_105_prepare_write_buffer(struct usb_serial_port *port,
>  						void *dest, size_t size);
> @@ -93,7 +91,6 @@ static struct usb_serial_driver kl5kusb105d_device = {
>  	.set_termios =		klsi_105_set_termios,
>  	/*.break_ctl =		klsi_105_break_ctl,*/
>  	.tiocmget =		klsi_105_tiocmget,
> -	.tiocmset =		klsi_105_tiocmset,
>  	.port_probe =		klsi_105_port_probe,
>  	.port_remove =		klsi_105_port_remove,
>  	.throttle =		usb_serial_generic_throttle,
> @@ -602,33 +599,6 @@ static int klsi_105_tiocmget(struct tty_struct *tty)
>  	return (int)line_state;
>  }
>  
> -static int klsi_105_tiocmset(struct tty_struct *tty,
> -			     unsigned int set, unsigned int clear)
> -{
> -	int retval = -EINVAL;
> -
> -/* if this ever gets implemented, it should be done something like this:
> -	struct usb_serial *serial = port->serial;
> -	struct klsi_105_private *priv = usb_get_serial_port_data(port);
> -	unsigned long flags;
> -	int control;
> -
> -	spin_lock_irqsave (&priv->lock, flags);
> -	if (set & TIOCM_RTS)
> -		priv->control_state |= TIOCM_RTS;
> -	if (set & TIOCM_DTR)
> -		priv->control_state |= TIOCM_DTR;
> -	if (clear & TIOCM_RTS)
> -		priv->control_state &= ~TIOCM_RTS;
> -	if (clear & TIOCM_DTR)
> -		priv->control_state &= ~TIOCM_DTR;
> -	control = priv->control_state;
> -	spin_unlock_irqrestore (&priv->lock, flags);
> -	retval = mct_u232_set_modem_ctrl(serial, control);
> -*/
> -	return retval;
> -}
> -
>  module_usb_serial_driver(serial_drivers, id_table);
>  
>  MODULE_AUTHOR(DRIVER_AUTHOR);
