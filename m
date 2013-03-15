Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755389Ab3COOgp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 10:36:45 -0400
Received: from eusmtp01.atmel.com ([212.144.249.242]:60733 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755166Ab3COOgo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 10:36:44 -0400
Message-ID: <514331F6.6070204@atmel.com>
Date: Fri, 15 Mar 2013 15:36:38 +0100
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: Pawel Wieczorkiewicz <wpawel@gmail.com>, <gregkh@linuxfoundation.org>,
        <jslaby@suse.cz>
CC: <grant.likely@secretlab.ca>, <linux-serial@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/1] tty: atmel_serial_probe(): index of atmel_ports[]
 fix
References: <1361377580-10437-1-git-send-email-wpawel@gmail.com>
In-Reply-To: <1361377580-10437-1-git-send-email-wpawel@gmail.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/20/2013 05:26 PM, Pawel Wieczorkiewicz :
> From: Pawel Wieczorkiewicz <wpawel@gmail.com>
> 
> Index of atmel_ports[ATMEL_MAX_UART] should be smaller
> than ATMEL_MAX_UART.
> 
> Signed-off-by: Pawel Wieczorkiewicz <wpawel@gmail.com>

Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>

It can be good to include this one in 3.9-rc.

I also would like to add the "stable" tag to it:

Cc: stable <stable@vger.kernel.org> # 3.2+

Greg, can you take this one or do I need to re-send it with appropriate
"stable" line?

Thanks, best regards,

> ---
>  drivers/tty/serial/atmel_serial.c |   11 +++++------
>  1 file changed, 5 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/tty/serial/atmel_serial.c b/drivers/tty/serial/atmel_serial.c
> index d4a7c24..3467462 100644
> --- a/drivers/tty/serial/atmel_serial.c
> +++ b/drivers/tty/serial/atmel_serial.c
> @@ -158,7 +158,7 @@ struct atmel_uart_port {
>  };
>  
>  static struct atmel_uart_port atmel_ports[ATMEL_MAX_UART];
> -static unsigned long atmel_ports_in_use;
> +static DECLARE_BITMAP(atmel_ports_in_use, ATMEL_MAX_UART);
>  
>  #ifdef SUPPORT_SYSRQ
>  static struct console atmel_console;
> @@ -1769,15 +1769,14 @@ static int atmel_serial_probe(struct platform_device *pdev)
>  	if (ret < 0)
>  		/* port id not found in platform data nor device-tree aliases:
>  		 * auto-enumerate it */
> -		ret = find_first_zero_bit(&atmel_ports_in_use,
> -				sizeof(atmel_ports_in_use));
> +		ret = find_first_zero_bit(atmel_ports_in_use, ATMEL_MAX_UART);
>  
> -	if (ret > ATMEL_MAX_UART) {
> +	if (ret >= ATMEL_MAX_UART) {
>  		ret = -ENODEV;
>  		goto err;
>  	}
>  
> -	if (test_and_set_bit(ret, &atmel_ports_in_use)) {
> +	if (test_and_set_bit(ret, atmel_ports_in_use)) {
>  		/* port already in use */
>  		ret = -EBUSY;
>  		goto err;
> @@ -1857,7 +1856,7 @@ static int atmel_serial_remove(struct platform_device *pdev)
>  
>  	/* "port" is allocated statically, so we shouldn't free it */
>  
> -	clear_bit(port->line, &atmel_ports_in_use);
> +	clear_bit(port->line, atmel_ports_in_use);
>  
>  	clk_put(atmel_port->clk);
>  
> 


-- 
Nicolas Ferre
