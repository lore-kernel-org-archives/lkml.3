Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753462AbaG2NkK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 09:40:10 -0400
Received: from mail-vc0-f173.google.com ([209.85.220.173]:64908 "EHLO
	mail-vc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751151AbaG2NkG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 09:40:06 -0400
Date: Tue, 29 Jul 2014 09:39:31 -0400
From: Eduardo Valentin <edubezval@gmail.com>
To: amit daniel kachhap <amit.daniel@samsung.com>, b.zolnierkie@samsung.com
Cc: Zhang Rui <rui.zhang@intel.com>, Chanwoo Choi <cw00.choi@samsung.com>,
        Mark Rutland <mark.rutland@arm.com>, devicetree@vger.kernel.org,
        Jonghwa Lee <jonghwa3.lee@samsung.com>,
        Kukjin Kim <kgene.kim@samsung.com>, pawel.moll@arm.com,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>, eduardo.valentin@gmail.com,
        Kumar Gala <galak@codeaurora.org>,
        naveen krishna <ch.naveen@samsung.com>,
        LAK <linux-arm-kernel@lists.infradead.org>
Subject: Re: [RESEND PATCH] thermal: samsung: Add TMU support for Exynos3250
 SoC
Message-ID: <20140729133931.GC3336@developer>
References: <1405641605-3370-1-git-send-email-cw00.choi@samsung.com>
 <1405922696.2455.1.camel@rzhang1-toshiba>
 <CADGdYn5Druo7D7QeiiAGHaJxMiyB0uvAiPw+K6aG-xYgNHa8sQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CADGdYn5Druo7D7QeiiAGHaJxMiyB0uvAiPw+K6aG-xYgNHa8sQ@mail.gmail.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 22, 2014 at 11:41:56AM +0530, amit daniel kachhap wrote:
> On Mon, Jul 21, 2014 at 11:34 AM, Zhang Rui <rui.zhang@intel.com> wrote:
> > On Fri, 2014-07-18 at 09:00 +0900, Chanwoo Choi wrote:
> >> This patch adds the registers, bit fields and compatible strings
> >> required to support for the 1 TMU channels on Exynos3250.
> >>
> >> Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
> >> [Add MUX address setting bits by Jonghwa Lee]
> >> Signed-off-by: Jonghwa Lee <jonghwa3.lee@samsung.com>
> >> Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
> >> Reviewed-by: Amit Daniel Kachhap<amit.daniel@samsung.com>
> >
> > Eduardo and Amit,
> >
> > do you have any comments on this?
> The changes looks fine to me. I already reviewed these patches earlier.


Bartlomiej, can you please rebase your work on top of this one?

> 
> thanks,
> Amit
> >
> > thanks,
> > rui
> >
> >> ---
> >>  .../devicetree/bindings/thermal/exynos-thermal.txt |  1 +
> >>  drivers/thermal/samsung/exynos_tmu.c               |  7 +-
> >>  drivers/thermal/samsung/exynos_tmu.h               |  3 +-
> >>  drivers/thermal/samsung/exynos_tmu_data.c          | 89 ++++++++++++++++++++++
> >>  drivers/thermal/samsung/exynos_tmu_data.h          |  7 ++
> >>  5 files changed, 105 insertions(+), 2 deletions(-)
> >>
> >> diff --git a/Documentation/devicetree/bindings/thermal/exynos-thermal.txt b/Documentation/devicetree/bindings/thermal/exynos-thermal.txt
> >> index c949092..ae738f5 100644
> >> --- a/Documentation/devicetree/bindings/thermal/exynos-thermal.txt
> >> +++ b/Documentation/devicetree/bindings/thermal/exynos-thermal.txt
> >> @@ -3,6 +3,7 @@
> >>  ** Required properties:
> >>
> >>  - compatible : One of the following:
> >> +            "samsung,exynos3250-tmu"
> >>              "samsung,exynos4412-tmu"
> >>              "samsung,exynos4210-tmu"
> >>              "samsung,exynos5250-tmu"
> >> diff --git a/drivers/thermal/samsung/exynos_tmu.c b/drivers/thermal/samsung/exynos_tmu.c
> >> index d7ca9f4..a2a08ea 100644
> >> --- a/drivers/thermal/samsung/exynos_tmu.c
> >> +++ b/drivers/thermal/samsung/exynos_tmu.c
> >> @@ -505,6 +505,10 @@ static irqreturn_t exynos_tmu_irq(int irq, void *id)
> >>
> >>  static const struct of_device_id exynos_tmu_match[] = {
> >>       {
> >> +             .compatible = "samsung,exynos3250-tmu",
> >> +             .data = (void *)EXYNOS3250_TMU_DRV_DATA,
> >> +     },
> >> +     {
> >>               .compatible = "samsung,exynos4210-tmu",
> >>               .data = (void *)EXYNOS4210_TMU_DRV_DATA,
> >>       },
> >> @@ -677,7 +681,8 @@ static int exynos_tmu_probe(struct platform_device *pdev)
> >>               goto err_clk_sec;
> >>       }
> >>
> >> -     if (pdata->type == SOC_ARCH_EXYNOS4210 ||
> >> +     if (pdata->type == SOC_ARCH_EXYNOS3250 ||
> >> +         pdata->type == SOC_ARCH_EXYNOS4210 ||
> >>           pdata->type == SOC_ARCH_EXYNOS4412 ||
> >>           pdata->type == SOC_ARCH_EXYNOS5250 ||
> >>           pdata->type == SOC_ARCH_EXYNOS5260 ||
> >> diff --git a/drivers/thermal/samsung/exynos_tmu.h b/drivers/thermal/samsung/exynos_tmu.h
> >> index edd08cf..1b4a644 100644
> >> --- a/drivers/thermal/samsung/exynos_tmu.h
> >> +++ b/drivers/thermal/samsung/exynos_tmu.h
> >> @@ -40,7 +40,8 @@ enum calibration_mode {
> >>  };
> >>
> >>  enum soc_type {
> >> -     SOC_ARCH_EXYNOS4210 = 1,
> >> +     SOC_ARCH_EXYNOS3250 = 1,
> >> +     SOC_ARCH_EXYNOS4210,
> >>       SOC_ARCH_EXYNOS4412,
> >>       SOC_ARCH_EXYNOS5250,
> >>       SOC_ARCH_EXYNOS5260,
> >> diff --git a/drivers/thermal/samsung/exynos_tmu_data.c b/drivers/thermal/samsung/exynos_tmu_data.c
> >> index c1d81dc..aa8e0de 100644
> >> --- a/drivers/thermal/samsung/exynos_tmu_data.c
> >> +++ b/drivers/thermal/samsung/exynos_tmu_data.c
> >> @@ -90,6 +90,95 @@ struct exynos_tmu_init_data const exynos4210_default_tmu_data = {
> >>  };
> >>  #endif
> >>
> >> +#if defined(CONFIG_SOC_EXYNOS3250)
> >> +static const struct exynos_tmu_registers exynos3250_tmu_registers = {
> >> +     .triminfo_data = EXYNOS_TMU_REG_TRIMINFO,
> >> +     .triminfo_25_shift = EXYNOS_TRIMINFO_25_SHIFT,
> >> +     .triminfo_85_shift = EXYNOS_TRIMINFO_85_SHIFT,
> >> +     .tmu_ctrl = EXYNOS_TMU_REG_CONTROL,
> >> +     .test_mux_addr_shift = EXYNOS4412_MUX_ADDR_SHIFT,
> >> +     .buf_vref_sel_shift = EXYNOS_TMU_REF_VOLTAGE_SHIFT,
> >> +     .buf_vref_sel_mask = EXYNOS_TMU_REF_VOLTAGE_MASK,
> >> +     .therm_trip_mode_shift = EXYNOS_TMU_TRIP_MODE_SHIFT,
> >> +     .therm_trip_mode_mask = EXYNOS_TMU_TRIP_MODE_MASK,
> >> +     .therm_trip_en_shift = EXYNOS_TMU_THERM_TRIP_EN_SHIFT,
> >> +     .buf_slope_sel_shift = EXYNOS_TMU_BUF_SLOPE_SEL_SHIFT,
> >> +     .buf_slope_sel_mask = EXYNOS_TMU_BUF_SLOPE_SEL_MASK,
> >> +     .core_en_shift = EXYNOS_TMU_CORE_EN_SHIFT,
> >> +     .tmu_status = EXYNOS_TMU_REG_STATUS,
> >> +     .tmu_cur_temp = EXYNOS_TMU_REG_CURRENT_TEMP,
> >> +     .threshold_th0 = EXYNOS_THD_TEMP_RISE,
> >> +     .threshold_th1 = EXYNOS_THD_TEMP_FALL,
> >> +     .tmu_inten = EXYNOS_TMU_REG_INTEN,
> >> +     .inten_rise0_shift = EXYNOS_TMU_INTEN_RISE0_SHIFT,
> >> +     .inten_rise1_shift = EXYNOS_TMU_INTEN_RISE1_SHIFT,
> >> +     .inten_rise2_shift = EXYNOS_TMU_INTEN_RISE2_SHIFT,
> >> +     .inten_fall0_shift = EXYNOS_TMU_INTEN_FALL0_SHIFT,
> >> +     .tmu_intstat = EXYNOS_TMU_REG_INTSTAT,
> >> +     .tmu_intclear = EXYNOS_TMU_REG_INTCLEAR,
> >> +     .intclr_fall_shift = EXYNOS_TMU_CLEAR_FALL_INT_SHIFT,
> >> +     .intclr_rise_shift = EXYNOS_TMU_RISE_INT_SHIFT,
> >> +     .intclr_rise_mask = EXYNOS_TMU_RISE_INT_MASK,
> >> +     .intclr_fall_mask = EXYNOS_TMU_FALL_INT_MASK,
> >> +     .emul_con = EXYNOS_EMUL_CON,
> >> +     .emul_temp_shift = EXYNOS_EMUL_DATA_SHIFT,
> >> +     .emul_time_shift = EXYNOS_EMUL_TIME_SHIFT,
> >> +     .emul_time_mask = EXYNOS_EMUL_TIME_MASK,
> >> +};
> >> +
> >> +#define EXYNOS3250_TMU_DATA \
> >> +     .threshold_falling = 10, \
> >> +     .trigger_levels[0] = 70, \
> >> +     .trigger_levels[1] = 95, \
> >> +     .trigger_levels[2] = 110, \
> >> +     .trigger_levels[3] = 120, \
> >> +     .trigger_enable[0] = true, \
> >> +     .trigger_enable[1] = true, \
> >> +     .trigger_enable[2] = true, \
> >> +     .trigger_enable[3] = false, \
> >> +     .trigger_type[0] = THROTTLE_ACTIVE, \
> >> +     .trigger_type[1] = THROTTLE_ACTIVE, \
> >> +     .trigger_type[2] = SW_TRIP, \
> >> +     .trigger_type[3] = HW_TRIP, \
> >> +     .max_trigger_level = 4, \
> >> +     .gain = 8, \
> >> +     .reference_voltage = 16, \
> >> +     .noise_cancel_mode = 4, \
> >> +     .cal_type = TYPE_TWO_POINT_TRIMMING, \
> >> +     .efuse_value = 55, \
> >> +     .min_efuse_value = 40, \
> >> +     .max_efuse_value = 100, \
> >> +     .first_point_trim = 25, \
> >> +     .second_point_trim = 85, \
> >> +     .default_temp_offset = 50, \
> >> +     .freq_tab[0] = { \
> >> +             .freq_clip_max = 800 * 1000, \
> >> +             .temp_level = 70, \
> >> +     }, \
> >> +     .freq_tab[1] = { \
> >> +             .freq_clip_max = 400 * 1000, \
> >> +             .temp_level = 95, \
> >> +     }, \
> >> +     .freq_tab_count = 2, \
> >> +     .registers = &exynos3250_tmu_registers, \
> >> +     .features = (TMU_SUPPORT_EMULATION | \
> >> +                     TMU_SUPPORT_FALLING_TRIP | TMU_SUPPORT_READY_STATUS | \
> >> +                     TMU_SUPPORT_EMUL_TIME)
> >> +#endif
> >> +
> >> +#if defined(CONFIG_SOC_EXYNOS3250)
> >> +struct exynos_tmu_init_data const exynos3250_default_tmu_data = {
> >> +     .tmu_data = {
> >> +             {
> >> +                     EXYNOS3250_TMU_DATA,
> >> +                     .type = SOC_ARCH_EXYNOS3250,
> >> +                     .test_mux = EXYNOS4412_MUX_ADDR_VALUE,
> >> +             },
> >> +     },
> >> +     .tmu_count = 1,
> >> +};
> >> +#endif
> >> +
> >>  #if defined(CONFIG_SOC_EXYNOS4412) || defined(CONFIG_SOC_EXYNOS5250)
> >>  static const struct exynos_tmu_registers exynos4412_tmu_registers = {
> >>       .triminfo_data = EXYNOS_TMU_REG_TRIMINFO,
> >> diff --git a/drivers/thermal/samsung/exynos_tmu_data.h b/drivers/thermal/samsung/exynos_tmu_data.h
> >> index d268981..f0979e5 100644
> >> --- a/drivers/thermal/samsung/exynos_tmu_data.h
> >> +++ b/drivers/thermal/samsung/exynos_tmu_data.h
> >> @@ -148,6 +148,13 @@
> >>  #define EXYNOS5440_TMU_TH_RISE4_SHIFT                24
> >>  #define EXYNOS5440_EFUSE_SWAP_OFFSET         8
> >>
> >> +#if defined(CONFIG_SOC_EXYNOS3250)
> >> +extern struct exynos_tmu_init_data const exynos3250_default_tmu_data;
> >> +#define EXYNOS3250_TMU_DRV_DATA (&exynos3250_default_tmu_data)
> >> +#else
> >> +#define EXYNOS3250_TMU_DRV_DATA (NULL)
> >> +#endif
> >> +
> >>  #if defined(CONFIG_CPU_EXYNOS4210)
> >>  extern struct exynos_tmu_init_data const exynos4210_default_tmu_data;
> >>  #define EXYNOS4210_TMU_DRV_DATA (&exynos4210_default_tmu_data)
> >
> >
> >
> > _______________________________________________
> > linux-arm-kernel mailing list
> > linux-arm-kernel@lists.infradead.org
> > http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
> --
> To unsubscribe from this list: send the line "unsubscribe linux-pm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
