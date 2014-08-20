Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751745AbaHTNZI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 09:25:08 -0400
Received: from mail-vc0-f177.google.com ([209.85.220.177]:54659 "EHLO
	mail-vc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751636AbaHTNZG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 09:25:06 -0400
Date: Wed, 20 Aug 2014 09:24:57 -0400
From: Eduardo Valentin <edubezval@gmail.com>
To: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Cc: Kyungmin Park <kyungmin.park@samsung.com>,
        linux-samsung-soc@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Chanwoo Choi <cw00.choi@samsung.com>,
        Naveen Krishna Chatradhi <ch.naveen@samsung.com>,
        Amit Daniel Kachhap <amit.daniel@samsung.com>,
        Zhang Rui <rui.zhang@intel.com>
Subject: Re: [PATCH] thermal: samsung: Exynos5260 and Exynos5420 should not
 use TRIM_RELOAD flag
Message-ID: <20140820132457.GA15735@developer>
References: <6263189.obPAjoFMg7@amdc1032>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6263189.obPAjoFMg7@amdc1032>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Bartlomiej,

On Wed, Aug 20, 2014 at 02:04:18PM +0200, Bartlomiej Zolnierkiewicz wrote:
> Currently these SoCs claim TRIM_RELOAD support but don't have
> triminfo_ctrl register address defined in their struct
> exynos_tmu_registers entries.  This causes incorrect write of
> value "1" to data->base + 0x00 address (which happens to be
> TRIMINFO register).  Fix it by removing TMU_SUPPORT_TRIM_RELOAD
> flag for Exynos5260 and Exynos5420

Do the Exynos5260 and Exynos5420 hardwares support TRIM_RELOAD?

Based on the above description, you state that they lack the definition
in their struct exynos_tmu_register. But that does not mean necessarily
that they do not support it right?

If they support the TRIM_RELOAD feature, then please add the proper
triminfo_ctrl entry in their exynos_tmu_registers.

But If they do not support TRIM_RELOAD, please, keep the changes below,
but improve the commit message, simply stating that these SoC do not
support TRIM_RELOAD.

> 
> Cc: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
> Cc: Chanwoo Choi <cw00.choi@samsung.com>
> Cc: Amit Daniel Kachhap <amit.daniel@samsung.com>
> Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
> Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
> ---
>  drivers/thermal/samsung/exynos_tmu_data.c | 16 +++++++---------
>  1 file changed, 7 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/thermal/samsung/exynos_tmu_data.c b/drivers/thermal/samsung/exynos_tmu_data.c
> index aa8e0de..8c0ada2 100644
> --- a/drivers/thermal/samsung/exynos_tmu_data.c
> +++ b/drivers/thermal/samsung/exynos_tmu_data.c
> @@ -359,9 +359,8 @@ static const struct exynos_tmu_registers exynos5260_tmu_registers = {
>  #define EXYNOS5260_TMU_DATA \
>  	__EXYNOS5260_TMU_DATA \
>  	.type = SOC_ARCH_EXYNOS5260, \
> -	.features = (TMU_SUPPORT_EMULATION | TMU_SUPPORT_TRIM_RELOAD | \
> -			TMU_SUPPORT_FALLING_TRIP | TMU_SUPPORT_READY_STATUS | \
> -			TMU_SUPPORT_EMUL_TIME)
> +	.features = (TMU_SUPPORT_EMULATION | TMU_SUPPORT_FALLING_TRIP | \
> +			TMU_SUPPORT_READY_STATUS | TMU_SUPPORT_EMUL_TIME)
>  
>  struct exynos_tmu_init_data const exynos5260_default_tmu_data = {
>  	.tmu_data = {
> @@ -451,16 +450,15 @@ static const struct exynos_tmu_registers exynos5420_tmu_registers = {
>  #define EXYNOS5420_TMU_DATA \
>  	__EXYNOS5420_TMU_DATA \
>  	.type = SOC_ARCH_EXYNOS5250, \
> -	.features = (TMU_SUPPORT_EMULATION | TMU_SUPPORT_TRIM_RELOAD | \
> -			TMU_SUPPORT_FALLING_TRIP | TMU_SUPPORT_READY_STATUS | \
> -			TMU_SUPPORT_EMUL_TIME)
> +	.features = (TMU_SUPPORT_EMULATION | TMU_SUPPORT_FALLING_TRIP | \
> +			TMU_SUPPORT_READY_STATUS | TMU_SUPPORT_EMUL_TIME)
>  
>  #define EXYNOS5420_TMU_DATA_SHARED \
>  	__EXYNOS5420_TMU_DATA \
>  	.type = SOC_ARCH_EXYNOS5420_TRIMINFO, \
> -	.features = (TMU_SUPPORT_EMULATION | TMU_SUPPORT_TRIM_RELOAD | \
> -			TMU_SUPPORT_FALLING_TRIP | TMU_SUPPORT_READY_STATUS | \
> -			TMU_SUPPORT_EMUL_TIME | TMU_SUPPORT_ADDRESS_MULTIPLE)
> +	.features = (TMU_SUPPORT_EMULATION | TMU_SUPPORT_FALLING_TRIP | \
> +			TMU_SUPPORT_READY_STATUS | TMU_SUPPORT_EMUL_TIME | \
> +			TMU_SUPPORT_ADDRESS_MULTIPLE)
>  
>  struct exynos_tmu_init_data const exynos5420_default_tmu_data = {
>  	.tmu_data = {
> -- 
> 1.8.2.3
> 
> 
