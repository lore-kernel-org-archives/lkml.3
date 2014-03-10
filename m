Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752595AbaCJA2N (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Mar 2014 20:28:13 -0400
Received: from mail-ea0-f175.google.com ([209.85.215.175]:45249 "EHLO
	mail-ea0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750864AbaCJA2M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Mar 2014 20:28:12 -0400
Message-ID: <531D0718.8000305@gmail.com>
Date: Mon, 10 Mar 2014 01:28:08 +0100
From: Tomasz Figa <tomasz.figa@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Pankaj Dubey <pankaj.dubey@samsung.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org
CC: Mike Turquette <mturquette@linaro.org>
Subject: Re: [PATCH 1/3] drivers: clk: add samsung common clock config option
References: <1393392247-6247-1-git-send-email-pankaj.dubey@samsung.com> <1393392247-6247-2-git-send-email-pankaj.dubey@samsung.com>
In-Reply-To: <1393392247-6247-2-git-send-email-pankaj.dubey@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pankaj,

On 26.02.2014 06:24, Pankaj Dubey wrote:
> add samsung common clock config option and let ARCH_EXYNOS or ARCH_S3CXXXX
> select this if they want to use samsung common clock infrastructure.
>
> CC: Mike Turquette <mturquette@linaro.org>
> Signed-off-by: Pankaj Dubey <pankaj.dubey@samsung.com>
> ---
>   drivers/clk/Kconfig  |   10 ++++++++++
>   drivers/clk/Makefile |    2 +-
>   2 files changed, 11 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/clk/Kconfig b/drivers/clk/Kconfig
> index 7641965..d93a325 100644
> --- a/drivers/clk/Kconfig
> +++ b/drivers/clk/Kconfig
> @@ -23,6 +23,16 @@ config COMMON_CLK
>   menu "Common Clock Framework"
>   	depends on COMMON_CLK
>
> +config COMMON_CLK_SAMSUNG
> +	bool "Clock driver for Samsung SoCs"
> +	depends on ARCH_S3C64XX || ARCH_S3C24XX || ARCH_EXYNOS || ARM64
> +	---help---
> +          Supports clocking on Exynos SoCs:
> +	  - Exynos5250, Exynos5420 board.
> +	  - Exynos4 boards.
> +	  - S3C2412, S3C2416, S3C2466 boards.
> +	  - S3C64XX boards.

I don't think listing the platforms here explicitly is a good idea, as 
this option shouldn't generally be user-visible (related platforms would 
not work without this option enabled) and adding support for every new 
SoC would require changing the help string.

I wonder if we really need this to be user-visible. What about moving it 
out of this menu, making the symbol select COMMON_CLK and let the 
platforms just select COMMON_CLK_SAMSUNG alone?

Best regards,
Tomasz
