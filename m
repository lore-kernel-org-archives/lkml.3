Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932726AbaJVIDs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 04:03:48 -0400
Received: from www.linutronix.de ([62.245.132.108]:34754 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932301AbaJVIDl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 04:03:41 -0400
Message-ID: <544764D8.8050804@linutronix.de>
Date: Wed, 22 Oct 2014 10:03:36 +0200
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.1.2
MIME-Version: 1.0
To: Nishanth Menon <nm@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Tony Lindgren <tony@atomide.com>
CC: linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
        Jiri Slaby <jslaby@suse.cz>, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        "Franklin Cooper Jr." <fcooper@ti.com>
Subject: Re: [PATCH] tty: serial: omap: increase max consoles to 10
References: <1413908616-843-1-git-send-email-nm@ti.com>
In-Reply-To: <1413908616-843-1-git-send-email-nm@ti.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/21/2014 06:23 PM, Nishanth Menon wrote:
> 
> The final solution is to transition off to use 8250 driver and no
> dependency on console structures and move away from omap-serial driver,
> hence no major cleanups are done for this driver.

So the shiny new driver works for you, is this what you are saying?

> diff --git a/drivers/tty/serial/omap-serial.c b/drivers/tty/serial/omap-serial.c
> index 18c30ca..4f9cbb6 100644
> --- a/drivers/tty/serial/omap-serial.c
> +++ b/drivers/tty/serial/omap-serial.c
> @@ -46,7 +46,7 @@
>  
>  #include <dt-bindings/gpio/gpio.h>
>  
> -#define OMAP_MAX_HSUART_PORTS	6
> +#define OMAP_MAX_HSUART_PORTS	10
>  
>  #define UART_BUILD_REVISION(x, y)	(((x) << 8) | (y))

Please also add a check in the probe code that "up->port.line" does not
exceed OMAP_MAX_HSUART_PORTS again. So we leave the probe function with
an error code instead.

Sebastian
