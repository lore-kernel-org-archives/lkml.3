Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756978Ab3EBJ1N (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 05:27:13 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:14132 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751956Ab3EBJ1K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 05:27:10 -0400
X-AuditID: cbfec7f4-b7faf6d00000189b-23-5182316b9e77
Message-id: <51823169.5050405@samsung.com>
Date: Thu, 02 May 2013 11:27:05 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-version: 1.0
To: Amit Daniel Kachhap <amit.daniel@samsung.com>,
        Lukasz Majewski <l.majewski@samsung.com>
Cc: linux-pm@vger.kernel.org, Zhang Rui <rui.zhang@intel.com>,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        amit.kachhap@gmail.com, Kukjin Kim <kgene.kim@samsung.com>,
        Eduardo Valentin <eduardo.valentin@ti.com>
Subject: Re: [PATCH] thermal: exynos: Support for TMU regulator defined at
 device tree
References: <1367473061-28863-1-git-send-email-amit.daniel@samsung.com>
In-reply-to: <1367473061-28863-1-git-send-email-amit.daniel@samsung.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrOLMWRmVeSWpSXmKPExsVy+t/xq7rZhk2BBn9WWVs0XA2x+PVuJrvF
	mv0/mSx6F1xls3jzcDOjxeVdc9gsPvceYbSYcX4fk8WTh31sDpweO2fdZfdYvOclk0ffllWM
	HsdvbGfy+LxJLoA1issmJTUnsyy1SN8ugStjQXsLS8Ff5YrmhSuZGhi7ZbsYOTkkBEwkLk39
	zwJhi0lcuLeerYuRi0NIYCmjxLP9zewQzidGiVn3XrOBVPEKaEn8OvKEtYuRg4NFQFVi3W1j
	kDCbgKFE79E+RhBbVCBAYvGSc+wQ5YISPybfA1sgIhAr0b7mNhPITGaBN4wSO4/MApspLBAh
	cffvMTBbSMBd4trbjcwgNqeAh8Tppp1gg5gFdCT2t05jg7DlJTavecs8gVFgFpIds5CUzUJS
	toCReRWjaGppckFxUnquoV5xYm5xaV66XnJ+7iZGSOB/2cG4+JjVIUYBDkYlHt6Puo2BQqyJ
	ZcWVuYcYJTiYlUR4k+SbAoV4UxIrq1KL8uOLSnNSiw8xMnFwSjUwCpzd3BvuuP7aQ/vr39Wc
	3l6dfq56+vV/2XNyw5mkfryc7/7ewiVDc77z17ZcXzGFtaZtd3P2KCvM8U7L3//hRe8c3r7o
	xLWFpqs7StYE7s/RS/voKvE8yDS069rzT8087skm9yxWTgh6szlD6sDbvoklU7eF37943knA
	8dPceCbJj6rR1evPKrEUZyQaajEXFScCAGtSvZJaAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 05/02/2013 07:37 AM, Amit Daniel Kachhap wrote:
> TMU probe function now checks for a device tree defined regulator.
> For compatibility reasons it is allowed to probe driver even without
> this regulator defined.
> 
> Signed-off-by: Lukasz Majewski <l.majewski@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> Signed-off-by: Amit Daniel Kachhap <amit.daniel@samsung.com>
> ---
> 
> This patch is repost of the patch posted by Lukasz Majewski
> (https://patchwork.kernel.org/patch/2488211/). I have rebased this
> patch on top of my TMU re-structured patch series
> (http://lwn.net/Articles/548634/). Although I thought of handling
> regulator as one type of feature (newly added) but could not do
> so as regulator is a board/platform property and not SOC property so
> leaving the device tree to define and handle it.
> 
>  .../devicetree/bindings/thermal/exynos-thermal.txt |    4 ++++
>  drivers/thermal/samsung/exynos_tmu.c               |   17 +++++++++++++++++
>  2 files changed, 21 insertions(+), 0 deletions(-)
> 
> diff --git a/Documentation/devicetree/bindings/thermal/exynos-thermal.txt b/Documentation/devicetree/bindings/thermal/exynos-thermal.txt
> index 970eeba..ff62f7a 100644
> --- a/Documentation/devicetree/bindings/thermal/exynos-thermal.txt
> +++ b/Documentation/devicetree/bindings/thermal/exynos-thermal.txt
> @@ -14,6 +14,9 @@
>  - interrupts : Should contain interrupt for thermal system
>  - clocks : The main clock for TMU device
>  - clock-names : Thermal system clock name
> +- vtmu-supply: This entry is optional and provides the regulator node supplying
> +		voltage to TMU. If needed this entry can be placed inside
> +		board/platform specific dts file.
>  
>  Example 1):
>  
> @@ -25,6 +28,7 @@ Example 1):
>  		clocks = <&clock 383>;
>  		clock-names = "tmu_apbif";
>  		status = "disabled";
> +		vtmu-supply = <&tmu_regulator_node>;
>  	};
>  
>  Example 2):
> diff --git a/drivers/thermal/samsung/exynos_tmu.c b/drivers/thermal/samsung/exynos_tmu.c
> index 72446c9..45b50c1 100644
> --- a/drivers/thermal/samsung/exynos_tmu.c
> +++ b/drivers/thermal/samsung/exynos_tmu.c
> @@ -32,6 +32,7 @@
>  #include <linux/of_address.h>
>  #include <linux/of_irq.h>
>  #include <linux/platform_device.h>
> +#include <linux/regulator/consumer.h>
>  #include <linux/slab.h>
>  #include <linux/workqueue.h>
>  #include "exynos_thermal_common.h"
> @@ -52,6 +53,7 @@
>   * @clk: pointer to the clock structure.
>   * @temp_error1: fused value of the first point trim.
>   * @temp_error2: fused value of the second point trim.
> + * @regulator: pointer to the TMU regulator structure.
>   * @reg_conf: pointer to structure to register with core thermal.
>   */
>  struct exynos_tmu_data {
> @@ -65,6 +67,7 @@ struct exynos_tmu_data {
>  	struct mutex lock;
>  	struct clk *clk;
>  	u8 temp_error1, temp_error2;
> +	struct regulator *regulator;
>  	struct thermal_sensor_conf *reg_conf;
>  };
>  
> @@ -501,10 +504,21 @@ static int exynos_map_dt_data(struct platform_device *pdev)
>  	struct exynos_tmu_data *data = platform_get_drvdata(pdev);
>  	struct exynos_tmu_platform_data *pdata = data->pdata;
>  	struct resource res;
> +	int ret;
>  
>  	if (!data)
>  		return -ENODEV;
>  
> +	/* Try enabling the regulator if found */
> +	data->regulator = devm_regulator_get(&pdev->dev, "vtmu");

Wouldn't it better to require vtmu-supply property always ?
This way any errors would have not been ignored. And board/platform
would have to specify real or dummy regulator supply.

However, if the DT binding is already defined it might be too late to 
add a required property. Nevertless some log might be useful in case
regulator_get fails and the driver runs without the regulator's control.

> +	if (!IS_ERR(data->regulator)) {
> +		ret = regulator_enable(data->regulator);
> +		if (ret) {
> +			dev_err(&pdev->dev, "failed to enable vtmu\n");
> +			return ret;
> +		}
> +	}
> +
>  	data->id = of_alias_get_id(pdev->dev.of_node, "tmuctrl");
>  	if (data->id < 0)
>  		data->id = 0;
> @@ -669,6 +683,9 @@ static int exynos_tmu_remove(struct platform_device *pdev)
>  
>  	clk_unprepare(data->clk);
>  
> +	if (data->regulator)

Shouldn't this be:

	if (!IS_ERR(data->regulator))

You probably want to set data->regulator to some ERR_PTR() value
in probe, unless regulator get is first thing done there.

> +		regulator_disable(data->regulator);
> +
>  	platform_set_drvdata(pdev, NULL);
>  
>  	return 0;
> 

Regards,
Sylwester
