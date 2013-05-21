Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753010Ab3EUHqp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 May 2013 03:46:45 -0400
Received: from mail.servclub.de ([46.4.228.165]:51557 "EHLO mail.servclub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751574Ab3EUHqm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 May 2013 03:46:42 -0400
X-Greylist: delayed 1692 seconds by postgrey-1.27 at vger.kernel.org; Tue, 21 May 2013 03:46:42 EDT
Message-ID: <1369120690.1945.9.camel@bne>
Subject: Re: [PATCH] tty: nwpserial: Pass correct pointer to free_irq()
From: Benjamin Krill <ben@codiert.org>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Tue, 21 May 2013 09:18:10 +0200
In-Reply-To: <1369069650-1742-1-git-send-email-lars@metafoo.de>
References: <1369069650-1742-1-git-send-email-lars@metafoo.de>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Acked-off-by: Benjamin Krill <ben@codiert.org>

On Mon, 2013-05-20 at 19:07 +0200, Lars-Peter Clausen wrote:
> free_irq() expects the same pointer that was passed to request_irq(), otherwise
> the IRQ is not freed.
> 
> The issue was found using the following coccinelle script:
> 
> <smpl>
> @r1@
> type T;
> T devid;
> @@
> request_irq(..., devid)
> 
> @r2@
> type r1.T;
> T devid;
> position p;
> @@
> free_irq@p(..., devid)
> 
> @@
> position p != r2.p;
> @@
> *free_irq@p(...)
> </smpl>
> 
> Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
> ---
>  drivers/tty/serial/nwpserial.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/tty/serial/nwpserial.c b/drivers/tty/serial/nwpserial.c
> index 77287c5..549c70a 100644
> --- a/drivers/tty/serial/nwpserial.c
> +++ b/drivers/tty/serial/nwpserial.c
> @@ -199,7 +199,7 @@ static void nwpserial_shutdown(struct uart_port *port)
>  	dcr_write(up->dcr_host, UART_IER, up->ier);
>  
>  	/* free irq */
> -	free_irq(up->port.irq, port);
> +	free_irq(up->port.irq, up);
>  }
>  
>  static int nwpserial_verify_port(struct uart_port *port,


