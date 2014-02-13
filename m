Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753843AbaBMKIQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 05:08:16 -0500
Received: from cpsmtpb-ews08.kpnxchange.com ([213.75.39.13]:60438 "EHLO
	cpsmtpb-ews08.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751744AbaBMKIN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 05:08:13 -0500
Message-ID: <1392286091.30853.35.camel@x220>
Subject: Re: [PATCH] Blackfin: bf537: rename "CONFIG_AD7314"
From: Paul Bolle <pebolle@tiscali.nl>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Steven Miao <realmz6@gmail.com>, Jonathan Cameron <jic23@cam.ac.uk>,
        Michael Hennerich <michael.hennerich@analog.com>,
        adi-buildroot-devel@lists.sourceforge.net,
        linux-kernel@vger.kernel.org
Date: Thu, 13 Feb 2014 11:08:11 +0100
In-Reply-To: <20130404120707.GA27590@roeck-us.net>
References: <1365070105.1830.21.camel@x61.thuisdomein>
	 <1365070623.1830.24.camel@x61.thuisdomein>
	 <20130404120707.GA27590@roeck-us.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.3 (3.10.3-1.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 13 Feb 2014 10:08:11.0356 (UTC) FILETIME=[804109C0:01CF28A3]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Replaced previous maintainer and list with current maintainer and
list.]

On Thu, 2013-04-04 at 05:07 -0700, Guenter Roeck wrote:
> On Thu, Apr 04, 2013 at 12:17:03PM +0200, Paul Bolle wrote:
> > [Forwarded to a recent address of Guenter, as the ericsson address
> > bounces.]
> > 
> > Paul Bolle
> > 
> > On Thu, 2013-04-04 at 12:08 +0200, Paul Bolle wrote:
> > > In v3.2 the Analog Devices AD7314 temperature sensor driver was removed
> > > as an IIO driver and added as a HWMON driver. But it was apparently
> > > overlooked to rename two references to CONFIG_AD7314 to
> > > CONFIG_SENSORS_AD7314. Do so now. Use the IS_ENABLED() macro, while
> > > we're at it.
> > > 
> > > Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
> > > ---
> > > 0) Entirely untested.
> > > 
> > > 1) See commits 4f3a659581cabf1be441d6467b523be914615496 ("hwmon: AD7314
> > > driver (ported from IIO)") and 48a2c3799b7141c271a771d3249142a104faeefc
> > > ("staging:iio:adc:ad7314 removal. Supported via hwmon.") for the two
> > > patches involved.
> > > 
> > >  arch/blackfin/mach-bf537/boards/stamp.c | 4 ++--
> > >  1 file changed, 2 insertions(+), 2 deletions(-)
> > > 
> > > diff --git a/arch/blackfin/mach-bf537/boards/stamp.c b/arch/blackfin/mach-bf537/boards/stamp.c
> > > index 23bb55d..b40b849 100644
> > > --- a/arch/blackfin/mach-bf537/boards/stamp.c
> > > +++ b/arch/blackfin/mach-bf537/boards/stamp.c
> > > @@ -681,7 +681,7 @@ static struct bfin5xx_spi_chip ad2s1210_spi_chip_info = {
> > >  };
> > >  #endif
> > >  
> > > -#if defined(CONFIG_AD7314) || defined(CONFIG_AD7314_MODULE)
> > > +#if IS_ENABLED(CONFIG_SENSORS_AD7314)
> > >  static struct bfin5xx_spi_chip ad7314_spi_chip_info = {
> > >  	.enable_dma = 0,
> > >  };
> > > @@ -1039,7 +1039,7 @@ static struct spi_board_info bfin_spi_board_info[] __initdata = {
> > >  	},
> > >  #endif
> > >  
> > > -#if defined(CONFIG_AD7314) || defined(CONFIG_AD7314_MODULE)
> > > +#if IS_ENABLED(CONFIG_SENSORS_AD7314)
> > >  	{
> > >  		.modalias = "ad7314",
> > >  		.max_speed_hz = 1000000,
> > 
> Acked-by: Guenter Roeck <linux@roeck-us.net>
> 
> Really wonder ... there should be a better solution than all those ifdefs.

This issue is still present in v3.14-rc2. Can someone please have
(another) look at this?


Paul Bolle 

