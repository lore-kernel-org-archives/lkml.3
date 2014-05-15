Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754028AbaEOPfk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 11:35:40 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:42895 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751174AbaEOPfY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 11:35:24 -0400
X-AuditID: cbfee61a-b7f2b6d000006c4d-23-5374deb9ce72
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Eduardo Valentin <edubezval@gmail.com>
Cc: Eduardo Valentin <eduardo.valentin@ti.com>,
        Zhang Rui <rui.zhang@intel.com>,
        Amit Daniel Kachhap <amit.daniel@samsung.com>,
        Tomasz Figa <t.figa@samsung.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-samsung-soc@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 04/10] thermal: exynos: remove dead code for
 TYPE_TWO_POINT_TRIMMING calibration
Date: Thu, 15 May 2014 17:35:02 +0200
Message-id: <1966594.GSvIsYJh8q@amdc1032>
User-Agent: KMail/4.8.4 (Linux/3.2.0-54-generic-pae; KDE/4.8.5; i686; ; )
In-reply-to: <20140515143004.GC27339@developer>
References: <1399288539-1793-1-git-send-email-b.zolnierkie@samsung.com>
 <1399288539-1793-5-git-send-email-b.zolnierkie@samsung.com>
 <20140515143004.GC27339@developer>
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=us-ascii
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrALMWRmVeSWpSXmKPExsVy+t9jQd1d90qCDXp2MVs0XA2xWLP/J5PF
	/CvXWC3ONr1ht7i8aw6bxefeI4wWM87vY7I4c/oSq8WTh31sFutnvGZx4PLYOesuu8fiPS+Z
	PLZcbWfx6NuyitHj+I3tTB6fN8kFsEVx2aSk5mSWpRbp2yVwZZx59Ji1YH16xdu+FuYGxg9B
	XYycHBICJhKz5k9ig7DFJC7cWw9kc3EICUxnlNjyYCkzhNPCJLFm129GkCo2ASuJie2rwGwR
	AS2JE5e2M4EUMQvcZJI4/OsHSxcjB4ewQJrEjjVFIDUsAqoSz7ddYgKxeQU0JZ50vgHrFRXw
	lNixfSXYZk4BfYklHX/ZIZatYpR4O30iVIOgxI/J91hAbGYBeYl9+6eyQthaEut3HmeawCgw
	C0nZLCRls5CULWBkXsUomlqQXFCclJ5rqFecmFtcmpeul5yfu4kRHA/PpHYwrmywOMQowMGo
	xMPLMLk4WIg1say4MvcQowQHs5IIb/KVkmAh3pTEyqrUovz4otKc1OJDjNIcLErivAdarQOF
	BNITS1KzU1MLUotgskwcnFINjPudcxqeTti6u6zz5d4Ah0+TDJ56Mp8M/qA2gdV00i7ZRS1a
	gpmNcW/WzfVf4vnYc/ry9uiWKzf+/bvyL/Is+7p7U4pTl2/LZH549/bMDSW7ku2iDHZ3NvWZ
	hDGoxob/Cp95zfhG0eva1fUr1h6Y2X/51QkV/dXKK5+sd3XQ+pRTsiBK4rLTFXYlluKMREMt
	5qLiRADvRhPHgwIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thursday, May 15, 2014 10:31:33 AM Eduardo Valentin wrote:
> Hello Bartlomiej,

Hi,

> On Mon, May 05, 2014 at 01:15:33PM +0200, Bartlomiej Zolnierkiewicz wrote:
> > Only TYPE_ONE_POINT_TRIMMING calibration is used so remove
> > the dead code for TYPE_TWO_POINT_TRIMMING calibration.
> > 
> 
> Only TYPE_ONE_POINT_TRIMMING is used by which SoC? This patch removes

TYPE_ONE_POINT_TRIMMING is used by all Exynos SoCs currently.

> all four types of calibrations, as present in the current code. Is this
> the expected outcome?

There are only two types of calibration (TYPE_ONE_POINT_TRIMMING and
TYPE_TWO_POINT_TRIMMING) implemented in the driver currently, the other
ones (TYPE_ONE_POINT_TRIMMING_25 and TYPE_ONE_POINT_TRIMMING_85) are
defined in calibration_type enum but are not implemented.

