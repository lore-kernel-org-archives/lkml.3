Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751020AbaKFAMm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 19:12:42 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:37157 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750844AbaKFAMl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 19:12:41 -0500
Date: Wed, 5 Nov 2014 16:12:40 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Cc: Jiri Slaby <jslaby@suse.cz>, linux-kernel@vger.kernel.org,
        alan@linux.intel.com
Subject: Re: [PATCH] goldfish: fixed sparse warning
Message-ID: <20141106001240.GA2440@kroah.com>
References: <1412949525-17561-1-git-send-email-sudipm.mukherjee@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1412949525-17561-1-git-send-email-sudipm.mukherjee@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 10, 2014 at 07:28:45PM +0530, Sudip Mukherjee wrote:
> fixed sparse warning of Using plain integer as NULL pointer
> 
> Signed-off-by: Sudip Mukherjee <sudip@vectorindia.org>
> ---
>  drivers/tty/goldfish.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/tty/goldfish.c b/drivers/tty/goldfish.c
> index 09495f5..c24b963 100644
> --- a/drivers/tty/goldfish.c
> +++ b/drivers/tty/goldfish.c
> @@ -157,7 +157,7 @@ static int goldfish_tty_console_setup(struct console *co, char *options)
>  {
>  	if ((unsigned)co->index > goldfish_tty_line_count)
>  		return -ENODEV;
> -	if (goldfish_ttys[co->index].base == 0)
> +	if (!goldfish_ttys[co->index].base)
>  		return -ENODEV;
>  	return 0;
>  }
> @@ -317,7 +317,7 @@ static int goldfish_tty_remove(struct platform_device *pdev)
>  	unregister_console(&qtty->console);
>  	tty_unregister_device(goldfish_tty_driver, pdev->id);
>  	iounmap(qtty->base);
> -	qtty->base = 0;
> +	qtty->base = NULL;
>  	free_irq(qtty->irq, pdev);
>  	goldfish_tty_current_line_count--;
>  	if (goldfish_tty_current_line_count == 0)
> -- 
> 1.8.1.2

Sorry, but someone else sent this same patch before you did :(

greg k-h
