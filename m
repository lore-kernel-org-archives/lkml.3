Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755211Ab3I3Myc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 08:54:32 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:37645 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753070Ab3I3Mya (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 08:54:30 -0400
Date: Mon, 30 Sep 2013 05:54:33 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Michal Simek <michal.simek@xilinx.com>
Cc: linux-kernel@vger.kernel.org, Michal Simek <monstr@monstr.eu>,
        linux-serial@vger.kernel.org, arnd@arndb.de,
        Peter Korsgaard <jacmet@sunsite.dk>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Jiri Slaby <jslaby@suse.cz>
Subject: Re: [RFC PATCH] tty: serial: uartlite: Extend time for sending chars
 through mdm IP
Message-ID: <20130930125433.GC13654@kroah.com>
References: <fec1c418d7d8933a9729ea1926c76e404f8c3020.1380541829.git.michal.simek@xilinx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fec1c418d7d8933a9729ea1926c76e404f8c3020.1380541829.git.michal.simek@xilinx.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 30, 2013 at 01:50:35PM +0200, Michal Simek wrote:
> From: Michal Simek <monstr@monstr.eu>
> 
> Serial over jtag via mdm is compatible with uartlite driver
> just need to extend time for reading chars because connection
> is slow.
> 
> Signed-off-by: Michal Simek <michal.simek@xilinx.com>
> ---
>  drivers/tty/serial/uartlite.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/tty/serial/uartlite.c b/drivers/tty/serial/uartlite.c
> index 5f90ef2..f55c342 100644
> --- a/drivers/tty/serial/uartlite.c
> +++ b/drivers/tty/serial/uartlite.c
> @@ -422,7 +422,7 @@ static void ulite_console_wait_tx(struct uart_port *port)
>  	u8 val;
> 
>  	/* Spin waiting for TX fifo to have space available */
> -	for (i = 0; i < 100000; i++) {
> +	for (i = 0; i < 10000000; i++) {
>  		val = uart_in32(ULITE_STATUS, port);
>  		if ((val & ULITE_STATUS_TXFULL) == 0)
>  			break;

Ick, what happens next year when we get a faster cpu?

Please make this a time delay, not a 'loop till we can count to this
number', so we know exactly what is going on here.

thanks,

greg k-h
