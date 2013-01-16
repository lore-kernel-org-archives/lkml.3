Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757405Ab3APCtb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 21:49:31 -0500
Received: from mail.kernel.org ([198.145.19.201]:59089 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756106Ab3APCt3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 21:49:29 -0500
Date: Tue, 15 Jan 2013 18:50:28 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: chao bi <chao.bi@intel.com>
Cc: Alan Cox <alan@linux.intel.com>, richardx.r.gorby@intel.com,
        jun.d.chen@intel.com, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] serial:ifx6x60:Keep word size accordance with SPI
 controller
Message-ID: <20130116025028.GA29056@kroah.com>
References: <1355288826.30354.237.camel@bichao>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1355288826.30354.237.camel@bichao>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 12, 2012 at 01:07:06PM +0800, chao bi wrote:
> 
> As protocol driver, IFX SPI driver initiate to setup SPI master with default
> SPI word size as 16 bit/word, however, SPI master may not adopt this default
> value due to SPI controller's capability, it might choose an available value by
> itself and set it to spi_device.bits_per_word. In order to keep align with
> Controller, IFX driver should make use of this value during SPI transfer,
> but the default one.
> 
> Signed-off-by: Chen Jun <jun.d.chen@intel.com>
> Signed-off-by: channing <chao.bi@intel.com>
> ---
>  drivers/tty/serial/ifx6x60.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/tty/serial/ifx6x60.c b/drivers/tty/serial/ifx6x60.c
> index 675d94a..5919992 100644
> --- a/drivers/tty/serial/ifx6x60.c
> +++ b/drivers/tty/serial/ifx6x60.c
> @@ -810,7 +810,8 @@ static void ifx_spi_io(unsigned long data)
>  		ifx_dev->spi_xfer.cs_change = 0;
>  		ifx_dev->spi_xfer.speed_hz = ifx_dev->spi_dev->max_speed_hz;
>  		/* ifx_dev->spi_xfer.speed_hz = 390625; */
> -		ifx_dev->spi_xfer.bits_per_word = spi_bpw;
> +		ifx_dev->spi_xfer.bits_per_word =
> +		ifx_dev->spi_dev->bits_per_word;

Please follow the proper coding style (hint, this isn't it.)

thanks,

greg k-h
