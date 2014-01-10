Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757689AbaAJPsB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jan 2014 10:48:01 -0500
Received: from mailout3.w1.samsung.com ([210.118.77.13]:50551 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756933AbaAJPr6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jan 2014 10:47:58 -0500
X-AuditID: cbfec7f4-b7f796d000005a13-e1-52d0162cfa85
Message-id: <52D01625.8090601@samsung.com>
Date: Fri, 10 Jan 2014 16:47:49 +0100
From: Tomasz Figa <t.figa@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.1.1
MIME-version: 1.0
To: Naveen Krishna Chatradhi <ch.naveen@samsung.com>,
        linux-crypto@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, vzapolskiy@gmail.com,
        herbert@gondor.apana.org.au, naveenkrishna.ch@gmail.com,
        cpgs@samsung.com, tomasz.figa@gmail.com,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH 4/8 v3] crypto:s5p-sss: Kconfig: Let Exynos SoCs select SSS
 driver
References: <1389095509-14357-5-git-send-email-ch.naveen@samsung.com>
 <1389354202-31891-1-git-send-email-ch.naveen@samsung.com>
In-reply-to: <1389354202-31891-1-git-send-email-ch.naveen@samsung.com>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrFLMWRmVeSWpSXmKPExsVy+t/xa7o6YheCDDasZbW4+/wwo8XLQ5oW
	c863sFh0v5KxuH/vJ5PF5V1z2CxmnN/HZLFo239mi1W7/jBanJ1ziMmBy2PLyptMHjtn3WX3
	2HZA1aNvyypGj8+b5AJYo7hsUlJzMstSi/TtErgyjtx+zlTwnq/ifd8+tgbGbp4uRk4OCQET
	iTWnHzND2GISF+6tZwOxhQSWMkq8+sLRxcgFZH9mlFhyZx87SIJXQEti0uQNYA0sAqoSJxs+
	gTWwCahJfG54BGaLCkRI/J23nhGiXlDix+R7LCC2iEC5xL8ba9hAhjILHGWU+DznIhNIQhio
	oWfdXVaIbY2MEhMmXAdKcHBwCrhJbPgtD1LDLGAtsXLSNkYIW15i85q3zBMYBWYh2TELSdks
	JGULGJlXMYqmliYXFCel5xrqFSfmFpfmpesl5+duYoSE/5cdjIuPWR1iFOBgVOLhDRC5ECTE
	mlhWXJl7iFGCg1lJhPeaIFCINyWxsiq1KD++qDQntfgQIxMHp1QDI2M2T++B3SH15TyMGecr
	HLqi1wesc5CZ0OdZ//VPuJCXg3zCOZcv1mKhz494K97nWVd1r+IEe96lCT/nbL8lesrE8uzZ
	s4m90TumGTgn7LCZoZ74YZmUzft3J/ZbyFn9nvo92+VAWsq1+fPcw/bvfHvj0pQ/fA8mrNhk
	Yi2441yuwcxpqxT3NiuxFGckGmoxFxUnAgCkPaoCXQIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Naveen,

On 10.01.2014 12:43, Naveen Krishna Chatradhi wrote:
> From: Naveen Krishna Ch <ch.naveen@samsung.com>
>
> This patch modifies Kconfig such that ARCH_EXYNOS SoCs
> which includes (Exynos4210, Exynos5250 and Exynos5420)
> can also select Samsung SSS(Security SubSystem) driver.
>
> Signed-off-by: Naveen Krishna Ch <ch.naveen@samsung.com>
> CC: Herbert Xu <herbert@gondor.apana.org.au>
> CC: David S. Miller <davem@davemloft.net>
> CC: Vladimir Zapolskiy <vzapolskiy@gmail.com>
> TO: <linux-crypto@vger.kernel.org>
> CC: <linux-samsung-soc@vger.kernel.org>
> ---
> Changes since v2:
> None
>
>   drivers/crypto/Kconfig |    8 ++++----
>   1 file changed, 4 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/crypto/Kconfig b/drivers/crypto/Kconfig
> index f4fd837..193e8b1 100644
> --- a/drivers/crypto/Kconfig
> +++ b/drivers/crypto/Kconfig
> @@ -300,15 +300,15 @@ config CRYPTO_DEV_DCP
>   	  capabilities of the DCP co-processor
>
>   config CRYPTO_DEV_S5P
> -	tristate "Support for Samsung S5PV210 crypto accelerator"
> -	depends on ARCH_S5PV210
> +	tristate "Support for Samsung crypto accelerator"

I'd make this "Support for Samsung S5PV210/Exynos crypto accelerator" 
instead, because there are previous SoCs (S3C64xx and S5PC100) that 
contain a different crypto engine IP.

> +	depends on ARCH_S5PV210 || ARCH_EXYNOS
>   	select CRYPTO_AES
>   	select CRYPTO_ALGAPI
>   	select CRYPTO_BLKCIPHER
>   	help
>   	  This option allows you to have support for S5P crypto acceleration.
> -	  Select this to offload Samsung S5PV210 or S5PC110 from AES
> -	  algorithms execution.
> +	  Select this to offload Samsung S5PV210 or S5PC110, Exynos4210,
> +	  Exynos5250 and Exynos5420 from AES algorithms execution.

I believe you can safely make it S5PV210, S5PC110 and Exynos, without 
listing particular SoCs.

Best regards,
Tomasz
