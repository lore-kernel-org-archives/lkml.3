Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935612Ab3BTPA5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 10:00:57 -0500
Received: from mail-ee0-f51.google.com ([74.125.83.51]:43866 "EHLO
	mail-ee0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757742Ab3BTPAy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 10:00:54 -0500
Message-ID: <5124E520.709@suse.cz>
Date: Wed, 20 Feb 2013 16:00:48 +0100
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:19.0) Gecko/20130124 Thunderbird/19.0
MIME-Version: 1.0
To: Pawel Wieczorkiewicz <wpawel@gmail.com>, nicolas.ferre@atmel.com,
        gregkh@linuxfoundation.org, grant.likely@secretlab.ca
CC: linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] tty: atmel_serial_probe(): index of atmel_ports[]
 fix
References: <1360711049-5557-1-git-send-email-wpawel@gmail.com>
In-Reply-To: <1360711049-5557-1-git-send-email-wpawel@gmail.com>
X-Enigmail-Version: 1.6a1pre
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/13/2013 12:17 AM, Pawel Wieczorkiewicz wrote:
> From: Pawel Wieczorkiewicz <wpawel@gmail.com>
> 
> Index of atmel_ports[ATMEL_MAX_UART] should be smaller
> than ATMEL_MAX_UART.
> 
> Signed-off-by: Pawel Wieczorkiewicz <wpawel@gmail.com>
> ---
>  drivers/tty/serial/atmel_serial.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/tty/serial/atmel_serial.c b/drivers/tty/serial/atmel_serial.c
> index d4a7c24..3f7586a 100644
> --- a/drivers/tty/serial/atmel_serial.c
> +++ b/drivers/tty/serial/atmel_serial.c
> @@ -1772,7 +1772,7 @@ static int atmel_serial_probe(struct platform_device *pdev)
>  		ret = find_first_zero_bit(&atmel_ports_in_use,
>  				sizeof(atmel_ports_in_use));
>  
> -	if (ret > ATMEL_MAX_UART) {
> +	if (!(ret < ATMEL_MAX_UART)) {

Good catch, but the result looks weird. Could you just make it ">="?

And find_first_zero_bit + sizeof above is bogus too. The sizeof returns
4 on 32-bit (the driver is run on 32bit machines exlusively AFAICS). So
the highest possible ret in there is 5. Instead atmel_ports_in_use
should be declared using DECLARE_BITMAP(atmel_ports_in_use,
ATMEL_MAX_UART) and the second parameter here then ATMEL_MAX_UART.

Could you fix that too?

-- 
js
suse labs
