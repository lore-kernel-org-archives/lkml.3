Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753950AbaKDOHb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 09:07:31 -0500
Received: from mail-pd0-f172.google.com ([209.85.192.172]:47999 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752557AbaKDOH3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 09:07:29 -0500
Date: Tue, 4 Nov 2014 19:37:12 +0530
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>
Cc: linux-kernel@vger.kernel.org, alan@linux.intel.com
Subject: Re: [PATCH] goldfish: fixed sparse warning
Message-ID: <20141104140712.GA8334@sudip-PC>
References: <1412949525-17561-1-git-send-email-sudipm.mukherjee@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1412949525-17561-1-git-send-email-sudipm.mukherjee@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
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
> 
a gentle ping

thanks
sudip
