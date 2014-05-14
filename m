Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751174AbaENTcs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 15:32:48 -0400
Received: from mail-ee0-f45.google.com ([74.125.83.45]:65058 "EHLO
	mail-ee0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750705AbaENTcq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 15:32:46 -0400
Message-ID: <5373C4D1.3070703@gmail.com>
Date: Wed, 14 May 2014 21:32:33 +0200
From: Tomasz Figa <tomasz.figa@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
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
Subject: Re: [PATCHv5 2/5] ARM: EXYNOS: Support secondary CPU boot of Exynos3250
References: <1399986308-23744-1-git-send-email-cw00.choi@samsung.com> <1399986308-23744-3-git-send-email-cw00.choi@samsung.com>
In-Reply-To: <1399986308-23744-3-git-send-email-cw00.choi@samsung.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 13.05.2014 15:05, Chanwoo Choi wrote:
> This patch fix the offset of CPU boot address and don't need to send smc call
> of SMC_CMD_CPU1BOOT command for secondary CPU boot because Exynos3250 removes
> WFE in secure mode.
> 
> Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
> Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
> ---
>  arch/arm/mach-exynos/firmware.c | 9 ++++++++-
>  1 file changed, 8 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm/mach-exynos/firmware.c b/arch/arm/mach-exynos/firmware.c
> index 739bdc8..eb91d23 100644
> --- a/arch/arm/mach-exynos/firmware.c
> +++ b/arch/arm/mach-exynos/firmware.c
> @@ -30,6 +30,13 @@ static int exynos_do_idle(void)
>  static int exynos_cpu_boot(int cpu)
>  {
>  	/*
> +	 * Exynos3250 doesn't need to send smc command for secondary CPU boot
> +	 * because Exynos3250 removes WFE in secure mode.
> +	 */
> +	if (soc_is_exynos3250())
> +		return 0;
> +
> +	/*
>  	 * The second parameter of SMC_CMD_CPU1BOOT command means CPU id.
>  	 * But, Exynos4212 has only one secondary CPU so second parameter
>  	 * isn't used for informing secure firmware about CPU id.
> @@ -50,7 +57,7 @@ static int exynos_set_cpu_boot_addr(int cpu, unsigned long boot_addr)
>  
>  	boot_reg = sysram_ns_base_addr + 0x1c;
>  
> -	if (!soc_is_exynos4212())
> +	if (!soc_is_exynos4212() && !soc_is_exynos3250())
>  		boot_reg += 4*cpu;
>  
>  	__raw_writel(boot_addr, boot_reg);
> 

Reviewed-by: Tomasz Figa <t.figa@samsung.com>

Best regards,
Tomasz
