Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751997AbaGGIYA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 04:24:00 -0400
Received: from mail-la0-f54.google.com ([209.85.215.54]:64051 "EHLO
	mail-la0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751227AbaGGIX5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 04:23:57 -0400
X-Google-Original-Sender: <johan@hovold.com>
Date: Mon, 7 Jul 2014 10:23:21 +0200
From: Johan Hovold <johan@kernel.org>
To: Fabian Frederick <fabf@skynet.be>
Cc: linux-kernel@vger.kernel.org, Johan Hovold <jhovold@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org
Subject: Re: [PATCH 1/1] drivers/usb/serial/mos7840.c: remove unnecessary
 null test before kfree
Message-ID: <20140707082321.GA29098@localhost>
References: <1403959449-5986-1-git-send-email-fabf@skynet.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1403959449-5986-1-git-send-email-fabf@skynet.be>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 28, 2014 at 02:44:09PM +0200, Fabian Frederick wrote:
> Cc: Johan Hovold <jhovold@gmail.com>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: linux-usb@vger.kernel.org
> Signed-off-by: Fabian Frederick <fabf@skynet.be>

Applied, thanks.

Johan

> ---
>  drivers/usb/serial/mos7840.c | 5 +----
>  1 file changed, 1 insertion(+), 4 deletions(-)
> 
> diff --git a/drivers/usb/serial/mos7840.c b/drivers/usb/serial/mos7840.c
> index 393be56..3d88eef 100644
> --- a/drivers/usb/serial/mos7840.c
> +++ b/drivers/usb/serial/mos7840.c
> @@ -1181,10 +1181,7 @@ static void mos7840_close(struct usb_serial_port *port)
>  	/* Freeing Write URBs */
>  	for (j = 0; j < NUM_URBS; ++j) {
>  		if (mos7840_port->write_urb_pool[j]) {
> -			if (mos7840_port->write_urb_pool[j]->transfer_buffer)
> -				kfree(mos7840_port->write_urb_pool[j]->
> -				      transfer_buffer);
> -
> +			kfree(mos7840_port->write_urb_pool[j]->transfer_buffer);
>  			usb_free_urb(mos7840_port->write_urb_pool[j]);
>  		}
>  	}