> According to commit 9d97e5c8, which introduced this feature,
> TYPE_TWO_POINT_TRIMMING is supported by exynos4 tmu, as per code
> history, for instance.

The commit 9d97e5c8 (which is from Wed Sep 7 18:49:08 2011) introduced
TYPE_TWO_POINT_TRIMMING implementation but no users of it have ever been
added.  IOW it has been a dead code for over 2.5 years now.

> > There should be no functional changes caused by this patch.
> > 
> 
> Well, the patch seams to be doing more than removing type two trimming.

It does related dead code removals.  I can improve the patch description
if needed to be more verbose but it doesn't change the fact that the patch
doesn't contain any functional changes.

> > Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
> > ---
> >  drivers/thermal/samsung/exynos_tmu.c      | 55 ++++++-------------------------
> >  drivers/thermal/samsung/exynos_tmu.h      | 20 +----------
> >  drivers/thermal/samsung/exynos_tmu_data.c | 17 +---------
> >  drivers/thermal/samsung/exynos_tmu_data.h |  2 --
> >  4 files changed, 12 insertions(+), 82 deletions(-)
> > 
> > diff --git a/drivers/thermal/samsung/exynos_tmu.c b/drivers/thermal/samsung/exynos_tmu.c
> > index 9f2a5ee..903566f 100644
> > --- a/drivers/thermal/samsung/exynos_tmu.c
> > +++ b/drivers/thermal/samsung/exynos_tmu.c
> > @@ -47,8 +47,7 @@
> >   * @irq_work: pointer to the irq work structure.
> >   * @lock: lock to implement synchronization.
> >   * @clk: pointer to the clock structure.
> > - * @temp_error1: fused value of the first point trim.
> > - * @temp_error2: fused value of the second point trim.
> > + * @temp_error: fused value of the first point trim.
> >   * @regulator: pointer to the TMU regulator structure.
> >   * @reg_conf: pointer to structure to register with core thermal.
> >   */
> > @@ -62,14 +61,13 @@ struct exynos_tmu_data {
> >  	struct work_struct irq_work;
> >  	struct mutex lock;
> >  	struct clk *clk;
> > -	u8 temp_error1, temp_error2;
> > +	u8 temp_error;
> >  	struct regulator *regulator;
> >  	struct thermal_sensor_conf *reg_conf;
> >  };
> >  
> >  /*
> >   * TMU treats temperature as a mapped temperature code.
> > - * The temperature is converted differently depending on the calibration type.
> >   */
> >  static int temp_to_code(struct exynos_tmu_data *data, u8 temp)
> >  {
> > @@ -83,20 +81,7 @@ static int temp_to_code(struct exynos_tmu_data *data, u8 temp)
> >  			goto out;
> >  		}
> >  
> > -	switch (pdata->cal_type) {
> > -	case TYPE_TWO_POINT_TRIMMING:
> > -		temp_code = (temp - pdata->first_point_trim) *
> > -			(data->temp_error2 - data->temp_error1) /
> > -			(pdata->second_point_trim - pdata->first_point_trim) +
> > -			data->temp_error1;
> > -		break;
> > -	case TYPE_ONE_POINT_TRIMMING:
> > -		temp_code = temp + data->temp_error1 - pdata->first_point_trim;
> > -		break;
> > -	default:
> > -		temp_code = temp + pdata->default_temp_offset;
> > -		break;
> > -	}
> > +	temp_code = temp + data->temp_error - pdata->first_point_trim;
> >  out:
> >  	return temp_code;
> >  }
> > @@ -117,20 +102,7 @@ static int code_to_temp(struct exynos_tmu_data *data, u8 temp_code)
> >  			goto out;
> >  		}
> >  
> > -	switch (pdata->cal_type) {
> > -	case TYPE_TWO_POINT_TRIMMING:
> > -		temp = (temp_code - data->temp_error1) *
> > -			(pdata->second_point_trim - pdata->first_point_trim) /
> > -			(data->temp_error2 - data->temp_error1) +
> > -			pdata->first_point_trim;
> > -		break;
> > -	case TYPE_ONE_POINT_TRIMMING:
> > -		temp = temp_code - data->temp_error1 + pdata->first_point_trim;
> > -		break;
> > -	default:
> > -		temp = temp_code - pdata->default_temp_offset;
> > -		break;
> > -	}
> > +	temp = temp_code - data->temp_error + pdata->first_point_trim;
> >  out:
> >  	return temp;
> >  }
> > @@ -179,19 +151,12 @@ static int exynos_tmu_initialize(struct platform_device *pdev)
> >  	} else {
> >  		trim_info = readl(data->base + reg->triminfo_data);
> >  	}
> > -	data->temp_error1 = trim_info & EXYNOS_TMU_TEMP_MASK;
> > -	data->temp_error2 = ((trim_info >> reg->triminfo_85_shift) &
> > -				EXYNOS_TMU_TEMP_MASK);
> > -
> > -	if (!data->temp_error1 ||
> > -		(pdata->min_efuse_value > data->temp_error1) ||
> > -		(data->temp_error1 > pdata->max_efuse_value))
> > -		data->temp_error1 = pdata->efuse_value & EXYNOS_TMU_TEMP_MASK;
> > -
> > -	if (!data->temp_error2)
> > -		data->temp_error2 =
> > -			(pdata->efuse_value >> reg->triminfo_85_shift) &
> > -			EXYNOS_TMU_TEMP_MASK;
> > +	data->temp_error = trim_info & EXYNOS_TMU_TEMP_MASK;
> > +
> > +	if (!data->temp_error ||
> > +	    pdata->min_efuse_value > data->temp_error ||
> > +	    data->temp_error > pdata->max_efuse_value)
> > +		data->temp_error = pdata->efuse_value & EXYNOS_TMU_TEMP_MASK;
> >  
> >  	if (pdata->max_trigger_level > MAX_THRESHOLD_LEVS) {
> >  		dev_err(&pdev->dev, "Invalid max trigger level\n");
> > diff --git a/drivers/thermal/samsung/exynos_tmu.h b/drivers/thermal/samsung/exynos_tmu.h
> > index e417af8..186e39e 100644
> > --- a/drivers/thermal/samsung/exynos_tmu.h
> > +++ b/drivers/thermal/samsung/exynos_tmu.h
> > @@ -26,14 +26,6 @@
> >  
> >  #include "exynos_thermal_common.h"
> >  
> > -enum calibration_type {
> > -	TYPE_ONE_POINT_TRIMMING,
> > -	TYPE_ONE_POINT_TRIMMING_25,
> > -	TYPE_ONE_POINT_TRIMMING_85,
> > -	TYPE_TWO_POINT_TRIMMING,
> > -	TYPE_NONE,
> > -};
> 
> 
> There are more than two types of calibrations. tmu_control covers
> all types. This patch misses tmu_control.

Please take a look at patch #3 (the code in question has been removed by
it altogether).

