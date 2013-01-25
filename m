Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755713Ab3AYAGt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 19:06:49 -0500
Received: from casper.infradead.org ([85.118.1.10]:41840 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754597Ab3AYAGs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 19:06:48 -0500
Message-ID: <5101CCD4.6020205@infradead.org>
Date: Thu, 24 Jan 2013 16:07:48 -0800
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130105 Thunderbird/17.0.2
MIME-Version: 1.0
To: Liang Li <liang.li@windriver.com>
CC: gregkh@linuxfoundation.org, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org, sfr@canb.auug.org.au,
        linux-next@vger.kernel.org
Subject: Re: [PATCH] serial: pch_uart: fix sysrq handling for pch_uart
References: <1359001887-1016-1-git-send-email-liang.li@windriver.com>
In-Reply-To: <1359001887-1016-1-git-send-email-liang.li@windriver.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/23/13 20:31, Liang Li wrote:
> When PCH_UART_CONSOLE and SERIAL_CORE_CONSOLE is not set neither, the
> uart_port will have no 'sysrq' member hence their will need a '#ifdef'
> in pch_uart.c to handle the case, otherwise we'll see compile error
> like this:
> 
>   CC [M]  drivers/tty/serial/pch_uart.o
> drivers/tty/serial/pch_uart.c: In function 'pch_uart_hal_read':
> drivers/tty/serial/pch_uart.c:572:11: error: 'struct uart_port' has no member named 'sysrq'
> make[4]: *** [drivers/tty/serial/pch_uart.o] Error 1
> 
> Reported-by: Randy Dunlap <rdunlap@infradead.org>
> CC: Stephen Rothwell <sfr@canb.auug.org.au>
> Signed-off-by: Liang Li <liang.li@windriver.com>

Acked-by: Randy Dunlap <rdunlap@infradead.org>

Thanks.

> ---
> Hi Greg,
> 
> This is for 'tty-next' of your tty tree. Thanks.
> 
>  drivers/tty/serial/pch_uart.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/tty/serial/pch_uart.c b/drivers/tty/serial/pch_uart.c
> index 1ddfc66..7a6c989 100644
> --- a/drivers/tty/serial/pch_uart.c
> +++ b/drivers/tty/serial/pch_uart.c
> @@ -569,10 +569,12 @@ static int pch_uart_hal_read(struct eg20t_port *priv, unsigned char *buf,
>  			if (uart_handle_break(port))
>  				continue;
>  		}
> +#ifdef SUPPORT_SYSRQ
>  		if (port->sysrq) {
>  			if (uart_handle_sysrq_char(port, rbr))
>  				continue;
>  		}
> +#endif
>  
>  		buf[i++] = rbr;
>  	}
> 


-- 
~Randy
