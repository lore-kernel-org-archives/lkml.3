Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751479AbaKYR4c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 12:56:32 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:47934 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751374AbaKYR4A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 12:56:00 -0500
Date: Tue, 25 Nov 2014 09:51:21 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Arianna Avanzini <avanzini.arianna@gmail.com>
Cc: jslaby@suse.cz, linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org
Subject: Re: [PATCH RFC] tty, serial, 8250: remove __init from function
 serial8250_console_setup()
Message-ID: <20141125175121.GA32573@kroah.com>
References: <1416506456-2126-1-git-send-email-avanzini.arianna@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1416506456-2126-1-git-send-email-avanzini.arianna@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 20, 2014 at 07:00:56PM +0100, Arianna Avanzini wrote:
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

I don't apply "RFC" patches as it implies you don't even know if this
works or not.
