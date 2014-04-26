Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751948AbaDZAmT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 20:42:19 -0400
Received: from mail-ee0-f50.google.com ([74.125.83.50]:44261 "EHLO
	mail-ee0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751214AbaDZAmR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 20:42:17 -0400
Message-ID: <535B00E5.4060903@gmail.com>
Date: Sat, 26 Apr 2014 02:42:13 +0200
From: Tomasz Figa <tomasz.figa@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Chanwoo Choi <cw00.choi@samsung.com>, kgene.kim@samsung.com,
        t.figa@samsung.com
CC: linux-kernel@vger.kernel.org, linux@arm.linux.org.uk, ben-linux@fluff.org,
        arnd@arndb.de, olof@lixom.net, marc.zyngier@arm.com,
        thomas.abraham@linaro.org, kyungmin.park@samsung.com,
        inki.dae@samsung.com, sw0312.kim@samsung.com, hyunhee.kim@samsung.com,
        yj44.cho@samsung.com, chanho61.park@samsung.com,
        sajjan.linux@gmail.com, tushar.behera@linaro.org,
        sachin.kamat@linaro.org, linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org
Subject: Re: [PATCHv4 2/7] ARM: EXYNOS: Support secondary CPU boot of Exynos4212
References: <1398388572-30239-1-git-send-email-cw00.choi@samsung.com> <1398388572-30239-3-git-send-email-cw00.choi@samsung.com>
In-Reply-To: <1398388572-30239-3-git-send-email-cw00.choi@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 25.04.2014 03:16, Chanwoo Choi wrote:
> From: Kyungmin Park <kyungmin.park@samsung.com>
>
> This patch fix the offset of CPU boot address and change parameter of smc call
> of SMC_CMD_CPU1BOOT command for Exynos4212.
>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
> ---
>   arch/arm/mach-exynos/firmware.c | 15 ++++++++++++++-
>   1 file changed, 14 insertions(+), 1 deletion(-)
>
> diff --git a/arch/arm/mach-exynos/firmware.c b/arch/arm/mach-exynos/firmware.c
> index 932129e..aa01c42 100644
> --- a/arch/arm/mach-exynos/firmware.c
> +++ b/arch/arm/mach-exynos/firmware.c
> @@ -18,6 +18,8 @@
>
>   #include <mach/map.h>
>
> +#include <plat/cpu.h>
> +
>   #include "smc.h"
>
>   static int exynos_do_idle(void)
> @@ -28,13 +30,24 @@ static int exynos_do_idle(void)
>
>   static int exynos_cpu_boot(int cpu)
>   {
> +	/*
> +	 * The second parameter of SMC_CMD_CPU1BOOT command means CPU id.
> +	 * But, Exynos4212 has only one secondary CPU so second parameter
> +	 * isn't used for informing secure firmware about CPU id.
> +	 */
> +	if (soc_is_exynos4212())
> +		cpu = 0;
> +
>   	exynos_smc(SMC_CMD_CPU1BOOT, cpu, 0, 0);
>   	return 0;
>   }
>
>   static int exynos_set_cpu_boot_addr(int cpu, unsigned long boot_addr)
>   {
> -	void __iomem *boot_reg = S5P_VA_SYSRAM_NS + 0x1c + 4*cpu;
> +	void __iomem *boot_reg = S5P_VA_SYSRAM_NS + 0x1c;
> +
> +	if (!soc_is_exynos4212())
> +		boot_reg += 4*cpu;
>
>   	__raw_writel(boot_addr, boot_reg);
>   	return 0;
>

This patch should be applied independently of Exynos3250 support. 
Kukjin, what do you think?

Anyway,

Reviewed-by: Tomasz Figa <t.figa@samsung.com>

Best regards,
Tomasz
