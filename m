Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756935Ab3CYLw7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 07:52:59 -0400
Received: from smtp-out-223.synserver.de ([212.40.185.223]:1036 "EHLO
	smtp-out-222.synserver.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756878Ab3CYLw6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 07:52:58 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 3945
Message-ID: <51503B16.1050108@metafoo.de>
Date: Mon, 25 Mar 2013 12:55:02 +0100
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130116 Icedove/10.0.12
MIME-Version: 1.0
To: Paul Bolle <pebolle@tiscali.nl>
CC: Mike Frysinger <vapier@gentoo.org>,
        uclinux-dist-devel@blackfin.uclinux.org, linux-kernel@vger.kernel.org
Subject: Re: [uclinux-dist-devel] [PATCH] Blackfin: bf537: rename "CONFIG_ADT7310"
 and friends
References: <1364211831.1390.285.camel@x61.thuisdomein>
In-Reply-To: <1364211831.1390.285.camel@x61.thuisdomein>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/25/2013 12:43 PM, Paul Bolle wrote:
> The Kconfig symbol ADT7310 got removed in commit
> 2b0c856ad9571013db8fc369194b7108dff3c18e ("staging:iio: Consolidate
> adt7310 and adt7410 driver"). That commit did not touch the references
> to CONFIG_ADT7310 and CONFIG_ADT7310_MODULE in the BF537-STAMP code.
> Convert these now, to their ADT7410 equivalents.
> 
> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
> ---
> 0) Untested. This took a bit of guesswork. I guessed that multiple AD
> drivers can be enabled at the same time in this code. And I also guessed
> that the "adt7310" modalias is still correct.
> 
> 1) If this passes testing it could go in stable (3.8.y).

Hi,

Thanks for the patch. Unfortunately this has already changed again for 3.10
since we replaced the IIO adt7410/adt7310 driver with a hwmon driver. So the
new config name is CONFIG_SENSORS_ADT7310.

Thanks,
- Lars

> 
>  arch/blackfin/mach-bf537/boards/stamp.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/blackfin/mach-bf537/boards/stamp.c b/arch/blackfin/mach-bf537/boards/stamp.c
> index 95114ed..23bb55d 100644
> --- a/arch/blackfin/mach-bf537/boards/stamp.c
> +++ b/arch/blackfin/mach-bf537/boards/stamp.c
> @@ -700,7 +700,7 @@ static struct bfin5xx_spi_chip ad7816_spi_chip_info = {
>  };
>  #endif
>  
> -#if defined(CONFIG_ADT7310) || defined(CONFIG_ADT7310_MODULE)
> +#if defined(CONFIG_ADT7410) || defined(CONFIG_ADT7410_MODULE)
>  static unsigned long adt7310_platform_data[3] = {
>  /* INT bound temperature alarm event. line 1 */
>  	IRQ_PG4, IRQF_TRIGGER_LOW,
> @@ -1062,7 +1062,7 @@ static struct spi_board_info bfin_spi_board_info[] __initdata = {
>  	},
>  #endif
>  
> -#if defined(CONFIG_ADT7310) || defined(CONFIG_ADT7310_MODULE)
> +#if defined(CONFIG_ADT7410) || defined(CONFIG_ADT7410_MODULE)
>  	{
>  		.modalias = "adt7310",
>  		.max_speed_hz = 1000000,

