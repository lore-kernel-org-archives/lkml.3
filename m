Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754092AbaBMKPx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 05:15:53 -0500
Received: from cpsmtpb-ews01.kpnxchange.com ([213.75.39.4]:57043 "EHLO
	cpsmtpb-ews01.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751440AbaBMKPu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 05:15:50 -0500
Message-ID: <1392286548.30853.39.camel@x220>
Subject: Re: [PATCH] Blackfin: bf537: rename "CONFIG_ADT75"
From: Paul Bolle <pebolle@tiscali.nl>
To: Jean Delvare <khali@linux-fr.org>
Cc: Steven Miao <realmz6@gmail.com>,
        Michael Hennerich <michael.hennerich@analog.com>,
        Jonathan Cameron <jic23@cam.ac.uk>, Guenter Roeck <linux@roeck-us.net>,
        adi-buildroot-devel@lists.sourceforge.net,
        linux-kernel@vger.kernel.org
Date: Thu, 13 Feb 2014 11:15:48 +0100
In-Reply-To: <20130404134003.016dcee3@endymion.delvare>
References: <1365071466.1830.29.camel@x61.thuisdomein>
	 <20130404134003.016dcee3@endymion.delvare>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.3 (3.10.3-1.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 13 Feb 2014 10:15:48.0863 (UTC) FILETIME=[90F310F0:01CF28A4]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Replaced previous maintainer and list with current maintainer and
list.]

On Thu, 2013-04-04 at 13:40 +0200, Jean Delvare wrote:
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
> >  		.irq = IRQ_PG5,
> 
> The patch itself looks good.
> 
> Reviewed-by: Jean Delvare <khali@linux-fr.org>

After which nothing seems to have happened. Can someone please have a
look at this patch?


Paul Bolle

