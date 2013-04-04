Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759565Ab3DDMHD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 08:07:03 -0400
Received: from mail.active-venture.com ([67.228.131.205]:61342 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759439Ab3DDMHA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 08:07:00 -0400
X-Originating-IP: 108.223.40.66
Date: Thu, 4 Apr 2013 05:07:07 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Mike Frysinger <vapier@gentoo.org>, Jonathan Cameron <jic23@cam.ac.uk>,
        Michael Hennerich <michael.hennerich@analog.com>,
        uclinux-dist-devel@blackfin.uclinux.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Blackfin: bf537: rename "CONFIG_AD7314"
Message-ID: <20130404120707.GA27590@roeck-us.net>
References: <1365070105.1830.21.camel@x61.thuisdomein>
 <1365070623.1830.24.camel@x61.thuisdomein>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1365070623.1830.24.camel@x61.thuisdomein>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 04, 2013 at 12:17:03PM +0200, Paul Bolle wrote:
> [Forwarded to a recent address of Guenter, as the ericsson address
> bounces.]
> 
> Paul Bolle
> 
> On Thu, 2013-04-04 at 12:08 +0200, Paul Bolle wrote:
> > In v3.2 the Analog Devices AD7314 temperature sensor driver was removed
> > as an IIO driver and added as a HWMON driver. But it was apparently
> > overlooked to rename two references to CONFIG_AD7314 to
> > CONFIG_SENSORS_AD7314. Do so now. Use the IS_ENABLED() macro, while
> > we're at it.
> > 
> > Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
> > ---
> > 0) Entirely untested.
> > 
> > 1) See commits 4f3a659581cabf1be441d6467b523be914615496 ("hwmon: AD7314
> > driver (ported from IIO)") and 48a2c3799b7141c271a771d3249142a104faeefc
> > ("staging:iio:adc:ad7314 removal. Supported via hwmon.") for the two
> > patches involved.
> > 
> >  arch/blackfin/mach-bf537/boards/stamp.c | 4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> > 
> > diff --git a/arch/blackfin/mach-bf537/boards/stamp.c b/arch/blackfin/mach-bf537/boards/stamp.c
> > index 23bb55d..b40b849 100644
> > --- a/arch/blackfin/mach-bf537/boards/stamp.c
> > +++ b/arch/blackfin/mach-bf537/boards/stamp.c
> > @@ -681,7 +681,7 @@ static struct bfin5xx_spi_chip ad2s1210_spi_chip_info = {
> >  };
> >  #endif
> >  
> > -#if defined(CONFIG_AD7314) || defined(CONFIG_AD7314_MODULE)
> > +#if IS_ENABLED(CONFIG_SENSORS_AD7314)
> >  static struct bfin5xx_spi_chip ad7314_spi_chip_info = {
> >  	.enable_dma = 0,
> >  };
> > @@ -1039,7 +1039,7 @@ static struct spi_board_info bfin_spi_board_info[] __initdata = {
> >  	},
> >  #endif
> >  
> > -#if defined(CONFIG_AD7314) || defined(CONFIG_AD7314_MODULE)
> > +#if IS_ENABLED(CONFIG_SENSORS_AD7314)
> >  	{
> >  		.modalias = "ad7314",
> >  		.max_speed_hz = 1000000,
> 
Acked-by: Guenter Roeck <linux@roeck-us.net>

Really wonder ... there should be a better solution than all those ifdefs.

Guenter
