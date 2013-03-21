Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754422Ab3CUKq6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 06:46:58 -0400
Received: from mga09.intel.com ([134.134.136.24]:65071 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753647Ab3CUKq4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 06:46:56 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,884,1355126400"; 
   d="scan'208";a="282671785"
Date: Thu, 21 Mar 2013 12:46:51 +0200
From: Heikki Krogerus <heikki.krogerus@linux.intel.com>
To: Ley Foon Tan <lftan@altera.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jiri Slaby <jslaby@suse.cz>, Rob Landley <rob@landley.net>,
        linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org
Subject: Re: [PATCH] tty/serial: Add support for Altera serial port
Message-ID: <20130321104651.GC2862@xps8300>
References: <1362623317-2988-1-git-send-email-lftan@altera.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1362623317-2988-1-git-send-email-lftan@altera.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, Mar 07, 2013 at 10:28:37AM +0800, Ley Foon Tan wrote:
> diff --git a/drivers/tty/serial/8250/8250.c b/drivers/tty/serial/8250/8250.c
> index 0efc815..661096d 100644
> --- a/drivers/tty/serial/8250/8250.c
> +++ b/drivers/tty/serial/8250/8250.c
> @@ -301,7 +301,28 @@ static const struct serial8250_config uart_config[] = {
>  	},
>  	[PORT_8250_CIR] = {
>  		.name		= "CIR port"
> -	}
> +	},
> +	[PORT_ALTR_16550_F32] = {
> +		.name		= "Altera 16550 FIFO32",
> +		.fifo_size	= 32,
> +		.tx_loadsz	= 32,
> +		.fcr		= UART_FCR_ENABLE_FIFO | UART_FCR_R_TRIG_10,
> +		.flags		= UART_CAP_FIFO | UART_CAP_AFE,
> +	},
> +	[PORT_ALTR_16550_F64] = {
> +		.name		= "Altera 16550 FIFO64",
> +		.fifo_size	= 64,
> +		.tx_loadsz	= 64,
> +		.fcr		= UART_FCR_ENABLE_FIFO | UART_FCR_R_TRIG_10,
> +		.flags		= UART_CAP_FIFO | UART_CAP_AFE,
> +	},
> +	[PORT_ALTR_16550_F128] = {
> +		.name		= "Altera 16550 FIFO128",
> +		.fifo_size	= 128,
> +		.tx_loadsz	= 128,
> +		.fcr		= UART_FCR_ENABLE_FIFO | UART_FCR_R_TRIG_10,
> +		.flags		= UART_CAP_FIFO | UART_CAP_AFE,
> +	},

Adding three new types for what are basically the same UART, just with
different fifosizes, feels a bit silly to me, so in the future the
fifosize should be delivered as DT property. The following patches
fill uart_port.fifosize with the value from the property. I can see
the fifosize property is already used with some uarts, at least under
arch/arm/boot/dts/, but I guess not for of_serial.c driver.

Maybe there should also be DT property for auto flow control. It seems
to be quite common feature. Then in this case the type could just be
PORT_16550A.

-- 
heikki
