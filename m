Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753398Ab3JIOEF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 10:04:05 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:56427 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752088Ab3JIOED (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 10:04:03 -0400
X-AuditID: cbfee61b-b7f776d0000016c8-8d-52556251564a
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
Cc: linux-pm@vger.kernel.org, naveenkrishna.ch@gmail.com, rui.zhang@intel.com,
        eduardo.valentin@ti.com, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org, amit.daniel@samsung.com,
        kgene.kim@samsung.com, devicetree@vger.kernel.org,
        Lukasz Majewski <l.majewski@samsung.com>
Subject: Re: [PATCH 1/3 v4] thermal: samsung: correct the fall interrupt en,
 status bit fields
Date: Wed, 09 Oct 2013 16:03:54 +0200
Message-id: <2386580.3V2pzai3k2@amdc1032>
User-Agent: KMail/4.8.4 (Linux/3.2.0-52-generic-pae; KDE/4.8.5; i686; ; )
In-reply-to: <1381320509-23967-1-git-send-email-ch.naveen@samsung.com>
References: <1378268629-2886-3-git-send-email-ch.naveen@samsung.com>
 <1381320509-23967-1-git-send-email-ch.naveen@samsung.com>
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=ISO-8859-1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrALMWRmVeSWpSXmKPExsVy+t9jAd3ApNAgg8MNEhYNV0Ms7j4/zGgx
	/8g5Vos1+38yWfQuuMpm8ebhZkaLy7vmsFl87j3CaDHj/D4mi0Xb/jNbPHnYx+bA7bFz1l12
	j8V7XjJ59G1Zxehx/MZ2Jo/Pm+QCWKO4bFJSczLLUov07RK4Mt5N/85c0KtScWN2VgPjIrku
	Rk4OCQETiYmbJ7BA2GISF+6tZ+ti5OIQEljEKNE9cQ07hNPCJLHs8RmwKjYBK4mJ7asYQWwR
	oO7jr86AFTELLGaSmLfzPRNIQlggQeLHyR4wm0VAVaLt72xmEJtXQFPizfJ1YHFRAU+JT5OW
	gsU5BdwkLs/qZYLY1sAoceFwEwtEg6DEj8n3wGxmAXmJffunskLYOhL7W6exTWAUmIWkbBaS
	sllIyhYwMq9iFE0tSC4oTkrPNdIrTswtLs1L10vOz93ECI6HZ9I7GFc1WBxiFOBgVOLhfcAf
	EiTEmlhWXJl7iFGCg1lJhNc4OjRIiDclsbIqtSg/vqg0J7X4EKM0B4uSOO/BVutAIYH0xJLU
	7NTUgtQimCwTB6dUA+OEpTqzH1Vdn18X9FNPmDdAW/WP0aHNrwQUfviJbf7l8Kr70HWG5C/t
	m1bNvFX47JjPfc0r7GUyXxgZ8vxc99y9W2+fw1DT33734a1nKm37mdpqCro3dDeH6U+IWZmd
	OMvO8IeC26LL++tvTMl+XlvG9i2hNcCfKfJK4PKPq5bKfT8i76SXeE2JpTgj0VCLuag4EQA/
	NcTWgwIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

All patches (#1-#3) look good to me, FWIW you can add:

	Reviewed-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>

Please note that (at least) patch #3 conflicts with Lukasz's EXYNOS4412
fixup patchset:

	https://lkml.org/lkml/2013/10/9/35

It is up to Eduardo to resolve this but it probably would be better to
merge EXYNOS4412 fixes first and then add EXYNOS5420 support. This would
require you to port patch #3 over Lukasz's patchset though.

Best regards,
--
Bartlomiej Zolnierkiewicz
Samsung R&D Institute Poland
Samsung Electronics

On Wednesday, October 09, 2013 05:38:27 PM Naveen Krishna Chatradhi wrote:
> The FALL interrupt related en, status bits are available at an offset of
> 16 on INTEN, INTSTAT registers and at an offset of
> 12 on INTCLEAR register.
> 
> This patch corrects the same for exyns5250 and exynos5440
> 
> Signed-off-by: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
> ---
> Changes since v1:
> Changes since v2:
> Changes since v3:
>   None
> 
>  drivers/thermal/samsung/exynos_tmu.c      |    2 +-
>  drivers/thermal/samsung/exynos_tmu.h      |    2 ++
>  drivers/thermal/samsung/exynos_tmu_data.c |    2 ++
>  drivers/thermal/samsung/exynos_tmu_data.h |    3 ++-
>  4 files changed, 7 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/thermal/samsung/exynos_tmu.c b/drivers/thermal/samsung/exynos_tmu.c
> index b43afda..af69209 100644
> --- a/drivers/thermal/samsung/exynos_tmu.c
> +++ b/drivers/thermal/samsung/exynos_tmu.c
> @@ -265,7 +265,7 @@ skip_calib_data:
>  				data->base + reg->threshold_th1);
>  
>  		writel((reg->inten_rise_mask << reg->inten_rise_shift) |
> -			(reg->inten_fall_mask << reg->inten_fall_shift),
> +			(reg->inten_fall_mask << reg->intclr_fall_shift),
>  				data->base + reg->tmu_intclear);
>  
>  		/* if last threshold limit is also present */
> diff --git a/drivers/thermal/samsung/exynos_tmu.h b/drivers/thermal/samsung/exynos_tmu.h
> index b364c9e..7c6c34a 100644
> --- a/drivers/thermal/samsung/exynos_tmu.h
> +++ b/drivers/thermal/samsung/exynos_tmu.h
> @@ -134,6 +134,7 @@ enum soc_type {
>   * @inten_fall3_shift: shift bits of falling 3 interrupt bits.
>   * @tmu_intstat: Register containing the interrupt status values.
>   * @tmu_intclear: Register for clearing the raised interrupt status.
> + * @intclr_fall_shift: shift bits for interrupt clear fall 0
>   * @emul_con: TMU emulation controller register.
>   * @emul_temp_shift: shift bits of emulation temperature.
>   * @emul_time_shift: shift bits of emulation time.
> @@ -204,6 +205,7 @@ struct exynos_tmu_registers {
>  	u32	tmu_intstat;
>  
>  	u32	tmu_intclear;
> +	u32	intclr_fall_shift;
>  
>  	u32	emul_con;
>  	u32	emul_temp_shift;
> diff --git a/drivers/thermal/samsung/exynos_tmu_data.c b/drivers/thermal/samsung/exynos_tmu_data.c
> index 9002499..23fea23 100644
> --- a/drivers/thermal/samsung/exynos_tmu_data.c
> +++ b/drivers/thermal/samsung/exynos_tmu_data.c
> @@ -122,6 +122,7 @@ static const struct exynos_tmu_registers exynos5250_tmu_registers = {
>  	.inten_fall0_shift = EXYNOS_TMU_INTEN_FALL0_SHIFT,
>  	.tmu_intstat = EXYNOS_TMU_REG_INTSTAT,
>  	.tmu_intclear = EXYNOS_TMU_REG_INTCLEAR,
> +	.intclr_fall_shift = EXYNOS_TMU_CLEAR_FALL_INT_SHIFT,
>  	.emul_con = EXYNOS_EMUL_CON,
>  	.emul_temp_shift = EXYNOS_EMUL_DATA_SHIFT,
>  	.emul_time_shift = EXYNOS_EMUL_TIME_SHIFT,
> @@ -210,6 +211,7 @@ static const struct exynos_tmu_registers exynos5440_tmu_registers = {
>  	.inten_fall0_shift = EXYNOS5440_TMU_INTEN_FALL0_SHIFT,
>  	.tmu_intstat = EXYNOS5440_TMU_S0_7_IRQ,
>  	.tmu_intclear = EXYNOS5440_TMU_S0_7_IRQ,
> +	.intclr_fall_shift = EXYNOS_TMU_CLEAR_FALL_INT_SHIFT,
>  	.tmu_irqstatus = EXYNOS5440_TMU_IRQ_STATUS,
>  	.emul_con = EXYNOS5440_TMU_S0_7_DEBUG,
>  	.emul_temp_shift = EXYNOS_EMUL_DATA_SHIFT,
> diff --git a/drivers/thermal/samsung/exynos_tmu_data.h b/drivers/thermal/samsung/exynos_tmu_data.h
> index dc7feb5..8788a87 100644
> --- a/drivers/thermal/samsung/exynos_tmu_data.h
> +++ b/drivers/thermal/samsung/exynos_tmu_data.h
> @@ -69,9 +69,10 @@
>  #define EXYNOS_TMU_RISE_INT_MASK	0x111
>  #define EXYNOS_TMU_RISE_INT_SHIFT	0
>  #define EXYNOS_TMU_FALL_INT_MASK	0x111
> -#define EXYNOS_TMU_FALL_INT_SHIFT	12
> +#define EXYNOS_TMU_FALL_INT_SHIFT	16
>  #define EXYNOS_TMU_CLEAR_RISE_INT	0x111
>  #define EXYNOS_TMU_CLEAR_FALL_INT	(0x111 << 12)
> +#define EXYNOS_TMU_CLEAR_FALL_INT_SHIFT	12
>  #define EXYNOS_TMU_TRIP_MODE_SHIFT	13
>  #define EXYNOS_TMU_TRIP_MODE_MASK	0x7
>  #define EXYNOS_TMU_THERM_TRIP_EN_SHIFT	12

