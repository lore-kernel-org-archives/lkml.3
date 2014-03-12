Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753921AbaCLLDf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 07:03:35 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:53250 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753589AbaCLLDd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 07:03:33 -0400
X-AuditID: cbfec7f5-b7fc96d000004885-96-53203f01864b
Message-id: <53203EFC.1020109@samsung.com>
Date: Wed, 12 Mar 2014 12:03:24 +0100
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.2.0
MIME-version: 1.0
To: Chanwoo Choi <cw00.choi@samsung.com>, t.figa@samsung.com,
        a.hajda@samsung.com, mturquette@linaro.org, kgene.kim@samsung.com
Cc: linux-samsung-soc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        kyungmin.park@samsung.com, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org
Subject: Re: [PATCH] clk: exynos4: Add clock ID for ppmuleft/right
References: <1394608090-25362-1-git-send-email-cw00.choi@samsung.com>
In-reply-to: <1394608090-25362-1-git-send-email-cw00.choi@samsung.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrNLMWRmVeSWpSXmKPExsVy+t/xK7qM9grBBhd3WFrcWneO1eL6l+es
	FvOPAFn9bxayWpx7tZLRonfBVTaLs01v2C02Pb7GanF51xw2ixnn9zFZLL1+kcni6YSLbBYT
	pq9lsVg/4zWLA5/HmnlrGD0u9/Uyeaxc/oXN4861PWwem5fUe/RtWcXo8XmTXAB7FJdNSmpO
	Zllqkb5dAlfGr0XzWAoO81cc/HeGtYHxA08XIweHhICJxL/zNl2MnECmmMSFe+vZuhi5OIQE
	ljJKNLU9gnI+MUosObaLFaSKV0BLYvOrB+wgNouAqsTlvs9gNpuAoUTv0T5GEFtUIELi1dmJ
	LBD1ghI/Jt9jARkkItDIKHGzfSrYVGaBViaJ55eOM4FUCQs4SRxvvgPWISTgKvFv4l1mEJtT
	wE1i9ts7YDazgI7E/tZpbBC2vMTmNW+ZJzAKzEKyZBaSsllIyhYwMq9iFE0tTS4oTkrPNdIr
	TswtLs1L10vOz93ECImgrzsYlx6zOsQowMGoxMM7U0k+WIg1say4MvcQowQHs5II7y5bhWAh
	3pTEyqrUovz4otKc1OJDjEwcnFINjLUfLr/+uXzBurSE3W2Xn6x4aMMuwq+T0e7BdPqbSuj8
	q4buv9yFBNQala1T1FdOOC82XWnC+0cMEw/IHrg6WTH9ydIvjLNVLCbsfLBYoC6zI/k2O69w
	1s4v4k7TNt35XTKv/36+iVawdUxawlLB+aVKrU/Lo9/9fWL26aos/6f0x+Y25i5prkosxRmJ
	hlrMRcWJADF4H8t+AgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Chanwoo,

On 12/03/14 08:08, Chanwoo Choi wrote:
> There is no gate for the PPMU Left/Right to the LEFT/RIGHTBUS block.
> So, this patch add ppmuleft/right clock which is used to calculate memory bus
> utilization by using PPMU(Performance Profiling Monitoring Unit).
> 
> Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> ---
>  drivers/clk/samsung/clk-exynos4.c   |  2 ++
>  include/dt-bindings/clock/exynos4.h | 26 ++++++++++++++------------
>  2 files changed, 16 insertions(+), 12 deletions(-)
> 
> diff --git a/drivers/clk/samsung/clk-exynos4.c b/drivers/clk/samsung/clk-exynos4.c
> index 010f071..3819485 100644
> --- a/drivers/clk/samsung/clk-exynos4.c
> +++ b/drivers/clk/samsung/clk-exynos4.c
> @@ -717,6 +717,8 @@ static struct samsung_gate_clock exynos4_gate_clks[] __initdata = {
>  			0, 0),
>  	GATE(CLK_AC97, "ac97", "aclk100", GATE_IP_PERIL, 27,
>  			0, 0),
> +	GATE(CLK_PPMULEFT, "ppmuleft", "aclk200", GATE_IP_LEFTBUS, 1, 0, 0),
> +	GATE(CLK_PPMURIGHT, "ppmuright", "aclk200", GATE_IP_RIGHTBUS, 1, 0, 0),
>  };
>  
>  /* list of gate clocks supported in exynos4210 soc */
> diff --git a/include/dt-bindings/clock/exynos4.h b/include/dt-bindings/clock/exynos4.h
> index 75aff33..cd7fecf 100644
> --- a/include/dt-bindings/clock/exynos4.h
> +++ b/include/dt-bindings/clock/exynos4.h
> @@ -215,20 +215,22 @@
>  #define CLK_SPI1_ISP_SCLK	381 /* Exynos4x12 only */
>  #define CLK_UART_ISP_SCLK	382 /* Exynos4x12 only */
>  #define CLK_TMU_APBIF		383
> +#define CLK_PPMULEFT		384
> +#define CLK_PPMURIGHT		385
>  
>  /* mux clocks */
> -#define CLK_MOUT_FIMC0		384

You must not change the existing clock indices like this, use indexes
that are currently unused for CLK_PPMU* clocks.
If you do that the kernel would stop working with existing dtbs.
This interface is an ABI, so you can't just rearrange the indices
at will like this.

--
Regards,
Sylwester
