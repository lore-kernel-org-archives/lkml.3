Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751907AbaDZK2i (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Apr 2014 06:28:38 -0400
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:54975 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750728AbaDZK2f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Apr 2014 06:28:35 -0400
Message-ID: <535B8AA9.8080204@kernel.org>
Date: Sat, 26 Apr 2014 11:30:01 +0100
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Doug Anderson <dianders@chromium.org>,
        Lars-Peter Clausen <lars@metafoo.de>
CC: Milo.Kim@ti.com, Naveen Krishna Chatradhi <ch.naveen@samsung.com>,
        lee.jones@linaro.org, gregkh@linuxfoundation.org, Russ.Dill@ti.com,
        alexandre.belloni@free-electrons.com, oleksandr.kozaruk@ti.com,
        B38611@freescale.com, johannes.thumshirn@men.de, sre@debian.org,
        sachin.kamat@linaro.org, linux-iio@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] iio: adc: Nothing in ADC should be a bool CONFIG
References: <1398125031-5826-1-git-send-email-dianders@chromium.org>
In-Reply-To: <1398125031-5826-1-git-send-email-dianders@chromium.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22/04/14 01:03, Doug Anderson wrote:
> The whole IIO subsystem can be moved to a module.  If you make it a
> module then stuff marked as "Y" in the adc directory simply won't be
> linked in properly.
>
> The two configs that were wrong were EXYNOS_ADC and LP8788_ADC.  I
> know for a fact that EXYNOS_ADC will work as a module (though it
> appears to crash when you unload it--that needs to be addressed
> separately).  I assume LP8788_ADC will also be fine..
>
> Signed-off-by: Doug Anderson <dianders@chromium.org>
Now the fix is in for the Exynos crash, I've applied this (with
some description editing to reflect that the crash isn't there
any more) to the fixes-togreg branch of iio.git.

We may get some functional breakage on Lp8788 if someone did
build this as a module as it provides some services to the
charger driver.  The right dependencies are there though so
may be fine and as you point out, it is definitely bad right now.

Thanks,

J
> ---
>   drivers/iio/adc/Kconfig | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/iio/adc/Kconfig b/drivers/iio/adc/Kconfig
> index d86196c..24c28e3 100644
> --- a/drivers/iio/adc/Kconfig
> +++ b/drivers/iio/adc/Kconfig
> @@ -106,7 +106,7 @@ config AT91_ADC
>   	  Say yes here to build support for Atmel AT91 ADC.
>
>   config EXYNOS_ADC
> -	bool "Exynos ADC driver support"
> +	tristate "Exynos ADC driver support"
>   	depends on OF
>   	help
>   	  Core support for the ADC block found in the Samsung EXYNOS series
> @@ -114,7 +114,7 @@ config EXYNOS_ADC
>   	  this resource.
>
>   config LP8788_ADC
> -	bool "LP8788 ADC driver"
> +	tristate "LP8788 ADC driver"
>   	depends on MFD_LP8788
>   	help
>   	  Say yes here to build support for TI LP8788 ADC.
>

