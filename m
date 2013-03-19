Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751223Ab3CSKuW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 06:50:22 -0400
Received: from mail.free-electrons.com ([94.23.35.102]:42886 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750784Ab3CSKuV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 06:50:21 -0400
Message-ID: <514842E9.401@free-electrons.com>
Date: Tue, 19 Mar 2013 11:50:17 +0100
From: Maxime Ripard <maxime.ripard@free-electrons.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: linux-arm-kernel@lists.infradead.org
CC: =?UTF-8?B?RW1pbGlvIEzDs3Bleg==?= <emilio@elopez.com.ar>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
        sunny@allwinnertech.com, shuge@allwinnertech.com,
        Jiri Slaby <jslaby@suse.cz>, kevin@allwinnertech.com
Subject: Re: [PATCH 1/7] serial: 8250_dw: add support for clk api
References: <1363689316-7847-1-git-send-email-maxime.ripard@free-electrons.com> <1363689316-7847-2-git-send-email-maxime.ripard@free-electrons.com>
In-Reply-To: <1363689316-7847-2-git-send-email-maxime.ripard@free-electrons.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Le 19/03/2013 11:35, Maxime Ripard a écrit :
> From: Emilio López <emilio@elopez.com.ar>
> 
> This commit implements support for using the clk api; this lets us use
> the "clocks" property with device tree, instead of having to use
> clock-frequency.
> 
> Signed-off-by: Emilio López <emilio@elopez.com.ar>
> ---
>  drivers/tty/serial/8250/8250_dw.c |   33 ++++++++++++++++++++++++---------
>  1 file changed, 24 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/tty/serial/8250/8250_dw.c b/drivers/tty/serial/8250/8250_dw.c
> index db0e66f..3dedd24 100644
> --- a/drivers/tty/serial/8250/8250_dw.c
> +++ b/drivers/tty/serial/8250/8250_dw.c
> @@ -26,6 +26,7 @@
>  #include <linux/platform_device.h>
>  #include <linux/slab.h>
>  #include <linux/acpi.h>
> +#include <linux/clk.h>
>  
>  #include "8250.h"
>  
> @@ -55,8 +56,9 @@
>  
>  
>  struct dw8250_data {
> -	int	last_lcr;
> -	int	line;
> +	int		last_lcr;
> +	int		line;
> +	struct clk	*clk;
>  };
>  
>  static void dw8250_serial_out(struct uart_port *p, int offset, int value)
> @@ -136,8 +138,13 @@ static int dw8250_probe_of(struct uart_port *p)
>  	if (!of_property_read_u32(np, "reg-shift", &val))
>  		p->regshift = val;
>  
> +	/* clock got configured through clk api, all done */
> +	if (IS_ERR(p->uartclk))

Hmm, I messed up here.

I'll resend a new version of this mail without this IS_ERR call

Maxime

-- 
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
