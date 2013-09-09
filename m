Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754362Ab3IIQgu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 12:36:50 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:57944 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750977Ab3IIQgt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 12:36:49 -0400
Date: Mon, 9 Sep 2013 09:36:48 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Paul Chavent <Paul.Chavent@onera.fr>
Cc: linux-usb@vger.kernel.org, jhovold@gmail.com, fschaefer.oss@googlemail.com,
        jslaby@suse.cz, max@suse.de, giometti@enneenne.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/5] USB : serial : invoke dcd_change ldisc's handler.
Message-ID: <20130909163648.GA26148@kroah.com>
References: <1378742480-2146-1-git-send-email-paul.chavent@onera.fr>
 <1378742480-2146-5-git-send-email-paul.chavent@onera.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1378742480-2146-5-git-send-email-paul.chavent@onera.fr>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 09, 2013 at 06:01:19PM +0200, Paul Chavent wrote:
> In order to have the PPS line discipline to work with usb devices.
> 
> Signed-off-by: Paul Chavent <paul.chavent@onera.fr>
> ---
>  drivers/usb/serial/generic.c | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/drivers/usb/serial/generic.c b/drivers/usb/serial/generic.c
> index 91f0592..a18a086 100644
> --- a/drivers/usb/serial/generic.c
> +++ b/drivers/usb/serial/generic.c
> @@ -567,6 +567,13 @@ void usb_serial_handle_dcd_change(struct usb_serial_port *usb_port,
>  {
>  	struct tty_port *port = &usb_port->port;
>  	struct tty_struct *tty = tty_port_tty_get(port);
> +	struct tty_ldisc *ld = tty ? tty_ldisc_ref(tty) : NULL;
> +
> +	if (ld) {

Minor nit, I hate the ? : mode of C, and as you are doing another if
statement right after it, it's pretty redundant here.  So can you just
merge them together into one if chain?

thanks,

greg k-h
