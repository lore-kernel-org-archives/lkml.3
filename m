Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932292Ab3E0MWj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 May 2013 08:22:39 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:39158 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932110Ab3E0MWh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 May 2013 08:22:37 -0400
X-AuditID: cbfec7f4-b7fd76d0000035e1-69-51a3500a8f83
Message-id: <51A35009.3040301@samsung.com>
Date: Mon, 27 May 2013 14:22:33 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-version: 1.0
To: mturquette@linaro.org
Cc: kyungmin.park@samsung.com, kgene.kim@samsung.com, inki.dae@samsung.com,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] clk: samsung: Add CLK_IGNORE_UNUSED flag for the sysreg
 clocks
References: <1368203889-12547-1-git-send-email-s.nawrocki@samsung.com>
In-reply-to: <1368203889-12547-1-git-send-email-s.nawrocki@samsung.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrNLMWRmVeSWpSXmKPExsVy+t/xy7pcAYsDDfZd0bKYdH8Ci0Xvgqts
	Fmeb3rBbXN41h81ixvl9TBZPJ1xkc2DzuHNtD5tH35ZVjB6fN8kFMEdx2aSk5mSWpRbp2yVw
	Zby79Zq9YKlIxb6fu1kaGF8KdDFyckgImEg8PzOVCcIWk7hwbz1bFyMXh5DAUkaJ60d2sYEk
	hAQ+MUosvQpkc3DwCmhJ3P0ZDxJmEVCVmHl+BQuIzSZgKNF7tI8RxBYVCJBYvOQcO4jNKyAo
	8WPyPbAaEQFJiQefp4PZzAK9jBJ3N6qAjBQWCJVo3W0KYgoJuEks2WsOUsEp4C5x6eweZohq
	HYn9rdPYIGx5ic1r3jJPYBSYhWTBLCRls5CULWBkXsUomlqaXFCclJ5rqFecmFtcmpeul5yf
	u4kREsBfdjAuPmZ1iFGAg1GJh/fnrEWBQqyJZcWVuYcYJTiYlUR4pcwWBwrxpiRWVqUW5ccX
	leakFh9iZOLglGpgbLtvubiv7/edqDaR0kfi0wPf7pCeqtekPIEtoWn1KsW3Hczc7xfJSi09
	/dWgK4XtcdoceVnrzGdtmo8Yd5wO3SOkOnmX5K7tC6YUfA53YvPPmiw3+cW9S/wn6z8evJp1
	9ZDLJv9/30uYF/K8zmVoPiKXZreocfPrjbfOdku9nf7ze1GU0jcvTyWW4oxEQy3mouJEAPPD
	h0E+AgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/10/2013 06:38 PM, Sylwester Nawrocki wrote:
> Currently no driver *) handles the sysreg clock, with an assumption
> that this clock is always left in its default state (enabled).
> 
> Before commit 6e6aac7590f902d14d90bace3fd499
> ARM: EXYNOS: Migrate clock support to common clock framework
> 
> the sysreg clock was not even defined and hence wasn't handled
> explicitly in the kernel.
> 
> To restore the previous behaviour disable masking the sysreg clock
> off in the clock core by default.
> 
> *) Except the Exynos4x12 FIMC-IS driver, which will be modified
>    to not touch the sysreg clock.
> 
> Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>

Mike,

would you consider applying it as a bug fix for v3.10-rc ?

I'd like to queue patch [1] for 3.10 through the media tree,
once $subject patch is in Linus' tree.

Thanks,
Sylwester

[1] https://patchwork.linuxtv.org/patch/18374

> ---
>  drivers/clk/samsung/clk-exynos4.c |    6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/clk/samsung/clk-exynos4.c b/drivers/clk/samsung/clk-exynos4.c
> index 070bbeb..0f2f5e5 100644
> --- a/drivers/clk/samsung/clk-exynos4.c
> +++ b/drivers/clk/samsung/clk-exynos4.c
> @@ -797,7 +797,8 @@ struct samsung_gate_clock exynos4210_gate_clks[] __initdata = {
>  	GATE(smmu_pcie, "smmu_pcie", "aclk133", GATE_IP_FSYS, 18, 0, 0),
>  	GATE(modemif, "modemif", "aclk100", GATE_IP_PERIL, 28, 0, 0),
>  	GATE(chipid, "chipid", "aclk100", E4210_GATE_IP_PERIR, 0, 0, 0),
> -	GATE(sysreg, "sysreg", "aclk100", E4210_GATE_IP_PERIR, 0, 0, 0),
> +	GATE(sysreg, "sysreg", "aclk100", E4210_GATE_IP_PERIR, 0,
> +			CLK_IGNORE_UNUSED, 0),
>  	GATE(hdmi_cec, "hdmi_cec", "aclk100", E4210_GATE_IP_PERIR, 11, 0, 0),
>  	GATE(smmu_rotator, "smmu_rotator", "aclk200",
>  			E4210_GATE_IP_IMAGE, 4, 0, 0),
> @@ -826,7 +827,8 @@ struct samsung_gate_clock exynos4x12_gate_clks[] __initdata = {
>  	GATE(smmu_mdma, "smmu_mdma", "aclk200", E4X12_GATE_IP_IMAGE, 5, 0, 0),
>  	GATE(mipi_hsi, "mipi_hsi", "aclk133", GATE_IP_FSYS, 10, 0, 0),
>  	GATE(chipid, "chipid", "aclk100", E4X12_GATE_IP_PERIR, 0, 0, 0),
> -	GATE(sysreg, "sysreg", "aclk100", E4X12_GATE_IP_PERIR, 1, 0, 0),
> +	GATE(sysreg, "sysreg", "aclk100", E4X12_GATE_IP_PERIR, 1,
> +			CLK_IGNORE_UNUSED, 0),
>  	GATE(hdmi_cec, "hdmi_cec", "aclk100", E4X12_GATE_IP_PERIR, 11, 0, 0),
>  	GATE(sclk_mdnie0, "sclk_mdnie0", "div_mdnie0",
>  			SRC_MASK_LCD0, 4, CLK_SET_RATE_PARENT, 0),
> --
> 1.7.9.5

