Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754145AbaDYOZB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 10:25:01 -0400
Received: from mail-yh0-f50.google.com ([209.85.213.50]:58536 "EHLO
	mail-yh0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752901AbaDYOY6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 10:24:58 -0400
Date: Fri, 25 Apr 2014 10:24:30 -0400 (EDT)
From: Charles Coldwell <coldwell@gmail.com>
To: Jon Ringle <jon@ringle.org>
cc: Charles Coldwell <coldwell@gmail.com>,
        "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        Alexander Shiyan <shc_work@mail.ru>,
        Jon Ringle <jringle@gridpoint.com>
Subject: Re: [PATCH v7 1/2] serial: sc16is7xx
In-Reply-To: <CAMwGMjyqiC1DLKfz0LUFg-iN8mDKc54w+8AYKFHOydiwtXHrFQ@mail.gmail.com>
Message-ID: <alpine.LRH.2.03.1404251019300.2893@frank.harvard.edu>
References: <1398387367-4047-1-git-send-email-jon@ringle.org> <alpine.LRH.2.03.1404250914380.30160@frank.harvard.edu> <alpine.LRH.2.03.1404250941590.2625@frank.harvard.edu> <CAMwGMjyqiC1DLKfz0LUFg-iN8mDKc54w+8AYKFHOydiwtXHrFQ@mail.gmail.com>
User-Agent: Alpine 2.03 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 25 Apr 2014, Jon Ringle wrote:

> On Fri, Apr 25, 2014 at 9:44 AM, Charles Coldwell <coldwell@gmail.com> wrote:
> > On Fri, 25 Apr 2014, Charles Coldwell wrote:
> >
> >> On Thu, 24 Apr 2014, jon@ringle.org wrote:
> >>
> >> > diff --git a/drivers/tty/serial/sc16is7xx.c b/drivers/tty/serial/sc16is7xx.c
> >>
> >> Isn't this a lot of duplication?
> >
> > Actually, the whole thing seems like duplication to me.
> 
> The fact that we need to reach over the SPI/I2C bus makes a big
> difference in the way access is handled.
> 
> To achieve acceptable throughput, it is necessary to use threaded irq
> and also bulk i2c transfers for RX and TX using
> regmap_raw_{read,write}() to optimize the use of the i2c bus.

Fair enough, but the 8250 framework does allow you to insert your own
irq service routine. "serial8250_default_handle_irq" is the default
(unsurprisingly), but if the uart_port has a non-NULL "handle_irq"
method it will be faithfully copied into the uart_8250_port
"handle_irq" method in 8250_core.c:early_serial_setup.

> This is not a good fit for 8250.

If that's really true, then I would say it argues in favor of a
revision of the 8250 code.  Certainly, this is not the last time that
a 16550-compatible UART will appear on a non-PCI, non-ISA bus.

-- 
Charles M. Coldwell, W1CMC
"Turn on, log in, tune out"
Somerville, Massachusetts, New England (FN42kj)

GPG ID:  852E052F
GPG FPR: 77E5 2B51 4907 F08A 7E92  DE80 AFA9 9A8F 852E 052F
