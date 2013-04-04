Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759498Ab3DDMH0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 08:07:26 -0400
Received: from mail.active-venture.com ([67.228.131.205]:52351 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758615Ab3DDMHZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 08:07:25 -0400
X-Originating-IP: 108.223.40.66
Date: Thu, 4 Apr 2013 05:07:34 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Jean Delvare <khali@linux-fr.org>
Cc: Paul Bolle <pebolle@tiscali.nl>, Mike Frysinger <vapier@gentoo.org>,
        Michael Hennerich <michael.hennerich@analog.com>,
        Jonathan Cameron <jic23@cam.ac.uk>,
        uclinux-dist-devel@blackfin.uclinux.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Blackfin: bf537: rename "CONFIG_ADT75"
Message-ID: <20130404120734.GA23162@roeck-us.net>
References: <1365071466.1830.29.camel@x61.thuisdomein>
 <20130404134003.016dcee3@endymion.delvare>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130404134003.016dcee3@endymion.delvare>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 04, 2013 at 01:40:03PM +0200, Jean Delvare wrote:
> On Thu, 04 Apr 2013 12:31:06 +0200, Paul Bolle wrote:
> > In v3.2 the Analog Devices ADT75 temperature sensor driver was removed
> > as an IIO driver and support for it was added to the LM75 HWMON driver.
> > But it was apparently overlooked to rename one reference to CONFIG_ADT75
> > to CONFIG_SENSORS_LM75. Do so now. Use the IS_ENABLED() macro, while
> > we're at it.
> > 
> > Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
> > ---
> > 0) Also untested.
> > 
> > 1) See commits e96f9d89e6213c7630a3323cd0c754e7f2619564 ("hwmon: (lm75)
> > Add support for Analog Devices ADT75") and
> > cdea0bec8d37f2943ae500512b0c178bc76de6e3 ("iio: adc: remove ADT75 driver
> > - hwmon/lm75 will take over ADT75 support") for the two patches involved
> > in this operation.
> > 
> >  arch/blackfin/mach-bf537/boards/stamp.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> This breakage is telling us something about the weird approach taken in
> this file, methinks.
> 
Yes, they have persistent problems with renamed or moved drivers. I somewhat
understood the need for SPI chips, but even there it seemed to me there should
be a better solution.

> > diff --git a/arch/blackfin/mach-bf537/boards/stamp.c b/arch/blackfin/mach-bf537/boards/stamp.c
> > index b40b849..9735345 100644
> > --- a/arch/blackfin/mach-bf537/boards/stamp.c
> > +++ b/arch/blackfin/mach-bf537/boards/stamp.c
> > @@ -2221,7 +2221,7 @@ static struct i2c_board_info __initdata bfin_i2c_board_info[] = {
> >  	},
> >  #endif
> >  
> > -#if defined(CONFIG_ADT75) || defined(CONFIG_ADT75_MODULE)
> > +#if IS_ENABLED(CONFIG_SENSORS_LM75)
> >  	{
> >  		I2C_BOARD_INFO("adt75", 0x9),
> 
> Unrelated to this patch, but this is very odd, as the ADT75 can't have
> slave address 0x09. This address is almost exclusively used by battery
> chargers AFAIK.
> 
Either not really an ADT75, or it should have been 0x49.

Couple of lines down, CONFIG_ADT7410 has the same problem.

Guenter

> >  		.irq = IRQ_PG5,
> 
> The patch itself looks good.
> 
> Reviewed-by: Jean Delvare <khali@linux-fr.org>
> 
> -- 
> Jean Delvare
> 
