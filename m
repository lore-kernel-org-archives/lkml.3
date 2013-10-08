Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753480Ab3JHDD7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 23:03:59 -0400
Received: from mail-lb0-f179.google.com ([209.85.217.179]:37250 "EHLO
	mail-lb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751534Ab3JHDD5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 23:03:57 -0400
MIME-Version: 1.0
In-Reply-To: <1381040838-12748-1-git-send-email-michael.opdenacker@free-electrons.com>
References: <1381040838-12748-1-git-send-email-michael.opdenacker@free-electrons.com>
Date: Tue, 8 Oct 2013 11:03:56 +0800
Message-ID: <CAJxxZ0MpB7Ry5uRsoU=YgJTjrLQQyCdc8QS_x71brJpVfrTwMA@mail.gmail.com>
Subject: Re: [PATCH] serial: bfin_uart: remove deprecated IRQF_DISABLED
From: Sonic Zhang <sonic.adi@gmail.com>
To: Michael Opdenacker <michael.opdenacker@free-electrons.com>
Cc: "Zhang, Sonic" <sonic.zhang@analog.com>,
        Greg KH <gregkh@linuxfoundation.org>, Jiri Slaby <jslaby@suse.cz>,
        uclinux-dist-devel <uclinux-dist-devel@blackfin.uclinux.org>,
        Linux Serial <linux-serial@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Acked-by: Sonic Zhang <sonc.zhang@analog.com>

On Sun, Oct 6, 2013 at 2:27 PM, Michael Opdenacker
<michael.opdenacker@free-electrons.com> wrote:
> This patch proposes to remove the use of the IRQF_DISABLED flag
>
> It's a NOOP since 2.6.35 and it will be removed one day.
>
> Signed-off-by: Michael Opdenacker <michael.opdenacker@free-electrons.com>
> ---
>  drivers/tty/serial/bfin_uart.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/tty/serial/bfin_uart.c b/drivers/tty/serial/bfin_uart.c
> index 3c75e8e..5e85f35 100644
> --- a/drivers/tty/serial/bfin_uart.c
> +++ b/drivers/tty/serial/bfin_uart.c
> @@ -726,7 +726,7 @@ static int bfin_serial_startup(struct uart_port *port)
>  #ifdef CONFIG_SERIAL_BFIN_HARD_CTSRTS
>         if (uart->cts_pin >= 0) {
>                 if (request_irq(uart->status_irq, bfin_serial_mctrl_cts_int,
> -                       IRQF_DISABLED, "BFIN_UART_MODEM_STATUS", uart)) {
> +                       0, "BFIN_UART_MODEM_STATUS", uart)) {
>                         uart->cts_pin = -1;
>                         dev_info(port->dev, "Unable to attach BlackFin UART Modem Status interrupt.\n");
>                 }
> --
> 1.8.1.2
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
