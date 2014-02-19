Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754994AbaBSUGr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 15:06:47 -0500
Received: from mail-wg0-f53.google.com ([74.125.82.53]:61455 "EHLO
	mail-wg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751851AbaBSUGp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 15:06:45 -0500
Message-ID: <53050ED0.40108@suse.cz>
Date: Wed, 19 Feb 2014 21:06:40 +0100
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Paul Gortmaker <paul.gortmaker@windriver.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alan Cox <alan@linux.intel.com>
Subject: Re: [PATCH] drivers/tty/serial: deal with 8250_core.c uninitialized
 warning for good
References: <1392840013-15957-1-git-send-email-paul.gortmaker@windriver.com>
In-Reply-To: <1392840013-15957-1-git-send-email-paul.gortmaker@windriver.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/19/2014 09:00 PM, Paul Gortmaker wrote:
> Every couple of months, someone sends a patch to fix:
> 
> drivers/tty/serial/8250/8250_core.c: In function 'serial_unlink_irq_chain':
> drivers/tty/serial/8250/8250_core.c:1712:2: warning: 'i' may be used uninitialized in this function [-Wuninitialized]
> 
> and they in turn get a NACK for their efforts, and are told that
> their compiler is broken.  This has been going on since at least
> the year 2008:  https://lkml.org/lkml/2008/11/24/433
> 
> Lets add a comment, so that subsequent patches don't get as far as
> the maintainers or the mailing lists.

Hi, wouldn't hlist_for_each_entry do a better job to silent both the
compiler and the reporters with the added value of cleanup?

> Cc: Alan Cox <alan@linux.intel.com>
> Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
> 
> diff --git a/drivers/tty/serial/8250/8250_core.c b/drivers/tty/serial/8250/8250_core.c
> index 69932b7556cf..747073b8c38a 100644
> --- a/drivers/tty/serial/8250/8250_core.c
> +++ b/drivers/tty/serial/8250/8250_core.c
> @@ -1694,6 +1694,10 @@ static int serial_link_irq_chain(struct uart_8250_port *up)
>  
>  static void serial_unlink_irq_chain(struct uart_8250_port *up)
>  {
> +	/*
> +	 * yes, some broken gcc emit "warning: 'i' may be used uninitialized"
> +	 * but no, we are not going to take a patch that assigns NULL below.
> +	 */
>  	struct irq_info *i;
>  	struct hlist_node *n;
>  	struct hlist_head *h;

thanks,
-- 
js
suse labs
