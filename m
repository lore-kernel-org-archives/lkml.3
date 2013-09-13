Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756738Ab3IMPvo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 11:51:44 -0400
Received: from mail-lb0-f182.google.com ([209.85.217.182]:57727 "EHLO
	mail-lb0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755032Ab3IMPvm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 11:51:42 -0400
Date: Fri, 13 Sep 2013 17:51:38 +0200
From: Johan Hovold <jhovold@gmail.com>
To: Paul Chavent <Paul.Chavent@onera.fr>
Cc: linux-usb@vger.kernel.org, gregkh@linuxfoundation.org, jhovold@gmail.com,
        fschaefer.oss@googlemail.com, jslaby@suse.cz, max@suse.de,
        giometti@enneenne.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] USB : serial : call handle_dcd_change in ftdi driver.
Message-ID: <20130913155138.GA9054@localhost>
References: <1379086513-2434-1-git-send-email-paul.chavent@onera.fr>
 <1379086513-2434-2-git-send-email-paul.chavent@onera.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1379086513-2434-2-git-send-email-paul.chavent@onera.fr>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 13, 2013 at 05:35:11PM +0200, Paul Chavent wrote:
> Signed-off-by: Paul Chavent <paul.chavent@onera.fr>
> ---
>  drivers/usb/serial/ftdi_sio.c | 8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/usb/serial/ftdi_sio.c b/drivers/usb/serial/ftdi_sio.c
> index c45f9c0..df66495 100644
> --- a/drivers/usb/serial/ftdi_sio.c
> +++ b/drivers/usb/serial/ftdi_sio.c
> @@ -1966,8 +1966,14 @@ static int ftdi_process_packet(struct usb_serial_port *port,
>  			port->icount.dsr++;
>  		if (diff_status & FTDI_RS0_RI)
>  			port->icount.rng++;
> -		if (diff_status & FTDI_RS0_RLSD)
> +		if (diff_status & FTDI_RS0_RLSD) {
>  			port->icount.dcd++;
> +			struct tty_struct *tty = tty_port_tty_get(&port->port);

Please move the tty_struct definition to the top of the function (or at
least to the top of the block).

Thanks,
Johan
