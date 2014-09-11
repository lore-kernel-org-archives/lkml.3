Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754490AbaIKLTi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 07:19:38 -0400
Received: from mga01.intel.com ([192.55.52.88]:22352 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754413AbaIKLTf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 07:19:35 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,505,1406617200"; 
   d="scan'208";a="476860996"
Date: Thu, 11 Sep 2014 14:19:31 +0300
From: Heikki Krogerus <heikki.krogerus@linux.intel.com>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        tony@atomide.com, balbi@ti.com, gregkh@linuxfoundation.org
Subject: Re: [PATCH 05/16] tty: serial: 8250_core: remove UART_IER_RDI in
 serial8250_stop_rx()
Message-ID: <20140911111931.GC17476@xps8300>
References: <1410377411-26656-1-git-send-email-bigeasy@linutronix.de>
 <1410377411-26656-6-git-send-email-bigeasy@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1410377411-26656-6-git-send-email-bigeasy@linutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 10, 2014 at 09:30:00PM +0200, Sebastian Andrzej Siewior wrote:
> serial8250_do_startup() adds UART_IER_RDI and UART_IER_RLSI to ier.
> serial8250_stop_rx() should remove both.
> This is what the serial-omap driver has been doing and is now moved to
> the 8250-core since it does no look to be *that* omap specific.
> 
> Cc: heikki.krogerus@linux.intel.com

Looks good to me. FWIW...

Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>

> Reviewed-by: Tony Lindgren <tony@atomide.com>
> Tested-by: Tony Lindgren <tony@atomide.com>
> Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> ---
>  drivers/tty/serial/8250/8250_core.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/tty/serial/8250/8250_core.c b/drivers/tty/serial/8250/8250_core.c
> index ac88e66df65d..139f3d2b8aa9 100644
> --- a/drivers/tty/serial/8250/8250_core.c
> +++ b/drivers/tty/serial/8250/8250_core.c
> @@ -1390,7 +1390,7 @@ static void serial8250_stop_rx(struct uart_port *port)
>  
>  	serial8250_rpm_get(up);
>  
> -	up->ier &= ~UART_IER_RLSI;
> +	up->ier &= ~(UART_IER_RLSI | UART_IER_RDI);
>  	up->port.read_status_mask &= ~UART_LSR_DR;
>  	serial_port_out(port, UART_IER, up->ier);
>  
> -- 
> 2.1.0

Thanks,

-- 
heikki
