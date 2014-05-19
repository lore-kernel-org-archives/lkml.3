Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750832AbaESFMU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 01:12:20 -0400
Received: from mail-yh0-f46.google.com ([209.85.213.46]:40699 "EHLO
	mail-yh0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750727AbaESFMS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 01:12:18 -0400
MIME-Version: 1.0
In-Reply-To: <1399288539-1793-2-git-send-email-b.zolnierkie@samsung.com>
References: <1399288539-1793-1-git-send-email-b.zolnierkie@samsung.com>
	<1399288539-1793-2-git-send-email-b.zolnierkie@samsung.com>
Date: Mon, 19 May 2014 10:42:17 +0530
Message-ID: <CADGdYn69-+uaHwh7YEMjOXG=b6tTMSg9=KS=OV8ZiQVDLD8GOw@mail.gmail.com>
Subject: Re: [PATCH 01/10] thermal: exynos: remove unused struct
 exynos_tmu_registers entries
From: Amit Kachhap <amit.kachhap@gmail.com>
To: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Cc: Eduardo Valentin <eduardo.valentin@ti.com>,
        Zhang Rui <rui.zhang@intel.com>, Tomasz Figa <t.figa@samsung.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-samsung-soc@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Bartlomiej,

On 5/5/14, Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com> wrote:
> There should be no functional changes caused by this patch.
>
> Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
> ---
>  drivers/thermal/samsung/exynos_tmu.h      | 40
> -------------------------------
>  drivers/thermal/samsung/exynos_tmu_data.c |  2 --
>  drivers/thermal/samsung/exynos_tmu_data.h |  1 -
>  3 files changed, 43 deletions(-)
>
> diff --git a/drivers/thermal/samsung/exynos_tmu.h
> b/drivers/thermal/samsung/exynos_tmu.h
> index 3fb6554..80dc899 100644
> --- a/drivers/thermal/samsung/exynos_tmu.h
> +++ b/drivers/thermal/samsung/exynos_tmu.h
> @@ -82,8 +82,6 @@ enum soc_type {
>   * @triminfo_25_shift: shift bit of the 25 C trim value in triminfo_data
> reg.
>   * @triminfo_85_shift: shift bit of the 85 C trim value in triminfo_data
> reg.
>   * @triminfo_ctrl: trim info controller register.
> - * @triminfo_reload_shift: shift of triminfo reload enable bit in
> triminfo_ctrl
> -	reg.
>   * @tmu_ctrl: TMU main controller register.
>   * @test_mux_addr_shift: shift bits of test mux address.
>   * @buf_vref_sel_shift: shift bits of reference voltage in tmu_ctrl
> register.
> @@ -98,27 +96,13 @@ enum soc_type {
>  	register.
>   * @calib_mode_mask: mask bits of calibration mode value in tmu_ctrl
>  	register.
> - * @therm_trip_tq_en_shift: shift bits of thermal trip enable by TQ pin in
> -	tmu_ctrl register.
>   * @core_en_shift: shift bits of TMU core enable bit in tmu_ctrl register.
>   * @tmu_status: register drescribing the TMU status.
>   * @tmu_cur_temp: register containing the current temperature of the TMU.
> - * @tmu_cur_temp_shift: shift bits of current temp value in tmu_cur_temp
> -	register.
>   * @threshold_temp: register containing the base threshold level.
>   * @threshold_th0: Register containing first set of rising levels.
> - * @threshold_th0_l0_shift: shift bits of level0 threshold temperature.
> - * @threshold_th0_l1_shift: shift bits of level1 threshold temperature.
> - * @threshold_th0_l2_shift: shift bits of level2 threshold temperature.
> - * @threshold_th0_l3_shift: shift bits of level3 threshold temperature.
>   * @threshold_th1: Register containing second set of rising levels.
> - * @threshold_th1_l0_shift: shift bits of level0 threshold temperature.
> - * @threshold_th1_l1_shift: shift bits of level1 threshold temperature.
> - * @threshold_th1_l2_shift: shift bits of level2 threshold temperature.
> - * @threshold_th1_l3_shift: shift bits of level3 threshold temperature.
>   * @threshold_th2: Register containing third set of rising levels.
> - * @threshold_th2_l0_shift: shift bits of level0 threshold temperature.
> - * @threshold_th3: Register containing fourth set of rising levels.
>   * @threshold_th3_l0_shift: shift bits of level0 threshold temperature.
>   * @tmu_inten: register containing the different threshold interrupt
>  	enable bits.
> @@ -131,15 +115,11 @@ enum soc_type {
>   * @inten_rise2_shift: shift bits of rising 2 interrupt bits.
>   * @inten_rise3_shift: shift bits of rising 3 interrupt bits.
>   * @inten_fall0_shift: shift bits of falling 0 interrupt bits.
> - * @inten_fall1_shift: shift bits of falling 1 interrupt bits.
> - * @inten_fall2_shift: shift bits of falling 2 interrupt bits.
> - * @inten_fall3_shift: shift bits of falling 3 interrupt bits.
>   * @tmu_intstat: Register containing the interrupt status values.
>   * @tmu_intclear: Register for clearing the raised interrupt status.
>   * @emul_con: TMU emulation controller register.
>   * @emul_temp_shift: shift bits of emulation temperature.
>   * @emul_time_shift: shift bits of emulation time.
> - * @emul_time_mask: mask bits of emulation time.
>   * @tmu_irqstatus: register to find which TMU generated interrupts.
>   * @tmu_pmin: register to get/set the Pmin value.

I prefer to have these register description as they describe the h/w
and are used for capturing those parameters. My argument here is that
adding new soc should have minimum changes. However some unused macros
removed below makes sense.
>   */
> @@ -149,7 +129,6 @@ struct exynos_tmu_registers {
>  	u32	triminfo_85_shift;
>
>  	u32	triminfo_ctrl;
> -	u32	triminfo_reload_shift;
>
>  	u32	tmu_ctrl;
>  	u32     test_mux_addr_shift;
> @@ -162,32 +141,17 @@ struct exynos_tmu_registers {
>  	u32	buf_slope_sel_mask;
>  	u32	calib_mode_shift;
>  	u32	calib_mode_mask;
> -	u32	therm_trip_tq_en_shift;
>  	u32	core_en_shift;
>
>  	u32	tmu_status;
>
>  	u32	tmu_cur_temp;
> -	u32	tmu_cur_temp_shift;
>
>  	u32	threshold_temp;
>
>  	u32	threshold_th0;
> -	u32	threshold_th0_l0_shift;
> -	u32	threshold_th0_l1_shift;
> -	u32	threshold_th0_l2_shift;
> -	u32	threshold_th0_l3_shift;
> -
>  	u32	threshold_th1;
> -	u32	threshold_th1_l0_shift;
> -	u32	threshold_th1_l1_shift;
> -	u32	threshold_th1_l2_shift;
> -	u32	threshold_th1_l3_shift;
> -
>  	u32	threshold_th2;
> -	u32	threshold_th2_l0_shift;
> -
> -	u32	threshold_th3;
>  	u32	threshold_th3_l0_shift;
>
>  	u32	tmu_inten;
> @@ -200,9 +164,6 @@ struct exynos_tmu_registers {
>  	u32	inten_rise2_shift;
>  	u32	inten_rise3_shift;
>  	u32	inten_fall0_shift;
> -	u32	inten_fall1_shift;
> -	u32	inten_fall2_shift;
> -	u32	inten_fall3_shift;
>
>  	u32	tmu_intstat;
>
> @@ -211,7 +172,6 @@ struct exynos_tmu_registers {
>  	u32	emul_con;
>  	u32	emul_temp_shift;
>  	u32	emul_time_shift;
> -	u32	emul_time_mask;
>
>  	u32	tmu_irqstatus;
>  	u32	tmu_pmin;
> diff --git a/drivers/thermal/samsung/exynos_tmu_data.c
> b/drivers/thermal/samsung/exynos_tmu_data.c
> index 476b768..36d64d6 100644
> --- a/drivers/thermal/samsung/exynos_tmu_data.c
> +++ b/drivers/thermal/samsung/exynos_tmu_data.c
> @@ -96,7 +96,6 @@ static const struct exynos_tmu_registers
> exynos4412_tmu_registers = {
>  	.triminfo_25_shift = EXYNOS_TRIMINFO_25_SHIFT,
>  	.triminfo_85_shift = EXYNOS_TRIMINFO_85_SHIFT,
>  	.triminfo_ctrl = EXYNOS_TMU_TRIMINFO_CON,
> -	.triminfo_reload_shift = EXYNOS_TRIMINFO_RELOAD_SHIFT,
>  	.tmu_ctrl = EXYNOS_TMU_REG_CONTROL,
>  	.test_mux_addr_shift = EXYNOS4412_MUX_ADDR_SHIFT,
>  	.buf_vref_sel_shift = EXYNOS_TMU_REF_VOLTAGE_SHIFT,
> @@ -126,7 +125,6 @@ static const struct exynos_tmu_registers
> exynos4412_tmu_registers = {
>  	.emul_con = EXYNOS_EMUL_CON,
>  	.emul_temp_shift = EXYNOS_EMUL_DATA_SHIFT,
>  	.emul_time_shift = EXYNOS_EMUL_TIME_SHIFT,
> -	.emul_time_mask = EXYNOS_EMUL_TIME_MASK,
Makes sense.
>  };
>
>  #define EXYNOS4412_TMU_DATA \
> diff --git a/drivers/thermal/samsung/exynos_tmu_data.h
> b/drivers/thermal/samsung/exynos_tmu_data.h
> index a1ea19d..06c4345 100644
> --- a/drivers/thermal/samsung/exynos_tmu_data.h
> +++ b/drivers/thermal/samsung/exynos_tmu_data.h
> @@ -63,7 +63,6 @@
>  #define EXYNOS_THD_TEMP_FALL		0x54
>  #define EXYNOS_EMUL_CON		0x80
>
> -#define EXYNOS_TRIMINFO_RELOAD_SHIFT	1
make sense.

>  #define EXYNOS_TRIMINFO_25_SHIFT	0
>  #define EXYNOS_TRIMINFO_85_SHIFT	8
>  #define EXYNOS_TMU_RISE_INT_MASK	0x111
> --
> 1.8.2.3
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-samsung-soc"
> in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
