Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755366Ab3LRPui (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 10:50:38 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:18775 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755098Ab3LRPuf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 10:50:35 -0500
X-AuditID: cbfec7f5-b7f6f6d000005b3b-f2-52b1c4489e59
From: Tomasz Figa <t.figa@samsung.com>
To: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
Cc: linux-pm@vger.kernel.org, naveenkrishna.ch@gmail.com, rui.zhang@intel.com,
        eduardo.valentin@ti.com, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org, amit.daniel@samsung.com,
        kgene.kim@samsung.com, devicetree@vger.kernel.org,
        b.zolnierkie@samsung.com, cpgs@samsung.com
Subject: Re: [PATCH v11 3/4] thermal: samsung: Add TMU support for Exynos5420
 SoCs
Date: Wed, 18 Dec 2013 16:50:17 +0100
Message-id: <1498725.3K8LHaD3Qd@amdc1227>
Organization: Samsung Poland R&D Center
User-Agent: KMail/4.11.3 (Linux/3.11.5-gentoo; KDE/4.11.3; x86_64; ; )
In-reply-to: <1386657745-21602-1-git-send-email-ch.naveen@samsung.com>
References: <1378268629-2886-3-git-send-email-ch.naveen@samsung.com>
 <1386657745-21602-1-git-send-email-ch.naveen@samsung.com>
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=us-ascii
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrMLMWRmVeSWpSXmKPExsVy+t/xK7oeRzYGGVw9Z2HRcDXEYuOM9awW
	d58fZrR4eUjTYv6Rc6wWa/b/ZLLoXXCVzeLyrjlsFp97jzBazDi/j8li0bb/zBZPHvaxOfB4
	7Jx1l91j8Z6XTB59W1Yxehy/sZ3J4/MmuQDWKC6blNSczLLUIn27BK6M7hezmQrW6VbMbPzE
	1MC4V6WLkZNDQsBE4vr0O4wQtpjEhXvr2boYuTiEBJYySnxc+4sdwulikjh2tJ8FpIpNQE3i
	c8MjNhBbBKj7+KszYEXMAkuZJOYvW8QMkhAWCJFY/fAoE4jNIqAqcXDyHzCbV0BTYvXCRlYQ
	m19AXeLdtqdgcVEBN4kX+7awg9icQPbsA7egNjcwSvQ1HGaDaBaU+DH5HtgVzALyEvv2T2WF
	sLUk1u88zjSBUXAWkrJZSMpmISlbwMi8ilE0tTS5oDgpPddIrzgxt7g0L10vOT93EyMkYr7u
	YFx6zOoQowAHoxIP7wKfjUFCrIllxZW5hxglOJiVRHiFtgKFeFMSK6tSi/Lji0pzUosPMTJx
	cEo1MAYeCI+LWZZdk3v7tOX5Xf+fvNbtS0tOP6meHye8nv97O1vy+4t92Wm8H04x3XuZzbbv
	3IoHs+xsRaYdKLT4wNos8KP97+VrfbfunWPlkDbfpbi30jZ0v4zVqujPLxXvMG56udbndOCK
	pT2mLBVct5b/m9miu/DO7c3Lo6VecJ4XiU2O3ezHmqXEUpyRaKjFXFScCADXS5gZdgIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Naveen,

On Tuesday 10 of December 2013 12:12:25 Naveen Krishna Chatradhi wrote:
> Exynos5420 has 5 TMU channels, the TRIMINFO register is
> misplaced for TMU channels 2, 3 and 4
> TRIMINFO at 0x1006c000 contains data for TMU channel 3
> TRIMINFO at 0x100a0000 contains data for TMU channel 4
> TRIMINFO at 0x10068000 contains data for TMU channel 2
[snip]
> diff --git a/Documentation/devicetree/bindings/thermal/exynos-thermal.txt b/Documentation/devicetree/bindings/thermal/exynos-thermal.txt
> index a1aa602..a3e78c0 100644
> --- a/Documentation/devicetree/bindings/thermal/exynos-thermal.txt
> +++ b/Documentation/devicetree/bindings/thermal/exynos-thermal.txt
> @@ -6,6 +6,9 @@
>  	       "samsung,exynos4412-tmu"
>  	       "samsung,exynos4210-tmu"
>  	       "samsung,exynos5250-tmu"
> +	       "samsung,exynos5420-tmu" for TMU channel 0, 1 on Exynos5420
> +	       "samsung,exynos5420-tmu-ext-triminfo" for TMU channels 2, 3 and 4
> +			Exynos5420 (Must pass triminfo base and triminfo clock)

Exact clock names must be specified in description of clock-names property.

>  	       "samsung,exynos5440-tmu"
>  - interrupt-parent : The phandle for the interrupt controller
>  - reg : Address range of the thermal registers. For soc's which has multiple
> @@ -13,6 +16,16 @@
>  	interrupt related then 2 set of register has to supplied. First set
>  	belongs	to register set of TMU instance and second set belongs to
>  	registers shared with the TMU instance.
> +
> +  NOTE: On Exynos5420, the TRIMINFO register is misplaced for TMU
> +	channels 2, 3 and 4
> +	Use "samsung,exynos5420-tmu-ext-triminfo" in cases, there is a misplaced
> +	register, also provide clock to access that base.
> +
> +	TRIMINFO at 0x1006c000 contains data for TMU channel 3
> +	TRIMINFO at 0x100a0000 contains data for TMU channel 4
> +	TRIMINFO at 0x10068000 contains data for TMU channel 2
> +
>  - interrupts : Should contain interrupt for thermal system
>  - clocks : The main clock for TMU device
>  - clock-names : Thermal system clock name
> @@ -43,6 +56,31 @@ Example 2):
>  		clock-names = "tmu_apbif";
>  	};
>  
> +Example 3): (In case of Exynos5420 "with misplaced TRIMINFO register")
> +	tmu_cpu2: tmu@10068000 {
> +		compatible = "samsung,exynos5420-tmu-ext-triminfo";
> +		reg = <0x10068000 0x100>, <0x1006c000 0x4>;
> +		interrupts = <0 184 0>;
> +		clocks = <&clock 318>, <&clock 318>;
> +		clock-names = "tmu_apbif", "tmu_triminfo_apbif";

Here you have "tmu_triminfo_apbif" clock, but in the driver you call
clk_get() with "tmu_apbif_triminfo".

> +	};
> +
[snip]
>  
> +	data->clk_sec = devm_clk_get(&pdev->dev, "tmu_apbif_triminfo");

