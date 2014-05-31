Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756573AbaEaO6o (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 May 2014 10:58:44 -0400
Received: from mail-la0-f52.google.com ([209.85.215.52]:51560 "EHLO
	mail-la0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751664AbaEaO6m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 May 2014 10:58:42 -0400
Date: Sat, 31 May 2014 16:58:14 +0200
From: Johan Hovold <jhovold@gmail.com>
To: Peter Senna Tschudin <peter.senna@gmail.com>
Cc: Oliver Neukum <oliver@neukum.org>, kernel-janitors@vger.kernel.org,
        Johan Hovold <jhovold@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/11] USB: kl5kusb105: Remove useless return variables
Message-ID: <20140531145814.GA14935@localhost>
References: <1401542051-3174-1-git-send-email-peter.senna@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1401542051-3174-1-git-send-email-peter.senna@gmail.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 31, 2014 at 10:14:01AM -0300, Peter Senna Tschudin wrote:
> This patch remove variables that are initialized with a constant,
> are never updated, and are only used as parameter of return.
> Return the constant instead of using a variable.
> 
> Verified by compilation only.
> 
> The coccinelle script that find and fixes this issue is:
> // <smpl>
> @@
> type T;
> constant C;
> identifier ret;
> @@
> - T ret = C;
> ... when != ret
>     when strict
> return
> - ret
> + C
> ;
> // </smpl>
> 
> Signed-off-by: Peter Senna Tschudin <peter.senna@gmail.com>
> 
> ---
>  drivers/usb/serial/kl5kusb105.c |   23 +----------------------
>  1 file changed, 1 insertion(+), 22 deletions(-)
> 
> diff --git a/drivers/usb/serial/kl5kusb105.c b/drivers/usb/serial/kl5kusb105.c
> index d7440b7..2657c00 100644
> --- a/drivers/usb/serial/kl5kusb105.c
> +++ b/drivers/usb/serial/kl5kusb105.c
> @@ -605,28 +605,7 @@ static int klsi_105_tiocmget(struct tty_struct *tty)
>  static int klsi_105_tiocmset(struct tty_struct *tty,
>  			     unsigned int set, unsigned int clear)
>  {
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
> +	return -EINVAL;

Your patch does a bit more than what the description says, although
removing this out-commented code would be perfectly fine.

But please just remove the entire function (and the corresponding entry
in the struct usb_serial_driver) and update the commit message.

Thanks,
Johan

>  }
>  
>  module_usb_serial_driver(serial_drivers, id_table);
> 
