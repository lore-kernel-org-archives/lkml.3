Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753663Ab3HVGh0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 02:37:26 -0400
Received: from hqemgate15.nvidia.com ([216.228.121.64]:1697 "EHLO
	hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753639Ab3HVGhZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 02:37:25 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Wed, 21 Aug 2013 23:37:24 -0700
Message-ID: <5215B57B.80204@nvidia.com>
Date: Thu, 22 Aug 2013 12:23:47 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: Axel Lin <axel.lin@ingics.com>
CC: Linus Walleij <linus.walleij@linaro.org>, Lee Jones <lee.jones@linaro.org>,
        Stephen Warren <swarren@nvidia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] pinctrl: palmas: PINCTRL_PALMAS needs to select PINMUX
References: <1377153008.18701.0.camel@phoenix>
In-Reply-To: <1377153008.18701.0.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 22 August 2013 12:00 PM, Axel Lin wrote:
> Fix below build error if !PINMUX.
>
>    CC      drivers/pinctrl/pinctrl-palmas.o
> drivers/pinctrl/pinctrl-palmas.c:741:21: error: variable 'palmas_pinmux_ops' has initializer but incomplete type
> drivers/pinctrl/pinctrl-palmas.c:742:2: error: unknown field 'get_functions_count' specified in initializer
> drivers/pinctrl/pinctrl-palmas.c:742:2: warning: excess elements in struct initializer [enabled by default]
> drivers/pinctrl/pinctrl-palmas.c:742:2: warning: (near initialization for 'palmas_pinmux_ops') [enabled by default]
> drivers/pinctrl/pinctrl-palmas.c:743:2: error: unknown field 'get_function_name' specified in initializer
> drivers/pinctrl/pinctrl-palmas.c:743:2: warning: excess elements in struct initializer [enabled by default]
> drivers/pinctrl/pinctrl-palmas.c:743:2: warning: (near initialization for 'palmas_pinmux_ops') [enabled by default]
> drivers/pinctrl/pinctrl-palmas.c:744:2: error: unknown field 'get_function_groups' specified in initializer
> drivers/pinctrl/pinctrl-palmas.c:744:2: warning: excess elements in struct initializer [enabled by default]
> drivers/pinctrl/pinctrl-palmas.c:744:2: warning: (near initialization for 'palmas_pinmux_ops') [enabled by default]
> drivers/pinctrl/pinctrl-palmas.c:745:2: error: unknown field 'enable' specified in initializer
> drivers/pinctrl/pinctrl-palmas.c:745:2: warning: excess elements in struct initializer [enabled by default]
> drivers/pinctrl/pinctrl-palmas.c:745:2: warning: (near initialization for 'palmas_pinmux_ops') [enabled by default]
> make[2]: *** [drivers/pinctrl/pinctrl-palmas.o] Error 1
> make[1]: *** [drivers/pinctrl] Error 2
> make: *** [drivers] Error 2
>
> Signed-off-by: Axel Lin <axel.lin@ingics.com>
> ---
>   drivers/pinctrl/Kconfig | 1 +
>   1 file changed, 1 insertion(+)
>
> diff --git a/drivers/pinctrl/Kconfig b/drivers/pinctrl/Kconfig
> index 8542cd4..ae8b747 100644
> --- a/drivers/pinctrl/Kconfig
> +++ b/drivers/pinctrl/Kconfig
> @@ -264,6 +264,7 @@ config PINCTRL_EXYNOS5440
>   config PINCTRL_PALMAS
>   	bool "Pinctrl driver for the PALMA Series MFD devices"
>   	depends on OF && MFD_PALMAS
> +	select PINMUX
>   	select GENERIC_PINCONF
>   	help
>   	  Palmas device supports the configuration of pins for different

Yes, this is needed. In mainline, it is not creating issue for Tegra as 
it is already selecting PINMUX for Tegra.
I found this issue on yesterday only in our downstream when porting it 
for  new boards with new config.
You won the race of sending patch ;-).

Acked-by: Laxman Dewangan <ldewangan@nvidia.com>


