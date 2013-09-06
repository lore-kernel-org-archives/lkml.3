Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750769Ab3IFEiy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Sep 2013 00:38:54 -0400
Received: from mail-ie0-f172.google.com ([209.85.223.172]:62115 "EHLO
	mail-ie0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750705Ab3IFEiu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Sep 2013 00:38:50 -0400
MIME-Version: 1.0
In-Reply-To: <1378268629-2886-2-git-send-email-ch.naveen@samsung.com>
References: <1377668719-8602-2-git-send-email-ch.naveen@samsung.com>
	<1378268629-2886-1-git-send-email-ch.naveen@samsung.com>
	<1378268629-2886-2-git-send-email-ch.naveen@samsung.com>
Date: Fri, 6 Sep 2013 10:08:49 +0530
X-Google-Sender-Auth: bEpLL8EYKDN-6d9wwLzesDIcroU
Message-ID: <CADGdYn5MVpSrdVhioEesy=5=r6a7cz4yvkiLfavxhcDAjY02OQ@mail.gmail.com>
Subject: Re: [PATCH 2/3] thermal: samsung: change base_common to more
 meaningful base_second
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
        devicetree@vger.kernel.org,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 4, 2013 at 9:53 AM, Naveen Krishna Chatradhi
<ch.naveen@samsung.com> wrote:
> On Exynos5440 and Exynos5420 there are registers common
> across the TMU channels.
>
> To support that, we introduced a ADDRESS_MULTIPLE flag in the
> driver and the 2nd set of register base and size are provided
> in the "reg" property of the node.
>
> As per Amit's suggestion, this patch changes the base_common
> to base_second and SHARED_MEMORY to ADDRESS_MULTIPLE.
>
> Signed-off-by: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
The changes look good. For all the 3 patches in the series,

Acked-by: Amit Daniel Kachhap <amit.daniel@samsung.com>
Reviewed-by: Amit Daniel Kachhap<amit.daniel@samsung.com>

Thanks,
Amit Daniel
> ---
> Changes since v2:
> Changed the flag name from SHARED_MEMORY to ADDRESS_MULTIPLE.
> https://lkml.org/lkml/2013/8/1/38
>
>  .../devicetree/bindings/thermal/exynos-thermal.txt |    4 ++--
>  drivers/thermal/samsung/exynos_tmu.c               |   12 ++++++------
>  drivers/thermal/samsung/exynos_tmu.h               |    4 ++--
>  drivers/thermal/samsung/exynos_tmu_data.c          |    2 +-
>  4 files changed, 11 insertions(+), 11 deletions(-)
>
> diff --git a/Documentation/devicetree/bindings/thermal/exynos-thermal.txt b/Documentation/devicetree/bindings/thermal/exynos-thermal.txt
> index 284f530..116cca0 100644
> --- a/Documentation/devicetree/bindings/thermal/exynos-thermal.txt
> +++ b/Documentation/devicetree/bindings/thermal/exynos-thermal.txt
> @@ -11,8 +11,8 @@
>  - reg : Address range of the thermal registers. For soc's which has multiple
>         instances of TMU and some registers are shared across all TMU's like
>         interrupt related then 2 set of register has to supplied. First set
> -       belongs to each instance of TMU and second set belongs to common TMU
> -       registers.
> +       belongs to each instance of TMU and second set belongs to second set
> +       of common TMU registers.
>  - interrupts : Should contain interrupt for thermal system
>  - clocks : The main clock for TMU device
>  - clock-names : Thermal system clock name
> diff --git a/drivers/thermal/samsung/exynos_tmu.c b/drivers/thermal/samsung/exynos_tmu.c
> index d201ed8..3a55caf 100644
> --- a/drivers/thermal/samsung/exynos_tmu.c
> +++ b/drivers/thermal/samsung/exynos_tmu.c
> @@ -41,7 +41,7 @@
>   * @id: identifier of the one instance of the TMU controller.
>   * @pdata: pointer to the tmu platform/configuration data
>   * @base: base address of the single instance of the TMU controller.
> - * @base_common: base address of the common registers of the TMU controller.
> + * @base_second: base address of the common registers of the TMU controller.
>   * @irq: irq number of the TMU controller.
>   * @soc: id of the SOC type.
>   * @irq_work: pointer to the irq work structure.
> @@ -56,7 +56,7 @@ struct exynos_tmu_data {
>         int id;
>         struct exynos_tmu_platform_data *pdata;
>         void __iomem *base;
> -       void __iomem *base_common;
> +       void __iomem *base_second;
>         int irq;
>         enum soc_type soc;
>         struct work_struct irq_work;
> @@ -297,7 +297,7 @@ skip_calib_data:
>         }
>         /*Clear the PMIN in the common TMU register*/
>         if (reg->tmu_pmin && !data->id)
> -               writel(0, data->base_common + reg->tmu_pmin);
> +               writel(0, data->base_second + reg->tmu_pmin);
>  out:
>         clk_disable(data->clk);
>         mutex_unlock(&data->lock);
> @@ -451,7 +451,7 @@ static void exynos_tmu_work(struct work_struct *work)
>
>         /* Find which sensor generated this interrupt */
>         if (reg->tmu_irqstatus) {
> -               val_type = readl(data->base_common + reg->tmu_irqstatus);
> +               val_type = readl(data->base_second + reg->tmu_irqstatus);
>                 if (!((val_type >> data->id) & 0x1))
>                         goto out;
>         }
> @@ -582,7 +582,7 @@ static int exynos_map_dt_data(struct platform_device *pdev)
>          * Check if the TMU shares some registers and then try to map the
>          * memory of common registers.
>          */
> -       if (!TMU_SUPPORTS(pdata, SHARED_MEMORY))
> +       if (!TMU_SUPPORTS(pdata, ADDRESS_MULTIPLE))
>                 return 0;
>
>         if (of_address_to_resource(pdev->dev.of_node, 1, &res)) {
> @@ -590,7 +590,7 @@ static int exynos_map_dt_data(struct platform_device *pdev)
>                 return -ENODEV;
>         }
>
> -       data->base_common = devm_ioremap(&pdev->dev, res.start,
> +       data->base_second = devm_ioremap(&pdev->dev, res.start,
>                                         resource_size(&res));
>         if (!data->base) {
>                 dev_err(&pdev->dev, "Failed to ioremap memory\n");
> diff --git a/drivers/thermal/samsung/exynos_tmu.h b/drivers/thermal/samsung/exynos_tmu.h
> index 7c6c34a..ebd2ec1 100644
> --- a/drivers/thermal/samsung/exynos_tmu.h
> +++ b/drivers/thermal/samsung/exynos_tmu.h
> @@ -59,7 +59,7 @@ enum soc_type {
>   *                     state(active/idle) can be checked.
>   * TMU_SUPPORT_EMUL_TIME - This features allows to set next temp emulation
>   *                     sample time.
> - * TMU_SUPPORT_SHARED_MEMORY - This feature tells that the different TMU
> + * TMU_SUPPORT_ADDRESS_MULTIPLE - This feature tells that the different TMU
>   *                     sensors shares some common registers.
>   * TMU_SUPPORT - macro to compare the above features with the supplied.
>   */
> @@ -69,7 +69,7 @@ enum soc_type {
>  #define TMU_SUPPORT_FALLING_TRIP               BIT(3)
>  #define TMU_SUPPORT_READY_STATUS               BIT(4)
>  #define TMU_SUPPORT_EMUL_TIME                  BIT(5)
> -#define TMU_SUPPORT_SHARED_MEMORY              BIT(6)
> +#define TMU_SUPPORT_ADDRESS_MULTIPLE           BIT(6)
>
>  #define TMU_SUPPORTS(a, b)     (a->features & TMU_SUPPORT_ ## b)
>
> diff --git a/drivers/thermal/samsung/exynos_tmu_data.c b/drivers/thermal/samsung/exynos_tmu_data.c
> index 23fea23..58570d0 100644
> --- a/drivers/thermal/samsung/exynos_tmu_data.c
> +++ b/drivers/thermal/samsung/exynos_tmu_data.c
> @@ -239,7 +239,7 @@ static const struct exynos_tmu_registers exynos5440_tmu_registers = {
>         .type = SOC_ARCH_EXYNOS5440, \
>         .registers = &exynos5440_tmu_registers, \
>         .features = (TMU_SUPPORT_EMULATION | TMU_SUPPORT_FALLING_TRIP | \
> -                       TMU_SUPPORT_MULTI_INST | TMU_SUPPORT_SHARED_MEMORY),
> +                       TMU_SUPPORT_MULTI_INST | TMU_SUPPORT_ADDRESS_MULTIPLE),
>
>  struct exynos_tmu_init_data const exynos5440_default_tmu_data = {
>         .tmu_data = {
> --
> 1.7.9.5
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-pm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
