Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759428Ab3DDLk2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 07:40:28 -0400
Received: from zoneX.GCU-Squad.org ([194.213.125.0]:34527 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758781Ab3DDLk1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 07:40:27 -0400
Date: Thu, 4 Apr 2013 13:40:03 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Mike Frysinger <vapier@gentoo.org>,
        Michael Hennerich <michael.hennerich@analog.com>,
        Jonathan Cameron <jic23@cam.ac.uk>, Guenter Roeck <linux@roeck-us.net>,
        uclinux-dist-devel@blackfin.uclinux.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Blackfin: bf537: rename "CONFIG_ADT75"
Message-ID: <20130404134003.016dcee3@endymion.delvare>
In-Reply-To: <1365071466.1830.29.camel@x61.thuisdomein>
References: <1365071466.1830.29.camel@x61.thuisdomein>
X-Mailer: Claws Mail 3.9.0 (GTK+ 2.24.14; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 04 Apr 2013 12:31:06 +0200, Paul Bolle wrote:
> In v3.2 the Analog Devices ADT75 temperature sensor driver was removed
> as an IIO driver and support for it was added to the LM75 HWMON driver.
> But it was apparently overlooked to rename one reference to CONFIG_ADT75
> to CONFIG_SENSORS_LM75. Do so now. Use the IS_ENABLED() macro, while
> we're at it.
> 
> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
> ---
> 0) Also untested.
> 
> 1) See commits e96f9d89e6213c7630a3323cd0c754e7f2619564 ("hwmon: (lm75)
> Add support for Analog Devices ADT75") and
> cdea0bec8d37f2943ae500512b0c178bc76de6e3 ("iio: adc: remove ADT75 driver
> - hwmon/lm75 will take over ADT75 support") for the two patches involved
> in this operation.
> 
>  arch/blackfin/mach-bf537/boards/stamp.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

This breakage is telling us something about the weird approach taken in
this file, methinks.

> diff --git a/arch/blackfin/mach-bf537/boards/stamp.c b/arch/blackfin/mach-bf537/boards/stamp.c
> index b40b849..9735345 100644
> --- a/arch/blackfin/mach-bf537/boards/stamp.c
> +++ b/arch/blackfin/mach-bf537/boards/stamp.c
> @@ -2221,7 +2221,7 @@ static struct i2c_board_info __initdata bfin_i2c_board_info[] = {
>  	},
>  #endif
>  
> -#if defined(CONFIG_ADT75) || defined(CONFIG_ADT75_MODULE)
> +#if IS_ENABLED(CONFIG_SENSORS_LM75)
>  	{
>  		I2C_BOARD_INFO("adt75", 0x9),

Unrelated to this patch, but this is very odd, as the ADT75 can't have
slave address 0x09. This address is almost exclusively used by battery
chargers AFAIK.

>  		.irq = IRQ_PG5,

The patch itself looks good.

Reviewed-by: Jean Delvare <khali@linux-fr.org>

-- 
Jean Delvare
