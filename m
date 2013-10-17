Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753826Ab3JQKD6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 06:03:58 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:48064 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753214Ab3JQKDz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 06:03:55 -0400
X-AuditID: cbfee61a-b7f7a6d00000235f-05-525fb609b1ba
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
Cc: linux-pm@vger.kernel.org, naveenkrishna.ch@gmail.com, rui.zhang@intel.com,
        eduardo.valentin@ti.com, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org, amit.daniel@samsung.com,
        kgene.kim@samsung.com, devicetree@vger.kernel.org, cpgs@samsung.com
Subject: Re: [PATCH 1/3 v6] thermal: samsung: add intclr_fall_shift bit in
 exynos_tmu_register
Date: Thu, 17 Oct 2013 12:03:50 +0200
Message-id: <2064487.sPVcMNRS4J@amdc1032>
User-Agent: KMail/4.8.4 (Linux/3.2.0-54-generic-pae; KDE/4.8.5; i686; ; )
In-reply-to: <1381979473-7079-1-git-send-email-ch.naveen@samsung.com>
References: <1377668719-8602-2-git-send-email-ch.naveen@samsung.com>
 <1381979473-7079-1-git-send-email-ch.naveen@samsung.com>
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=ISO-8859-1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrHLMWRmVeSWpSXmKPExsVy+t9jAV3ObfFBBlv3Wlo0XA2xuPv8MKPF
	y0OaFvOPnGO1WLP/J5NF74KrbBaXd81hs/jce4TRYsb5fUwWi7b9Z7Z48rCPzYHbY+esu+we
	i/e8ZPLo27KK0eP4je1MHp83yQWwRnHZpKTmZJalFunbJXBlbLt5hKVgkUbFhT8fGRsYbyp2
	MXJwSAiYSBx46dPFyAlkiklcuLeerYuRi0NIYBGjxJf9ExghnBYmifvfXzGBVLEJWElMbF/F
	CGKLADUff3WGHaSIWaCbSWL5k2tgRcICCRIT5rxhA7FZBFQlFnx4ygJi8wpoSvQ8uc4OYosK
	eErs2L4SrIZTwFXi2+s+sBohgXqJ3iOPoeoFJX5MvgdmMwvIS+zbP5UVwtaR2N86jW0Co8As
	JGWzkJTNQlK2gJF5FaNoakFyQXFSeq6hXnFibnFpXrpecn7uJkZwLDyT2sG4ssHiEKMAB6MS
	D+/M5XFBQqyJZcWVuYcYJTiYlUR4d66PDxLiTUmsrEotyo8vKs1JLT7EKM3BoiTOe6DVOlBI
	ID2xJDU7NbUgtQgmy8TBKdXAaLPBPuGq7//5S4vX/fQ/27nh+k+ZVbO3rlD6MWPWKyfnpnlJ
	XM+uWMtLXKvbOE1xGZ/U2+dKP1o1Dj74vn27Ff+FNMefzxQF13IeOsSo2bpj5+qS3M5jPjNy
	j1+a+riDkzNz28torgViNzVtgrzE5+fmN9zdOGG/4GUbv9opeeKOFYI6xzdnCCmxFGckGmox
	FxUnAgCAC5OQgQIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Naveen,

On Thursday, October 17, 2013 08:41:13 AM Naveen Krishna Chatradhi wrote:
> On Exynos5250, the FALL interrupt related en, status and clear bits are
> available at an offset of
> 16 in INTEN, INTSTAT registers and at an offset of
> 12 in INTCLEAR register.
> 
> On Exynos5420, the FALL interrupt related en, status and clear bits are
> available at an offset of
> 16 in INTEN, INTSTAT and INTCLEAR registers.
> 
> On Exynos5440,
> the FALL_IRQEN bits are at an offset of 4
> and the RISE_IRQEN bits are at an offset of 0
> 
> This patch introduces a new bit field intclr_fall_shift to handle the
> offset for exyns5250 and exynos5440
> 
> Signed-off-by: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
> ---
> Changes since v1:
> Changes since v2:
> Changes since v3:
>   None
> Changes since v4:
>  Correct the CLEAR_FALL_INT_SHIFT for Exynos5250/Exynos5440
> Changes since v5:
>  Modify the commit message

Thank you but v5 had more issues which are not fixed yet. Please see below.

