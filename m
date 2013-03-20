Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752289Ab3CTRUG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 13:20:06 -0400
Received: from mail-pb0-f51.google.com ([209.85.160.51]:44736 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751812Ab3CTRUC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 13:20:02 -0400
Date: Wed, 20 Mar 2013 10:21:25 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Philippe Langlais <philippe.langlais@st.com>
Cc: linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
        Hans-Peter Oeri <hp@oeri.ch>
Subject: Re: [PATCH] tty: serial: 8250: remove U6715 16550A auto-detection
Message-ID: <20130320172125.GB28605@kroah.com>
References: <1363722609-20021-1-git-send-email-philippe.langlais@st.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1363722609-20021-1-git-send-email-philippe.langlais@st.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 19, 2013 at 08:50:09PM +0100, Philippe Langlais wrote:
> The auto-detection based on 64 bytes fifo size causes troubles
> for the identification of the MultiTechZPX Modems (pci 11c1:0480).
> They loose the ability to do hardware flow control
> (specifically CTS is never set).
> 
> Signed-off-by: Philippe Langlais <philippe.langlais@st.com>
> ---
>  drivers/tty/serial/8250/8250.c |    9 ---------
>  1 file changed, 9 deletions(-)
> 
> diff --git a/drivers/tty/serial/8250/8250.c b/drivers/tty/serial/8250/8250.c
> index cf6a538..3255014 100644
> --- a/drivers/tty/serial/8250/8250.c
> +++ b/drivers/tty/serial/8250/8250.c
> @@ -1026,15 +1026,6 @@ static void autoconfig_16550a(struct uart_8250_port *up)
>  
>  		return;
>  	}
> -
> -	/*
> -	 * We distinguish between 16550A and U6 16550A by counting
> -	 * how many bytes are in the FIFO.
> -	 */
> -	if (up->port.type == PORT_16550A && size_fifo(up) == 64) {
> -		up->port.type = PORT_U6_16550A;
> -		up->capabilities |= UART_CAP_AFE;
> -	}

So you just broke this functionality for all of the other devices it
does work properly for?  That's not nice, and not acceptable.

Please fix this properly.

greg k-h
