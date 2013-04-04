Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758676Ab3DDKRI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 06:17:08 -0400
Received: from cpsmtpb-ews02.kpnxchange.com ([213.75.39.5]:53690 "EHLO
	cpsmtpb-ews02.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758616Ab3DDKRH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 06:17:07 -0400
Message-ID: <1365070623.1830.24.camel@x61.thuisdomein>
Subject: Re: [PATCH] Blackfin: bf537: rename "CONFIG_AD7314"
From: Paul Bolle <pebolle@tiscali.nl>
To: Mike Frysinger <vapier@gentoo.org>
Cc: Jonathan Cameron <jic23@cam.ac.uk>, Guenter Roeck <linux@roeck-us.net>,
        Michael Hennerich <michael.hennerich@analog.com>,
        uclinux-dist-devel@blackfin.uclinux.org, linux-kernel@vger.kernel.org
Date: Thu, 04 Apr 2013 12:17:03 +0200
In-Reply-To: <1365070105.1830.21.camel@x61.thuisdomein>
References: <1365070105.1830.21.camel@x61.thuisdomein>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 04 Apr 2013 10:17:04.0468 (UTC) FILETIME=[8DE43940:01CE311D]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Forwarded to a recent address of Guenter, as the ericsson address
bounces.]

Paul Bolle

On Thu, 2013-04-04 at 12:08 +0200, Paul Bolle wrote:
> In v3.2 the Analog Devices AD7314 temperature sensor driver was removed
> as an IIO driver and added as a HWMON driver. But it was apparently
> overlooked to rename two references to CONFIG_AD7314 to
> CONFIG_SENSORS_AD7314. Do so now. Use the IS_ENABLED() macro, while
> we're at it.
> 
> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
> ---
> 0) Entirely untested.
> 
> 1) See commits 4f3a659581cabf1be441d6467b523be914615496 ("hwmon: AD7314
> driver (ported from IIO)") and 48a2c3799b7141c271a771d3249142a104faeefc
> ("staging:iio:adc:ad7314 removal. Supported via hwmon.") for the two
> patches involved.
> 
>  arch/blackfin/mach-bf537/boards/stamp.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/blackfin/mach-bf537/boards/stamp.c b/arch/blackfin/mach-bf537/boards/stamp.c
> index 23bb55d..b40b849 100644
> --- a/arch/blackfin/mach-bf537/boards/stamp.c
> +++ b/arch/blackfin/mach-bf537/boards/stamp.c
> @@ -681,7 +681,7 @@ static struct bfin5xx_spi_chip ad2s1210_spi_chip_info = {
>  };
>  #endif
>  
> -#if defined(CONFIG_AD7314) || defined(CONFIG_AD7314_MODULE)
> +#if IS_ENABLED(CONFIG_SENSORS_AD7314)
>  static struct bfin5xx_spi_chip ad7314_spi_chip_info = {
>  	.enable_dma = 0,
>  };
> @@ -1039,7 +1039,7 @@ static struct spi_board_info bfin_spi_board_info[] __initdata = {
>  	},
>  #endif
>  
> -#if defined(CONFIG_AD7314) || defined(CONFIG_AD7314_MODULE)
> +#if IS_ENABLED(CONFIG_SENSORS_AD7314)
>  	{
>  		.modalias = "ad7314",
>  		.max_speed_hz = 1000000,


