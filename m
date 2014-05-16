Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756966AbaEPPa1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 11:30:27 -0400
Received: from mail-la0-f41.google.com ([209.85.215.41]:35808 "EHLO
	mail-la0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751789AbaEPPaZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 11:30:25 -0400
Date: Fri, 16 May 2014 17:30:00 +0200
From: Johan Hovold <jhovold@gmail.com>
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Cc: Johan Hovold <jhovold@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix for possible null pointer dereference in keyspan.c
Message-ID: <20140516153000.GC8213@localhost>
References: <1400190910-28019-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1400190910-28019-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 15, 2014 at 11:55:10PM +0200, Rickard Strandqvist wrote:
> There is otherwise a risk of a possible null pointer dereference.

I don't think this can be triggered unless the URB allocation fails at
probe, but let's move the offending line nonetheless.

I'll fix up the patch subject as well.

> Was largely found by using a static code analysis program called cppcheck.
> 
> Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
> ---
>  drivers/usb/serial/keyspan.c |    4 ++--
>  1 fil ändrad, 2 tillägg(+), 2 borttagningar(-)

Diff stats in Swedish?! :)

Thanks,
Johan

> diff --git a/drivers/usb/serial/keyspan.c b/drivers/usb/serial/keyspan.c
> index d3acaea..93cb7ce 100644
> --- a/drivers/usb/serial/keyspan.c
> +++ b/drivers/usb/serial/keyspan.c
> @@ -1535,14 +1535,14 @@ static int keyspan_usa26_send_setup(struct usb_serial *serial,
>  
>  	this_urb = p_priv->outcont_urb;
>  
> -	dev_dbg(&port->dev, "%s - endpoint %d\n", __func__, usb_pipeendpoint(this_urb->pipe));
> -
>  		/* Make sure we have an urb then send the message */
>  	if (this_urb == NULL) {
>  		dev_dbg(&port->dev, "%s - oops no urb.\n", __func__);
>  		return -1;
>  	}
>  
> +	dev_dbg(&port->dev, "%s - endpoint %d\n", __func__, usb_pipeendpoint(this_urb->pipe));
> +
>  	/* Save reset port val for resend.
>  	   Don't overwrite resend for open/close condition. */
>  	if ((reset_port + 1) > p_priv->resend_cont)
