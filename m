Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754003AbaARLuG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Jan 2014 06:50:06 -0500
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:38327 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752774AbaARLuD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Jan 2014 06:50:03 -0500
Message-ID: <52DA6A78.9040609@kernel.org>
Date: Sat, 18 Jan 2014 11:50:16 +0000
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Richard Weinberger <richard@nod.at>, kishon@ti.com, anton@enomsg.org,
        dwmw2@infradead.org, richardcochran@gmail.com, lidza.louina@gmail.com,
        gregkh@linuxfoundation.org, davem@davemloft.net
CC: sebastian.hesselbarth@gmail.com, florian@openwrt.org,
        thomas.petazzoni@free-electrons.com, lars@metafoo.de, marex@denx.de,
        acourbot@nvidia.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, driverdev-devel@linuxdriverproject.org,
        devel@driverdev.osuosl.org, linux-iio@vger.kernel.org
Subject: Re: [PATCH 7/7] staging,lpc32xx_adc: Add dependency on HAS_IOMEM
References: <1389714345-20165-1-git-send-email-richard@nod.at> <1389714345-20165-7-git-send-email-richard@nod.at>
In-Reply-To: <1389714345-20165-7-git-send-email-richard@nod.at>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 14/01/14 15:45, Richard Weinberger wrote:
> On archs like S390 or um this driver cannot build nor work.
> Make it depend on HAS_IOMEM to bypass build failures.
>
> drivers/built-in.o: In function `lpc32xx_adc_probe':
> drivers/staging/iio/adc/lpc32xx_adc.c:149: undefined reference to `devm_ioremap'
>
> Signed-off-by: Richard Weinberger <richard@nod.at>
applied to the fixes-togreg branch of iio.git

Thanks,
> ---
>   drivers/staging/iio/adc/Kconfig | 1 +
>   1 file changed, 1 insertion(+)
>
> diff --git a/drivers/staging/iio/adc/Kconfig b/drivers/staging/iio/adc/Kconfig
> index 7d5d675..3633298 100644
> --- a/drivers/staging/iio/adc/Kconfig
> +++ b/drivers/staging/iio/adc/Kconfig
> @@ -103,6 +103,7 @@ config AD7280
>   config LPC32XX_ADC
>   	tristate "NXP LPC32XX ADC"
>   	depends on ARCH_LPC32XX || COMPILE_TEST
> +	depends on HAS_IOMEM
>   	help
>   	  Say yes here to build support for the integrated ADC inside the
>   	  LPC32XX SoC. Note that this feature uses the same hardware as the
>
