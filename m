Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753403AbaHKNEl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 09:04:41 -0400
Received: from mail1.skidata.com ([91.230.2.99]:21121 "EHLO mail1.skidata.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752364AbaHKNEk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 09:04:40 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ArgEAG6+6FOsEApK/2dsb2JhbABbg19XBLVBlz+HTAGBLXeEBAEEAScTPwULCw0UJQ9IBgENBYg6DQjBOhMEjTyCEAeETAEEhg+MBYMqhnCHUZEJaoFH
X-IPAS-Result: ArgEAG6+6FOsEApK/2dsb2JhbABbg19XBLVBlz+HTAGBLXeEBAEEAScTPwULCw0UJQ9IBgENBYg6DQjBOhMEjTyCEAeETAEEhg+MBYMqhnCHUZEJaoFH
Date: Mon, 11 Aug 2014 15:04:35 +0200
From: Richard Leitner <richard.leitner@skidata.com>
To: <balbi@ti.com>, <gregkh@linuxfoundation.org>
CC: <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] usb: gadget: serial: remove PREFIX macro
Message-ID: <20140811150435.6235fbf6@lxbuild.skidata.net>
In-Reply-To: <20140718113946.0e70c0cb@lxbuild.skidata.net>
References: <20140718113946.0e70c0cb@lxbuild.skidata.net>
Organization: SKIDATA AG
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [172.16.60.30]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
this patch was lying around for some time...
are there any comments or objections on this?

regards,
richard

On Fri, 18 Jul 2014 11:39:46 +0200
Richard Leitner <richard.leitner@skidata.com> wrote:

> Remove the ttyGS PREFIX macro from u_serial.c and replace all occurences with
> the hardcoded ttyGS string.
> 
> This macro was mostly used in a few debug/warning messages and a lot of
> hardcoded ttyGS existed beneath. It may have been used for renaming the
> tty, but if done so most debug messages would have ignored this because
> of the hardcoded strings.
> 
> Due to the fact the usage of this PREFIX instead of the hardcoded strings
> in all debug calls would have resulted in a hard to read/grep code it
> is removed completely.
> 
> Signed-off-by: Richard Leitner <richard.leitner@skidata.com>
> ---
> note: previous discussion was at https://lkml.org/lkml/2014/6/27/193
> ---
>  drivers/usb/gadget/u_serial.c |   21 +++++++++------------
>  1 file changed, 9 insertions(+), 12 deletions(-)
> 
> diff --git a/drivers/usb/gadget/u_serial.c b/drivers/usb/gadget/u_serial.c
> index ad0aca8..7e7a6b0 100644
> --- a/drivers/usb/gadget/u_serial.c
> +++ b/drivers/usb/gadget/u_serial.c
> @@ -55,11 +55,8 @@
>   * for a telephone or fax link.  And ttyGS2 might be something that just
>   * needs a simple byte stream interface for some messaging protocol that
>   * is managed in userspace ... OBEX, PTP, and MTP have been mentioned.
> - */
> -
> -#define PREFIX	"ttyGS"
> -
> -/*
> + *
> + *
>   * gserial is the lifecycle interface, used by USB functions
>   * gs_port is the I/O nexus, used by the tty driver
>   * tty_struct links to the tty/filesystem framework
> @@ -385,7 +382,7 @@ __acquires(&port->port_lock)
>  		list_del(&req->list);
>  		req->zero = (gs_buf_data_avail(&port->port_write_buf) == 0);
>  
> -		pr_vdebug(PREFIX "%d: tx len=%d, 0x%02x 0x%02x 0x%02x ...\n",
> +		pr_vdebug("ttyGS%d: tx len=%d, 0x%02x 0x%02x 0x%02x ...\n",
>  				port->port_num, len, *((u8 *)req->buf),
>  				*((u8 *)req->buf+1), *((u8 *)req->buf+2));
>  
> @@ -503,12 +500,12 @@ static void gs_rx_push(unsigned long _port)
>  		switch (req->status) {
>  		case -ESHUTDOWN:
>  			disconnect = true;
> -			pr_vdebug(PREFIX "%d: shutdown\n", port->port_num);
> +			pr_vdebug("ttyGS%d: shutdown\n", port->port_num);
>  			break;
>  
>  		default:
>  			/* presumably a transient fault */
> -			pr_warning(PREFIX "%d: unexpected RX status %d\n",
> +			pr_warn("ttyGS%d: unexpected RX status %d\n",
>  					port->port_num, req->status);
>  			/* FALLTHROUGH */
>  		case 0:
> @@ -537,7 +534,7 @@ static void gs_rx_push(unsigned long _port)
>  			if (count != size) {
>  				/* stop pushing; TTY layer can't handle more */
>  				port->n_read += count;
> -				pr_vdebug(PREFIX "%d: rx block %d/%d\n",
> +				pr_vdebug("ttyGS%d: rx block %d/%d\n",
>  						port->port_num,
>  						count, req->actual);
>  				break;
> @@ -569,7 +566,7 @@ static void gs_rx_push(unsigned long _port)
>  			if (do_push)
>  				tasklet_schedule(&port->push);
>  			else
> -				pr_warning(PREFIX "%d: RX not scheduled?\n",
> +				pr_warn("ttyGS%d: RX not scheduled?\n",
>  					port->port_num);
>  		}
>  	}
> @@ -985,7 +982,7 @@ static void gs_unthrottle(struct tty_struct *tty)
>  		 * read queue backs up enough we'll be NAKing OUT packets.
>  		 */
>  		tasklet_schedule(&port->push);
> -		pr_vdebug(PREFIX "%d: unthrottle\n", port->port_num);
> +		pr_vdebug("ttyGS%d: unthrottle\n", port->port_num);
>  	}
>  	spin_unlock_irqrestore(&port->port_lock, flags);
>  }
> @@ -1295,7 +1292,7 @@ static int userial_init(void)
>  		return -ENOMEM;
>  
>  	gs_tty_driver->driver_name = "g_serial";
> -	gs_tty_driver->name = PREFIX;
> +	gs_tty_driver->name = "ttyGS";
>  	/* uses dynamically assigned dev_t values */
>  
>  	gs_tty_driver->type = TTY_DRIVER_TYPE_SERIAL;
