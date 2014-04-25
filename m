Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754100AbaDYNVv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 09:21:51 -0400
Received: from mail-yh0-f51.google.com ([209.85.213.51]:42660 "EHLO
	mail-yh0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752005AbaDYNVq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 09:21:46 -0400
Date: Fri, 25 Apr 2014 09:21:26 -0400 (EDT)
From: Charles Coldwell <coldwell@gmail.com>
To: jon@ringle.org
cc: linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        gregkh@linuxfoundation.org, shc_work@mail.ru,
        Jon Ringle <jringle@gridpoint.com>
Subject: Re: [PATCH v7 1/2] serial: sc16is7xx
In-Reply-To: <1398387367-4047-1-git-send-email-jon@ringle.org>
Message-ID: <alpine.LRH.2.03.1404250914380.30160@frank.harvard.edu>
References: <1398387367-4047-1-git-send-email-jon@ringle.org>
User-Agent: Alpine 2.03 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 24 Apr 2014, jon@ringle.org wrote:

> diff --git a/drivers/tty/serial/sc16is7xx.c b/drivers/tty/serial/sc16is7xx.c
> new file mode 100644
> index 0000000..ed139f5
> --- /dev/null
> +++ b/drivers/tty/serial/sc16is7xx.c

> +
> +/* SC16IS7XX register definitions */
> +#define SC16IS7XX_RHR_REG		(0x00) /* RX FIFO */
> +#define SC16IS7XX_THR_REG		(0x00) /* TX FIFO */
> +#define SC16IS7XX_IER_REG		(0x01) /* Interrupt enable */
> +#define SC16IS7XX_IIR_REG		(0x02) /* Interrupt Identification */
> +#define SC16IS7XX_FCR_REG		(0x02) /* FIFO control */
> +#define SC16IS7XX_LCR_REG		(0x03) /* Line Control */
> +#define SC16IS7XX_MCR_REG		(0x04) /* Modem Control */
> +#define SC16IS7XX_LSR_REG		(0x05) /* Line Status */
> +#define SC16IS7XX_MSR_REG		(0x06) /* Modem Status */
> +#define SC16IS7XX_SPR_REG		(0x07) /* Scratch Pad */

Isn't this a lot of duplication?  We have already in 

/*
 * include/linux/serial_reg.h
 *
#define UART_RX		0	/* In:  Receive buffer */
#define UART_TX		0	/* Out: Transmit buffer */
#define UART_IER	1	/* Out: Interrupt Enable Register */
#define UART_IIR	2	/* In:  Interrupt ID Register */
#define UART_FCR	2	/* Out: FIFO Control Register */
#define UART_LCR	3	/* Out: Line Control Register */
#define UART_MCR	4	/* Out: Modem Control Register */
#define UART_LSR	5	/* In:  Line Status Register */
#define UART_MSR	6	/* In:  Modem Status Register */
#define UART_SCR	7	/* I/O: Scratch Register */

and the bit definitions, as well.