> > -
> >  enum soc_type {
> >  	SOC_ARCH_EXYNOS4210 = 1,
> >  	SOC_ARCH_EXYNOS4412,
> > @@ -74,8 +66,6 @@ enum soc_type {
> >   * bitfields. The register validity, offsets and bitfield values may vary
> >   * slightly across different exynos SOC's.
> >   * @triminfo_data: register containing 2 pont trimming data
> > - * @triminfo_25_shift: shift bit of the 25 C trim value in triminfo_data reg.
> > - * @triminfo_85_shift: shift bit of the 85 C trim value in triminfo_data reg.
> >   * @triminfo_ctrl: trim info controller register.
> >   * @tmu_ctrl: TMU main controller register.
> >   * @test_mux_addr_shift: shift bits of test mux address.
> > @@ -116,8 +106,6 @@ enum soc_type {
> >   */
> >  struct exynos_tmu_registers {
> >  	u32	triminfo_data;
> > -	u32	triminfo_25_shift;
> > -	u32	triminfo_85_shift;
> >  
> >  	u32	triminfo_ctrl;
> >  
> > @@ -207,10 +195,7 @@ struct exynos_tmu_registers {
> >   * @min_efuse_value: minimum valid trimming data
> >   * @max_efuse_value: maximum valid trimming data
> >   * @first_point_trim: temp value of the first point trimming
> > - * @second_point_trim: temp value of the second point trimming
> > - * @default_temp_offset: default temperature offset in case of no trimming
> >   * @test_mux; information if SoC supports test MUX
> > - * @cal_type: calibration type for temperature
> >   * @freq_clip_table: Table representing frequency reduction percentage.
> >   * @freq_tab_count: Count of the above table as frequency reduction may
> >   *	applicable to only some of the trigger levels.
> > @@ -232,15 +217,12 @@ struct exynos_tmu_platform_data {
> >  	u8 reference_voltage;
> >  	u8 noise_cancel_mode;
> >  
> > -	u32 efuse_value;
> > +	u8 efuse_value;
> 
> Why?

In exynos_tmu_initialize() if data->temp_error2 was zero then its value was
obtained from bits 8-15 of efuse_value (bits 16-31 are always zero).  After
TYPE_TWO_POINT_TRIMMING code removal data->temp_error2 was no longer needed
and was also removed.  Thus only bits 0-7 of efuse_value are ever used and
its type can be changed from u32 to u8.

> >  	u32 min_efuse_value;
> >  	u32 max_efuse_value;
> >  	u8 first_point_trim;
> > -	u8 second_point_trim;
> > -	u8 default_temp_offset;
> >  	u8 test_mux;
> >  
> > -	enum calibration_type cal_type;
> >  	enum soc_type type;
> >  	struct freq_clip_table freq_tab[4];
> >  	unsigned int freq_tab_count;
> > diff --git a/drivers/thermal/samsung/exynos_tmu_data.c b/drivers/thermal/samsung/exynos_tmu_data.c
> > index 4b992d9..c32d186 100644
> > --- a/drivers/thermal/samsung/exynos_tmu_data.c
> > +++ b/drivers/thermal/samsung/exynos_tmu_data.c
> > @@ -27,8 +27,6 @@
> >  #if defined(CONFIG_CPU_EXYNOS4210)
> >  static const struct exynos_tmu_registers exynos4210_tmu_registers = {
> >  	.triminfo_data = EXYNOS_TMU_REG_TRIMINFO,
> > -	.triminfo_25_shift = EXYNOS_TRIMINFO_25_SHIFT,
> > -	.triminfo_85_shift = EXYNOS_TRIMINFO_85_SHIFT,
> >  	.tmu_ctrl = EXYNOS_TMU_REG_CONTROL,
> >  	.buf_vref_sel_shift = EXYNOS_TMU_REF_VOLTAGE_SHIFT,
> >  	.buf_vref_sel_mask = EXYNOS_TMU_REF_VOLTAGE_MASK,
> > @@ -66,12 +64,9 @@ struct exynos_tmu_init_data const exynos4210_default_tmu_data = {
> >  		.max_trigger_level = 4,
> >  		.gain = 15,
> >  		.reference_voltage = 7,
> > -		.cal_type = TYPE_ONE_POINT_TRIMMING,
> >  		.min_efuse_value = 40,
> >  		.max_efuse_value = 100,
> >  		.first_point_trim = 25,
> > -		.second_point_trim = 85,
> > -		.default_temp_offset = 50,
> >  		.freq_tab[0] = {
> >  			.freq_clip_max = 800 * 1000,
> >  			.temp_level = 85,
> > @@ -93,8 +88,6 @@ struct exynos_tmu_init_data const exynos4210_default_tmu_data = {
> >  #if defined(CONFIG_SOC_EXYNOS4412) || defined(CONFIG_SOC_EXYNOS5250)
> >  static const struct exynos_tmu_registers exynos4412_tmu_registers = {
> >  	.triminfo_data = EXYNOS_TMU_REG_TRIMINFO,
> > -	.triminfo_25_shift = EXYNOS_TRIMINFO_25_SHIFT,
> > -	.triminfo_85_shift = EXYNOS_TRIMINFO_85_SHIFT,
> >  	.triminfo_ctrl = EXYNOS_TMU_TRIMINFO_CON,
> >  	.tmu_ctrl = EXYNOS_TMU_REG_CONTROL,
> >  	.test_mux_addr_shift = EXYNOS4412_MUX_ADDR_SHIFT,
> > @@ -145,13 +138,10 @@ static const struct exynos_tmu_registers exynos4412_tmu_registers = {
> >  	.gain = 8, \
> >  	.reference_voltage = 16, \
> >  	.noise_cancel_mode = 4, \
> > -	.cal_type = TYPE_ONE_POINT_TRIMMING, \
> >  	.efuse_value = 55, \
> >  	.min_efuse_value = 40, \
> >  	.max_efuse_value = 100, \
> >  	.first_point_trim = 25, \
> > -	.second_point_trim = 85, \
> > -	.default_temp_offset = 50, \
> >  	.freq_tab[0] = { \
> >  		.freq_clip_max = 1400 * 1000, \
> >  		.temp_level = 70, \
> > @@ -195,8 +185,6 @@ struct exynos_tmu_init_data const exynos5250_default_tmu_data = {
> >  #if defined(CONFIG_SOC_EXYNOS5440)
> >  static const struct exynos_tmu_registers exynos5440_tmu_registers = {
> >  	.triminfo_data = EXYNOS5440_TMU_S0_7_TRIM,
> > -	.triminfo_25_shift = EXYNOS_TRIMINFO_25_SHIFT,
> > -	.triminfo_85_shift = EXYNOS_TRIMINFO_85_SHIFT,
> >  	.tmu_ctrl = EXYNOS5440_TMU_S0_7_CTRL,
> >  	.buf_vref_sel_shift = EXYNOS_TMU_REF_VOLTAGE_SHIFT,
> >  	.buf_vref_sel_mask = EXYNOS_TMU_REF_VOLTAGE_MASK,
> > @@ -240,13 +228,10 @@ static const struct exynos_tmu_registers exynos5440_tmu_registers = {
> >  	.gain = 5, \
> >  	.reference_voltage = 16, \
> >  	.noise_cancel_mode = 4, \
> > -	.cal_type = TYPE_ONE_POINT_TRIMMING, \
> > -	.efuse_value = 0x5b2d, \
> > +	.efuse_value = 45, \
> 
> What efuse value has to do with removing type two calibration type?

Bits 8-15 of efuse_value are only used for TYPE_TWO_POINT_TRIMMING code
(please take a look at changes inside exynos_tmu_initialize() for details).

> >  	.min_efuse_value = 16, \
> >  	.max_efuse_value = 76, \
> >  	.first_point_trim = 25, \
> > -	.second_point_trim = 70, \
> > -	.default_temp_offset = 25, \
> >  	.type = SOC_ARCH_EXYNOS5440, \
> >  	.registers = &exynos5440_tmu_registers, \
> >  	.features = (TMU_SUPPORT_EMULATION | TMU_SUPPORT_FALLING_TRIP | \
> > diff --git a/drivers/thermal/samsung/exynos_tmu_data.h b/drivers/thermal/samsung/exynos_tmu_data.h
> > index 1fed00d..734d1f9 100644
> > --- a/drivers/thermal/samsung/exynos_tmu_data.h
> > +++ b/drivers/thermal/samsung/exynos_tmu_data.h
> > @@ -51,8 +51,6 @@
> >  #define EXYNOS_THD_TEMP_FALL		0x54
> >  #define EXYNOS_EMUL_CON		0x80
> >  
> > -#define EXYNOS_TRIMINFO_25_SHIFT	0
> > -#define EXYNOS_TRIMINFO_85_SHIFT	8
> >  #define EXYNOS_TMU_RISE_INT_MASK	0x111
> >  #define EXYNOS_TMU_RISE_INT_SHIFT	0
> >  #define EXYNOS_TMU_FALL_INT_MASK	0x111

Best regards,
--
Bartlomiej Zolnierkiewicz
Samsung R&D Institute Poland
Samsung Electronics

