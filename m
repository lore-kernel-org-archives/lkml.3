Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752711AbaESHQT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 03:16:19 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:45141 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750759AbaESHQQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 03:16:16 -0400
Message-ID: <5379AFB9.9030608@linaro.org>
Date: Mon, 19 May 2014 12:46:09 +0530
From: Tushar Behera <tushar.behera@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Tomasz Figa <t.figa@samsung.com>, linux-samsung-soc@vger.kernel.org
CC: linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Mike Turquette <mturquette@linaro.org>,
        Kukjin Kim <kgene.kim@samsung.com>, Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Pankaj Dubey <pankaj.dubey@samsung.com>,
        Rahul Sharma <rahul.sharma@samsung.com>,
        Mark Brown <broonie@kernel.org>, Tomasz Figa <tomasz.figa@gmail.com>
Subject: Re: [PATCH RFC 3/4] clk: samsung: Add driver to control CLKOUT line
 on Exynos SoCs
References: <1400175151-27779-1-git-send-email-t.figa@samsung.com> <1400175151-27779-4-git-send-email-t.figa@samsung.com>
In-Reply-To: <1400175151-27779-4-git-send-email-t.figa@samsung.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/15/2014 11:02 PM, Tomasz Figa wrote:
> This patch introduces a driver that handles configuration of CLKOUT pin
> of Exynos SoCs that can be used to output certain clocks from inside of
> the SoC to a dedicated output pin.
> 
> Signed-off-by: Tomasz Figa <t.figa@samsung.com>
> ---

Tested the series on Exynos5420-based peach-pit board for audio playback
(with an internal patch to set CLK_FIN_PLL as the parent of clkout).

Tested-by: Tushar Behera <tushar.behera@linaro.org>

>  Example :
>  pmu_system_controller: system-controller@10040000 {
>  	compatible = "samsung,exynos5250-pmu", "syscon";
>  	reg = <0x10040000 0x5000>;
> +	#clock-cells = <0>;
> +	clock-names = "clkout0", "clkout1", "clkout2", "clkout3",
> +			"clkout4", "clkout8", "clkout9";
> +	clocks = <&clock CLK_OUT_DMC>, <&clock CLK_OUT_TOP>,
> +		<&clock CLK_OUT_LEFTBUS>, <&clock CLK_OUT_RIGHTBUS>,
> +		<&clock CLK_OUT_CPU>, <&clock CLK_XXTI>,
> +		<&clock CLK_XUSBXTI>;
>  };

Adding an usage example in the documentation would be helpful.


-- 
Tushar Behera
