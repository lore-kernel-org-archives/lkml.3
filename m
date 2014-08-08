Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756663AbaHHLFq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 07:05:46 -0400
Received: from mga01.intel.com ([192.55.52.88]:41968 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756635AbaHHLFn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 07:05:43 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,824,1400050800"; 
   d="scan'208";a="581915924"
Date: Fri, 8 Aug 2014 14:05:37 +0300
From: Heikki Krogerus <heikki.krogerus@linux.intel.com>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Tony Lindgren <tony@atomide.com>, Felipe Balbi <balbi@ti.com>,
        linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org
Subject: Re: [PATCH 6/6] tty: serial: Add 8250-core based omap driver
Message-ID: <20140808110537.GA29184@xps8300>
References: <1404928177-26554-1-git-send-email-bigeasy@linutronix.de>
 <1404928177-26554-7-git-send-email-bigeasy@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1404928177-26554-7-git-send-email-bigeasy@linutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 09, 2014 at 07:49:37PM +0200, Sebastian Andrzej Siewior wrote:
> diff --git a/drivers/tty/serial/8250/8250_core.c b/drivers/tty/serial/8250/8250_core.c
> index bf06a4c..1cbfc8c 100644
> --- a/drivers/tty/serial/8250/8250_core.c
> +++ b/drivers/tty/serial/8250/8250_core.c
> @@ -263,6 +263,12 @@ static const struct serial8250_config uart_config[] = {
>  		.fcr		= UART_FCR_ENABLE_FIFO | UART_FCR_R_TRIG_10,
>  		.flags		= UART_CAP_FIFO | UART_CAP_AFE,
>  	},
> +	[PORT_OMAP_16750] = {
> +		.name		= "OMAP",
> +		.fifo_size	= 64,
> +		.tx_loadsz	= 64,
> +		.flags		= UART_CAP_FIFO | UART_CAP_EFR | UART_CAP_SLEEP,
> +	},
>  	[PORT_TEGRA] = {
>  		.name		= "Tegra",
>  		.fifo_size	= 32,
> @@ -1340,6 +1346,8 @@ static void serial8250_stop_rx(struct uart_port *port)
>  	pm_runtime_get_sync(port->dev);
>  
>  	up->ier &= ~UART_IER_RLSI;
> +	if (port->type == PORT_OMAP_16750)
> +		up->ier &= ~UART_IER_RDI;
>  	up->port.read_status_mask &= ~UART_LSR_DR;
>  	serial_port_out(port, UART_IER, up->ier);

Alan couldn't UART_IER_RDI be always cleared here with all port types?
Actually, shouldn't it be?

Then the custom port type PORT_OMAP_16750 would not be needed.

-- 
heikki