>  drivers/thermal/samsung/exynos_tmu.c      |    2 +-
>  drivers/thermal/samsung/exynos_tmu.h      |    2 ++
>  drivers/thermal/samsung/exynos_tmu_data.c |    2 ++
>  drivers/thermal/samsung/exynos_tmu_data.h |    4 +++-
>  4 files changed, 8 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/thermal/samsung/exynos_tmu.c b/drivers/thermal/samsung/exynos_tmu.c
> index 32f38b9..b2202fa 100644
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
> index 3fb6554..5f4fe6c 100644
> --- a/drivers/thermal/samsung/exynos_tmu.h
> +++ b/drivers/thermal/samsung/exynos_tmu.h
> @@ -136,6 +136,7 @@ enum soc_type {
>   * @inten_fall3_shift: shift bits of falling 3 interrupt bits.
>   * @tmu_intstat: Register containing the interrupt status values.
>   * @tmu_intclear: Register for clearing the raised interrupt status.
> + * @intclr_fall_shift: shift bits for interrupt clear fall 0
>   * @emul_con: TMU emulation controller register.
>   * @emul_temp_shift: shift bits of emulation temperature.
>   * @emul_time_shift: shift bits of emulation time.
> @@ -207,6 +208,7 @@ struct exynos_tmu_registers {
>  	u32	tmu_intstat;
>  
>  	u32	tmu_intclear;
> +	u32	intclr_fall_shift;
>  
>  	u32	emul_con;
>  	u32	emul_temp_shift;
> diff --git a/drivers/thermal/samsung/exynos_tmu_data.c b/drivers/thermal/samsung/exynos_tmu_data.c
> index 073c292..09a8a27 100644
> --- a/drivers/thermal/samsung/exynos_tmu_data.c
> +++ b/drivers/thermal/samsung/exynos_tmu_data.c
> @@ -123,6 +123,7 @@ static const struct exynos_tmu_registers exynos4412_tmu_registers = {
>  	.inten_fall0_shift = EXYNOS_TMU_INTEN_FALL0_SHIFT,
>  	.tmu_intstat = EXYNOS_TMU_REG_INTSTAT,
>  	.tmu_intclear = EXYNOS_TMU_REG_INTCLEAR,
> +	.intclr_fall_shift = EXYNOS5250_TMU_CLEAR_FALL_INT_SHIFT,
>  	.emul_con = EXYNOS_EMUL_CON,
>  	.emul_temp_shift = EXYNOS_EMUL_DATA_SHIFT,
>  	.emul_time_shift = EXYNOS_EMUL_TIME_SHIFT,
> @@ -228,6 +229,7 @@ static const struct exynos_tmu_registers exynos5440_tmu_registers = {
>  	.inten_fall0_shift = EXYNOS5440_TMU_INTEN_FALL0_SHIFT,
>  	.tmu_intstat = EXYNOS5440_TMU_S0_7_IRQ,
>  	.tmu_intclear = EXYNOS5440_TMU_S0_7_IRQ,
> +	.intclr_fall_shift = EXYNOS5440_TMU_CLEAR_FALL_INT_SHIFT,
>  	.tmu_irqstatus = EXYNOS5440_TMU_IRQ_STATUS,
>  	.emul_con = EXYNOS5440_TMU_S0_7_DEBUG,
>  	.emul_temp_shift = EXYNOS_EMUL_DATA_SHIFT,
> diff --git a/drivers/thermal/samsung/exynos_tmu_data.h b/drivers/thermal/samsung/exynos_tmu_data.h
> index a1ea19d..9c1e2c8 100644
> --- a/drivers/thermal/samsung/exynos_tmu_data.h
> +++ b/drivers/thermal/samsung/exynos_tmu_data.h
> @@ -69,9 +69,11 @@
>  #define EXYNOS_TMU_RISE_INT_MASK	0x111
>  #define EXYNOS_TMU_RISE_INT_SHIFT	0
>  #define EXYNOS_TMU_FALL_INT_MASK	0x111
> -#define EXYNOS_TMU_FALL_INT_SHIFT	12
> +#define EXYNOS_TMU_FALL_INT_SHIFT	16
>  #define EXYNOS_TMU_CLEAR_RISE_INT	0x111
>  #define EXYNOS_TMU_CLEAR_FALL_INT	(0x111 << 12)
> +#define EXYNOS5250_TMU_CLEAR_FALL_INT_SHIFT	12

The better name would be EXYNOS_TMU_CLEAR_FALL_INT_SHIFT because it is
also used on EXYNOS4412.

Also in patch #3 you should define EXYNOS5420_TMU_CLEAR_FALL_INT_SHIFT
instead of re-using EXYNOS_TMU_FALL_INT_SHIFT.

Finally please remove no longer used inten_fall_shift field and related
defines (EXYNOS_TMU_FALL_INT_MASK and EXYNOS5440_TMU_FALL_INT_MASK).

Best regards,
--
Bartlomiej Zolnierkiewicz
Samsung R&D Institute Poland
Samsung Electronics

> +#define EXYNOS5440_TMU_CLEAR_FALL_INT_SHIFT	4
>  #define EXYNOS_TMU_TRIP_MODE_SHIFT	13
>  #define EXYNOS_TMU_TRIP_MODE_MASK	0x7
>  #define EXYNOS_TMU_THERM_TRIP_EN_SHIFT	12