Here you try to get "tmu_apbif_triminfo" clock, but in binding
documentation you have "tmu_triminfo_apbif" in example.

> +	if (IS_ERR(data->clk_sec)) {
> +		if (data->soc == SOC_ARCH_EXYNOS5420_TRIMINFO) {
> +			dev_err(&pdev->dev, "Failed to get triminfo clock\n");
> +			return PTR_ERR(data->clk_sec);
> +		}
> +	} else {
> +		ret = clk_prepare(data->clk_sec);
> +		if (ret) {
> +			dev_err(&pdev->dev, "Failed to get clock\n");
> +			return ret;
> +		}
> +	}
> +
>  	ret = clk_prepare(data->clk);
> -	if (ret)
> -		return ret;
> +	if (ret) {
> +		dev_err(&pdev->dev, "Failed to get clock\n");
> +		goto err_clk_sec;
> +	}
>  
>  	if (pdata->type == SOC_ARCH_EXYNOS4210 ||
>  	    pdata->type == SOC_ARCH_EXYNOS4412 ||
>  	    pdata->type == SOC_ARCH_EXYNOS5250 ||
> +	    pdata->type == SOC_ARCH_EXYNOS5420_TRIMINFO ||

Don't you also need SOC_ARCH_EXYNOS5420 here?

>  	    pdata->type == SOC_ARCH_EXYNOS5440)
>  		data->soc = pdata->type;
>  	else {
> @@ -703,6 +742,9 @@ static int exynos_tmu_probe(struct platform_device *pdev)
>  	return 0;
>  err_clk:
>  	clk_unprepare(data->clk);
> +err_clk_sec:
> +	if (!IS_ERR(data->clk_sec))
> +		clk_unprepare(data->clk_sec);
>  	return ret;
>  }
>  
> @@ -715,6 +757,8 @@ static int exynos_tmu_remove(struct platform_device *pdev)
>  	exynos_unregister_thermal(data->reg_conf);
>  
>  	clk_unprepare(data->clk);
> +	if (!IS_ERR(data->clk_sec))
> +		clk_unprepare(data->clk_sec);
>  
>  	if (!IS_ERR(data->regulator))
>  		regulator_disable(data->regulator);
> diff --git a/drivers/thermal/samsung/exynos_tmu.h b/drivers/thermal/samsung/exynos_tmu.h
> index 0d6b32f..60cce28 100644
> --- a/drivers/thermal/samsung/exynos_tmu.h
> +++ b/drivers/thermal/samsung/exynos_tmu.h
> @@ -43,6 +43,7 @@ enum soc_type {
>  	SOC_ARCH_EXYNOS4210 = 1,
>  	SOC_ARCH_EXYNOS4412,
>  	SOC_ARCH_EXYNOS5250,
> +	SOC_ARCH_EXYNOS5420_TRIMINFO,

Here as well.

>  	SOC_ARCH_EXYNOS5440,
>  };
>  
[snip]
> +#define EXYNOS5420_TMU_DATA \
> +	__EXYNOS5420_TMU_DATA \
> +	.type = SOC_ARCH_EXYNOS5250, \
> +	.features = (TMU_SUPPORT_EMULATION | TMU_SUPPORT_TRIM_RELOAD | \
> +			TMU_SUPPORT_FALLING_TRIP | TMU_SUPPORT_READY_STATUS | \
> +			TMU_SUPPORT_EMUL_TIME)
> +
> +#define EXYNOS5420_TMU_DATA_SHARED \
> +	__EXYNOS5420_TMU_DATA \
> +	.type = SOC_ARCH_EXYNOS5420_TRIMINFO, \
> +	.features = (TMU_SUPPORT_EMULATION | TMU_SUPPORT_TRIM_RELOAD | \
> +			TMU_SUPPORT_FALLING_TRIP | TMU_SUPPORT_READY_STATUS | \
> +			TMU_SUPPORT_EMUL_TIME | TMU_SUPPORT_ADDRESS_MULTIPLE)
> +
> +struct exynos_tmu_init_data const exynos5420_default_tmu_data = {
> +	.tmu_data = {
> +		{ EXYNOS5420_TMU_DATA },
> +		{ EXYNOS5420_TMU_DATA },
> +		{ EXYNOS5420_TMU_DATA_SHARED },
> +		{ EXYNOS5420_TMU_DATA_SHARED },
> +		{ EXYNOS5420_TMU_DATA_SHARED },

Shouldn't this be inferred from compatible string?

If I understand this code correctly, you can now always use
EXYNOS5420_TMU_DATA for 5420-tmu compatible string and
EXYNOS5420_TMU_DATA_SHARED for 5420-tmu-ext-triminfo.

Best regards,
Tomasz

