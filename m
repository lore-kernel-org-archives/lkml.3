Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754044AbaG3Oh6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 10:37:58 -0400
Received: from mail-we0-f177.google.com ([74.125.82.177]:59919 "EHLO
	mail-we0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753367AbaG3Oh5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 10:37:57 -0400
Message-ID: <53D90340.3010000@suse.cz>
Date: Wed, 30 Jul 2014 16:37:52 +0200
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Sudip Mukherjee <sudipm.mukherjee@gmail.com>, gregkh@linuxfoundation.org
CC: linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] tty: serial: serial_core.c: printk replacement
References: <[PATCH] tty: serial: serial_core.c: printk replacement> <1406729236-19887-1-git-send-email-sudipm.mukherjee@gmail.com>
In-Reply-To: <1406729236-19887-1-git-send-email-sudipm.mukherjee@gmail.com>
Content-Type: text/plain; charset=iso-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/30/2014, 04:07 PM, Sudip Mukherjee wrote:
> printk replaced with corresponding dev_* 
> fixed two broken user-visible strings used by the corresponding printk
> 
> 
> Signed-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
> ---
>  drivers/tty/serial/serial_core.c | 19 ++++++++++---------
>  1 file changed, 10 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/tty/serial/serial_core.c b/drivers/tty/serial/serial_core.c
> index 8bb19da..ef48d0f 100644
> --- a/drivers/tty/serial/serial_core.c
> +++ b/drivers/tty/serial/serial_core.c
...
> @@ -1974,8 +1974,8 @@ int uart_suspend_port(struct uart_driver *drv, struct uart_port *uport)
>  		for (tries = 3; !ops->tx_empty(uport) && tries; tries--)
>  			msleep(10);
>  		if (!tries)
> -			printk(KERN_ERR "%s%s%s%d: Unable to drain "
> -					"transmitter\n",
> +			dev_err(uport->dev,
> +				"%s%s%s%d: Unable to drain transmitter\n",
>  			       uport->dev ? dev_name(uport->dev) : "",

Hi, this does not look correct. You use uport->dev, but there is a test
whether it is NULL in the parameters.

You would have to investigate if and when uport->dev can be NULL and
document it in the commit log above.

thanks,
-- 
js
suse labs
