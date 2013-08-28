Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754525Ab3H1F5O (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 01:57:14 -0400
Received: from mail-lb0-f170.google.com ([209.85.217.170]:44880 "EHLO
	mail-lb0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752565Ab3H1F5M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 01:57:12 -0400
MIME-Version: 1.0
In-Reply-To: <1377668719-8602-2-git-send-email-ch.naveen@samsung.com>
References: <1375336979-14747-1-git-send-email-ch.naveen@samsung.com>
	<1377668719-8602-1-git-send-email-ch.naveen@samsung.com>
	<1377668719-8602-2-git-send-email-ch.naveen@samsung.com>
Date: Wed, 28 Aug 2013 11:27:10 +0530
X-Google-Sender-Auth: WY9nKC_seyGHn6LjAAWo2w8rCVM
Message-ID: <CADGdYn4EESL01aV4B=e=noL8jDbxayoCXdxj=W61VSw8TB26sw@mail.gmail.com>
Subject: Re: [PATCH 1/3] thermal: samsung: correct the fall interrupt en,
 status bit fields
From: amit daniel kachhap <amit.daniel@samsung.com>
To: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
Cc: "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Zhang Rui <rui.zhang@intel.com>,
        "Valentin, Eduardo" <eduardo.valentin@ti.com>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Naveen Krishna <naveenkrishna.ch@gmail.com>,
        devicetree@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 28, 2013 at 11:15 AM, Naveen Krishna Chatradhi
<ch.naveen@samsung.com> wrote:
> The FALL interrupt related en, status bits are available at an offset of
> 16 on INTEN, INTSTAT registers and at an offset of
> 12 on INTCLEAR register.
>
> This patch corrects the same for exyns5250 and exynos5440
>
> Signed-off-by: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
The changes looks fine.
Acked-by: Amit Daniel Kachhap <amit.daniel@samsung.com>

Thanks,
Amit
> ---
>  drivers/thermal/samsung/exynos_tmu.c      |    2 +-
>  drivers/thermal/samsung/exynos_tmu.h      |    2 ++
>  drivers/thermal/samsung/exynos_tmu_data.c |    2 ++
>  drivers/thermal/samsung/exynos_tmu_data.h |    3 ++-
>  4 files changed, 7 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/thermal/samsung/exynos_tmu.c b/drivers/thermal/samsung/exynos_tmu.c
> index ec01dfe..d201ed8 100644
> --- a/drivers/thermal/samsung/exynos_tmu.c
> +++ b/drivers/thermal/samsung/exynos_tmu.c
> @@ -265,7 +265,7 @@ skip_calib_data:
>                                 data->base + reg->threshold_th1);
>
>                 writel((reg->inten_rise_mask << reg->inten_rise_shift) |
> -                       (reg->inten_fall_mask << reg->inten_fall_shift),
> +                       (reg->inten_fall_mask << reg->intclr_fall_shift),
>                                 data->base + reg->tmu_intclear);
>
>                 /* if last threshold limit is also present */
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
>         u32     tmu_intstat;
>
>         u32     tmu_intclear;
> +       u32     intclr_fall_shift;
>
>         u32     emul_con;
>         u32     emul_temp_shift;
> diff --git a/drivers/thermal/samsung/exynos_tmu_data.c b/drivers/thermal/samsung/exynos_tmu_data.c
> index 9002499..23fea23 100644
> --- a/drivers/thermal/samsung/exynos_tmu_data.c
> +++ b/drivers/thermal/samsung/exynos_tmu_data.c
> @@ -122,6 +122,7 @@ static const struct exynos_tmu_registers exynos5250_tmu_registers = {
>         .inten_fall0_shift = EXYNOS_TMU_INTEN_FALL0_SHIFT,
>         .tmu_intstat = EXYNOS_TMU_REG_INTSTAT,
>         .tmu_intclear = EXYNOS_TMU_REG_INTCLEAR,
> +       .intclr_fall_shift = EXYNOS_TMU_CLEAR_FALL_INT_SHIFT,
>         .emul_con = EXYNOS_EMUL_CON,
>         .emul_temp_shift = EXYNOS_EMUL_DATA_SHIFT,
>         .emul_time_shift = EXYNOS_EMUL_TIME_SHIFT,
> @@ -210,6 +211,7 @@ static const struct exynos_tmu_registers exynos5440_tmu_registers = {
>         .inten_fall0_shift = EXYNOS5440_TMU_INTEN_FALL0_SHIFT,
>         .tmu_intstat = EXYNOS5440_TMU_S0_7_IRQ,
>         .tmu_intclear = EXYNOS5440_TMU_S0_7_IRQ,
> +       .intclr_fall_shift = EXYNOS_TMU_CLEAR_FALL_INT_SHIFT,
>         .tmu_irqstatus = EXYNOS5440_TMU_IRQ_STATUS,
>         .emul_con = EXYNOS5440_TMU_S0_7_DEBUG,
>         .emul_temp_shift = EXYNOS_EMUL_DATA_SHIFT,
> diff --git a/drivers/thermal/samsung/exynos_tmu_data.h b/drivers/thermal/samsung/exynos_tmu_data.h
> index dc7feb5..8788a87 100644
> --- a/drivers/thermal/samsung/exynos_tmu_data.h
> +++ b/drivers/thermal/samsung/exynos_tmu_data.h
> @@ -69,9 +69,10 @@
>  #define EXYNOS_TMU_RISE_INT_MASK       0x111
>  #define EXYNOS_TMU_RISE_INT_SHIFT      0
>  #define EXYNOS_TMU_FALL_INT_MASK       0x111
> -#define EXYNOS_TMU_FALL_INT_SHIFT      12
> +#define EXYNOS_TMU_FALL_INT_SHIFT      16
>  #define EXYNOS_TMU_CLEAR_RISE_INT      0x111
>  #define EXYNOS_TMU_CLEAR_FALL_INT      (0x111 << 12)
> +#define EXYNOS_TMU_CLEAR_FALL_INT_SHIFT        12
>  #define EXYNOS_TMU_TRIP_MODE_SHIFT     13
>  #define EXYNOS_TMU_TRIP_MODE_MASK      0x7
>  #define EXYNOS_TMU_THERM_TRIP_EN_SHIFT 12
> --
> 1.7.9.5
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-pm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

On Wed, Aug 28, 2013 at 11:15 AM, Naveen Krishna Chatradhi
<ch.naveen@samsung.com> wrote:
> The FALL interrupt related en, status bits are available at an offset of
> 16 on INTEN, INTSTAT registers and at an offset of
> 12 on INTCLEAR register.
>
> This patch corrects the same for exyns5250 and exynos5440
>
> Signed-off-by: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
> ---
>  drivers/thermal/samsung/exynos_tmu.c      |    2 +-
>  drivers/thermal/samsung/exynos_tmu.h      |    2 ++
>  drivers/thermal/samsung/exynos_tmu_data.c |    2 ++
>  drivers/thermal/samsung/exynos_tmu_data.h |    3 ++-
>  4 files changed, 7 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/thermal/samsung/exynos_tmu.c b/drivers/thermal/samsung/exynos_tmu.c
> index ec01dfe..d201ed8 100644
> --- a/drivers/thermal/samsung/exynos_tmu.c
> +++ b/drivers/thermal/samsung/exynos_tmu.c
> @@ -265,7 +265,7 @@ skip_calib_data:
>                                 data->base + reg->threshold_th1);
>
>                 writel((reg->inten_rise_mask << reg->inten_rise_shift) |
> -                       (reg->inten_fall_mask << reg->inten_fall_shift),
> +                       (reg->inten_fall_mask << reg->intclr_fall_shift),
>                                 data->base + reg->tmu_intclear);
>
>                 /* if last threshold limit is also present */
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
>         u32     tmu_intstat;
>
>         u32     tmu_intclear;
> +       u32     intclr_fall_shift;
>
>         u32     emul_con;
>         u32     emul_temp_shift;
> diff --git a/drivers/thermal/samsung/exynos_tmu_data.c b/drivers/thermal/samsung/exynos_tmu_data.c
> index 9002499..23fea23 100644
> --- a/drivers/thermal/samsung/exynos_tmu_data.c
> +++ b/drivers/thermal/samsung/exynos_tmu_data.c
> @@ -122,6 +122,7 @@ static const struct exynos_tmu_registers exynos5250_tmu_registers = {
>         .inten_fall0_shift = EXYNOS_TMU_INTEN_FALL0_SHIFT,
>         .tmu_intstat = EXYNOS_TMU_REG_INTSTAT,
>         .tmu_intclear = EXYNOS_TMU_REG_INTCLEAR,
> +       .intclr_fall_shift = EXYNOS_TMU_CLEAR_FALL_INT_SHIFT,
>         .emul_con = EXYNOS_EMUL_CON,
>         .emul_temp_shift = EXYNOS_EMUL_DATA_SHIFT,
>         .emul_time_shift = EXYNOS_EMUL_TIME_SHIFT,
> @@ -210,6 +211,7 @@ static const struct exynos_tmu_registers exynos5440_tmu_registers = {
>         .inten_fall0_shift = EXYNOS5440_TMU_INTEN_FALL0_SHIFT,
>         .tmu_intstat = EXYNOS5440_TMU_S0_7_IRQ,
>         .tmu_intclear = EXYNOS5440_TMU_S0_7_IRQ,
> +       .intclr_fall_shift = EXYNOS_TMU_CLEAR_FALL_INT_SHIFT,
>         .tmu_irqstatus = EXYNOS5440_TMU_IRQ_STATUS,
>         .emul_con = EXYNOS5440_TMU_S0_7_DEBUG,
>         .emul_temp_shift = EXYNOS_EMUL_DATA_SHIFT,
> diff --git a/drivers/thermal/samsung/exynos_tmu_data.h b/drivers/thermal/samsung/exynos_tmu_data.h
> index dc7feb5..8788a87 100644
> --- a/drivers/thermal/samsung/exynos_tmu_data.h
> +++ b/drivers/thermal/samsung/exynos_tmu_data.h
> @@ -69,9 +69,10 @@
>  #define EXYNOS_TMU_RISE_INT_MASK       0x111
>  #define EXYNOS_TMU_RISE_INT_SHIFT      0
>  #define EXYNOS_TMU_FALL_INT_MASK       0x111
> -#define EXYNOS_TMU_FALL_INT_SHIFT      12
> +#define EXYNOS_TMU_FALL_INT_SHIFT      16
>  #define EXYNOS_TMU_CLEAR_RISE_INT      0x111
>  #define EXYNOS_TMU_CLEAR_FALL_INT      (0x111 << 12)
> +#define EXYNOS_TMU_CLEAR_FALL_INT_SHIFT        12
>  #define EXYNOS_TMU_TRIP_MODE_SHIFT     13
>  #define EXYNOS_TMU_TRIP_MODE_MASK      0x7
>  #define EXYNOS_TMU_THERM_TRIP_EN_SHIFT 12
> --
> 1.7.9.5
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-pm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
