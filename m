Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752758AbaDYNxd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 09:53:33 -0400
Received: from mail-yh0-f51.google.com ([209.85.213.51]:34506 "EHLO
	mail-yh0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751213AbaDYNxa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 09:53:30 -0400
X-Google-Original-From: Charles Coldwell <coldwell@frank.harvard.edu>
Date: Fri, 25 Apr 2014 09:44:52 -0400 (EDT)
From: Charles Coldwell <coldwell@gmail.com>
To: Charles Coldwell <coldwell@gmail.com>
cc: jon@ringle.org, linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        gregkh@linuxfoundation.org, shc_work@mail.ru,
        Jon Ringle <jringle@gridpoint.com>
Subject: Re: [PATCH v7 1/2] serial: sc16is7xx
In-Reply-To: <alpine.LRH.2.03.1404250914380.30160@frank.harvard.edu>
Message-ID: <alpine.LRH.2.03.1404250941590.2625@frank.harvard.edu>
References: <1398387367-4047-1-git-send-email-jon@ringle.org> <alpine.LRH.2.03.1404250914380.30160@frank.harvard.edu>
User-Agent: Alpine 2.03 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 25 Apr 2014, Charles Coldwell wrote:

> On Thu, 24 Apr 2014, jon@ringle.org wrote:
> 
> > diff --git a/drivers/tty/serial/sc16is7xx.c b/drivers/tty/serial/sc16is7xx.c
> > new file mode 100644
> > index 0000000..ed139f5
> > --- /dev/null
> > +++ b/drivers/tty/serial/sc16is7xx.c
> 
> > +
> > +/* SC16IS7XX register definitions */
> > +#define SC16IS7XX_RHR_REG		(0x00) /* RX FIFO */
> > +#define SC16IS7XX_THR_REG		(0x00) /* TX FIFO */
> > +#define SC16IS7XX_IER_REG		(0x01) /* Interrupt enable */
> > +#define SC16IS7XX_IIR_REG		(0x02) /* Interrupt Identification */
> > +#define SC16IS7XX_FCR_REG		(0x02) /* FIFO control */
> > +#define SC16IS7XX_LCR_REG		(0x03) /* Line Control */
> > +#define SC16IS7XX_MCR_REG		(0x04) /* Modem Control */
> > +#define SC16IS7XX_LSR_REG		(0x05) /* Line Status */
> > +#define SC16IS7XX_MSR_REG		(0x06) /* Modem Status */
> > +#define SC16IS7XX_SPR_REG		(0x07) /* Scratch Pad */
> 
> Isn't this a lot of duplication?

Actually, the whole thing seems like duplication to me.  The SC16IS7X0 
parts are designed to be 16550-compatible (hence the duplication in the 
register map), and so I would vote for putting the driver into the 
drivers/tty/serial/8250 framework.  There's really not much difference 
between these parts and other 16550 parts except that they are reached 
over the SPI/I2C bus.

-- 
Charles M. Coldwell, W1CMC
"Turn on, log in, tune out"
Belmont, Massachusetts, New England (FN42jj)

GPG ID:  852E052F
GPG FPR: 77E5 2B51 4907 F08A 7E92  DE80 AFA9 9A8F 852E 052F
