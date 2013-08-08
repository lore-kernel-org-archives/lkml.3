Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965223Ab3HHLRk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 07:17:40 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:10737 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757728Ab3HHLRi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 07:17:38 -0400
X-AuditID: cbfec7f4-b7f5f6d000000ff6-1b-52037e50a61b
Message-id: <52037E4E.5050706@samsung.com>
Date: Thu, 08 Aug 2013 13:17:34 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-version: 1.0
To: Cho KyongHo <pullip.cho@samsung.com>
Cc: "'Linux ARM Kernel'" <linux-arm-kernel@lists.infradead.org>,
        "'Linux IOMMU'" <iommu@lists.linux-foundation.org>,
        "'Linux Kernel'" <linux-kernel@vger.kernel.org>,
        "'Linux Samsung SOC'" <linux-samsung-soc@vger.kernel.org>,
        devicetree@vger.kernel.org, "'Joerg Roedel'" <joro@8bytes.org>,
        "'Kukjin Kim'" <kgene.kim@samsung.com>,
        "'Prathyush'" <prathyush.k@samsung.com>,
        "'Rahul Sharma'" <rahul.sharma@samsung.com>,
        "'Subash Patel'" <supash.ramaswamy@linaro.org>,
        "'Grant Grundler'" <grundler@chromium.org>,
        "'Antonios Motakis'" <a.motakis@virtualopensystems.com>,
        kvmarm@lists.cs.columbia.edu,
        "'Sachin Kamat'" <sachin.kamat@linaro.org>
Subject: Re: [PATCH v9 05/16] clk: exynos: add gate clock descriptions of
 System MMU
References: <002901ce941b$0130db50$039291f0$@samsung.com>
In-reply-to: <002901ce941b$0130db50$039291f0$@samsung.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrGLMWRmVeSWpSXmKPExsVy+t/xa7oBdcxBBvt7uC3u3D3HajH/CJB4
	deQHk8WC/dYWnbM3sFv0LrjKZvHx1HF2i02Pr7FaXN41h81ixvl9TBYXVmxkt/jXe5DRYsqi
	w6wWJ//0Mlq0XO9lcuD3eHJwHpPH7IaLLB53ru1h8zi/aQ2zx+Yl9R6Tbyxn9OjbsorR4/Mm
	OY8rR88wBXBGcdmkpOZklqUW6dslcGUcXLGCqeABT8X/6T+ZGxh3cXUxcnJICJhILHz4gAnC
	FpO4cG89G4gtJLCUUWL+04guRi4g+xOjxMEHh5hBErwCWhK/Fqxm7GLk4GARUJX484QRJMwm
	YCjRe7QPzBYVCJBYvOQcO0S5oMSPyfdYQGwRAQ2Jz1fWs4LYzAI/WCQ+beMDsYUFwiROHOqE
	2mspcf5SA9g9nAJWEue7nkPV60jsb53GBmHLS2xe85Z5AqPALCQrZiEpm4WkbAEj8ypG0dTS
	5ILipPRcQ73ixNzi0rx0veT83E2MkLj6soNx8TGrQ4wCHIxKPLwdAUxBQqyJZcWVuYcYJTiY
	lUR4X2QxBwnxpiRWVqUW5ccXleakFh9iZOLglGpg7NydvfbvlEWz5zrt+RauEL9z2WHrm1Xe
	/ud2bPq//sirHzm8Ny+s3le9Ya5NXFQJo/viU+vtvvqYtSTUJolp3grlUF/CrLApxUNolvab
	zMiFndtEJ7xJe17Ela54WPv1ZoVnzyovPzspFaKYuZNrB9/7cwmrwj4fuxIn1SaecOlEOIPS
	IX4NAyWW4oxEQy3mouJEAPHkkYeJAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/08/2013 11:38 AM, Cho KyongHo wrote:
> This adds gate clocks of all System MMUs and their master IPs
> that are not apeared in clk-exynos5250.c
> Also fixes GATE_IP_ACP to 0x18800 and changed GATE_DA to GATE
> for System MMU clocks in clk-exynos4.c
> 
> Signed-off-by: Cho KyongHo <pullip.cho@samsung.com>
> ---
>  .../devicetree/bindings/clock/exynos5250-clock.txt |   26 +++++++++
>  drivers/clk/samsung/clk-exynos4.c                  |   27 +++------
>  drivers/clk/samsung/clk-exynos5250.c               |   57 ++++++++++++++++----
>  3 files changed, 82 insertions(+), 28 deletions(-)
[...]
> @@ -349,19 +358,26 @@ static struct samsung_gate_clock exynos5250_gate_clks[] __initdata = {
>  	GATE(gscl3, "gscl3", "aclk266", GATE_IP_GSCL, 3, 0, 0),
>  	GATE(gscl_wa, "gscl_wa", "div_gscl_wa", GATE_IP_GSCL, 5, 0, 0),
>  	GATE(gscl_wb, "gscl_wb", "div_gscl_wb", GATE_IP_GSCL, 6, 0, 0),
> -	GATE(smmu_gscl0, "smmu_gscl0", "aclk266", GATE_IP_GSCL, 7, 0, 0),
> -	GATE(smmu_gscl1, "smmu_gscl1", "aclk266", GATE_IP_GSCL, 8, 0, 0),
> -	GATE(smmu_gscl2, "smmu_gscl2", "aclk266", GATE_IP_GSCL, 9, 0, 0),
> -	GATE(smmu_gscl3, "smmu_gscl3", "aclk266", GATE_IP_GSCL, 10, 0, 0),
> +	GATE(smmu_gscl0, "smmu_gscl0", "none", GATE_IP_GSCL, 7, 0, 0),
> +	GATE(smmu_gscl1, "smmu_gscl1", "none", GATE_IP_GSCL, 8, 0, 0),
> +	GATE(smmu_gscl2, "smmu_gscl2", "none", GATE_IP_GSCL, 9, 0, 0),
> +	GATE(smmu_gscl3, "smmu_gscl3", "none", GATE_IP_GSCL, 10, 0, 0),

Why are the smmu clocks' parent clocks removed ? Shouldn't both the gscaler
gate clock and the gscaler smmu clock be still same, as it is in case of
exynos4 ?
