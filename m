Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753900AbaARLlU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Jan 2014 06:41:20 -0500
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:38239 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752155AbaARLlR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Jan 2014 06:41:17 -0500
Message-ID: <52DA6868.9020401@kernel.org>
Date: Sat, 18 Jan 2014 11:41:28 +0000
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
Subject: Re: [PATCH 3/7] staging,spear_adc: Add dependency on HAS_IOMEM
References: <1389714345-20165-1-git-send-email-richard@nod.at> <1389714345-20165-3-git-send-email-richard@nod.at>
In-Reply-To: <1389714345-20165-3-git-send-email-richard@nod.at>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14/01/14 15:45, Richard Weinberger wrote:
> On archs like S390 or um this driver cannot build nor work.
> Make it depend on HAS_IOMEM to bypass build failures.
>
> drivers/staging/iio/adc/spear_adc.c: In function ‘spear_adc_probe’:
> drivers/staging/iio/adc/spear_adc.c:393:2: error: implicit declaration of function ‘iounmap’ [-Werror=implicit-function-declaration
>
> Signed-off-by: Richard Weinberger <richard@nod.at>
Applied to the fixes-togreg branch of iio.git

Thanks,
> ---
>   drivers/staging/iio/adc/Kconfig | 1 +
>   1 file changed, 1 insertion(+)
>
> diff --git a/drivers/staging/iio/adc/Kconfig b/drivers/staging/iio/adc/Kconfig
> index e3d6430..7d5d675 100644
> --- a/drivers/staging/iio/adc/Kconfig
> +++ b/drivers/staging/iio/adc/Kconfig
> @@ -128,6 +128,7 @@ config MXS_LRADC
>   config SPEAR_ADC
>   	tristate "ST SPEAr ADC"
>   	depends on PLAT_SPEAR || COMPILE_TEST
> +	depends on HAS_IOMEM
>   	help
>   	  Say yes here to build support for the integrated ADC inside the
>   	  ST SPEAr SoC. Provides direct access via sysfs.
>
