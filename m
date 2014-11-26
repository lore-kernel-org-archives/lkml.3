Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753029AbaKZR01 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 12:26:27 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:38917 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750837AbaKZR0Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 12:26:25 -0500
Date: Wed, 26 Nov 2014 09:26:24 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Arianna Avanzini <avanzini.arianna@gmail.com>
Cc: jslaby@suse.cz, linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org
Subject: Re: [PATCH] tty, serial, 8250: remove __init from function
 serial8250_console_setup()
Message-ID: <20141126172624.GA2816@kroah.com>
References: <20141125175121.GA32573@kroah.com>
 <1416954082-1755-1-git-send-email-avanzini.arianna@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1416954082-1755-1-git-send-email-avanzini.arianna@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 25, 2014 at 11:21:22PM +0100, Arianna Avanzini wrote:
> Some RS232 adapters handled by this driver are hotpluggable. The function
> serial8250_console_setup() is called during device init and is defined with
> the __init macro. In case the driver is built-in, hotplugging the device after
> the initialization phase has been completed (and the related memory has been
> freed) results in a kernel crash.
> This commit fixes the issue by removing __init from the function definition.
> 
> Signed-off-by: Arianna Avanzini <avanzini.arianna@gmail.com>
> ---
>  drivers/tty/serial/8250/8250_core.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/tty/serial/8250/8250_core.c b/drivers/tty/serial/8250/8250_core.c
> index ca5cfdc..ca8108d 100644
> --- a/drivers/tty/serial/8250/8250_core.c
> +++ b/drivers/tty/serial/8250/8250_core.c
> @@ -3237,7 +3237,7 @@ serial8250_console_write(struct console *co, const char *s, unsigned int count)
>  	serial8250_rpm_put(up);
>  }
>  
> -static int __init serial8250_console_setup(struct console *co, char *options)
> +static int serial8250_console_setup(struct console *co, char *options)
>  {
>  	struct uart_port *port;
>  	int baud = 9600;
> -- 
> 2.1.3

This has already been in my tree for a long time, always work against
linux-next to avoid redoing work that others have already done.

thanks,

greg k-h
