Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751074AbaEVE2p (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 00:28:45 -0400
Received: from mail-pd0-f181.google.com ([209.85.192.181]:62503 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750720AbaEVE2n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 00:28:43 -0400
Message-ID: <537D7CF4.6050305@linaro.org>
Date: Thu, 22 May 2014 09:58:36 +0530
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
Subject: Re: [PATCH 3/4] clk: samsung: Add driver to control CLKOUT line on
 Exynos SoCs
References: <1400604211-9447-1-git-send-email-t.figa@samsung.com> <1400604211-9447-4-git-send-email-t.figa@samsung.com>
In-Reply-To: <1400604211-9447-4-git-send-email-t.figa@samsung.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/20/2014 10:13 PM, Tomasz Figa wrote:
> This patch introduces a driver that handles configuration of CLKOUT pin
> of Exynos SoCs that can be used to output certain clocks from inside of
> the SoC to a dedicated output pin.
> 
> Signed-off-by: Tomasz Figa <t.figa@samsung.com>
> ---
>  .../devicetree/bindings/arm/samsung/pmu.txt        |  30 ++++
>  drivers/clk/samsung/Makefile                       |   1 +
>  drivers/clk/samsung/clk-exynos-clkout.c            | 153 +++++++++++++++++++++
>  3 files changed, 184 insertions(+)
>  create mode 100644 drivers/clk/samsung/clk-exynos-clkout.c
> 
> diff --git a/Documentation/devicetree/bindings/arm/samsung/pmu.txt b/Documentation/devicetree/bindings/arm/samsung/pmu.txt
> index b562634..5ed94a9 100644
> --- a/Documentation/devicetree/bindings/arm/samsung/pmu.txt
> +++ b/Documentation/devicetree/bindings/arm/samsung/pmu.txt
> @@ -11,8 +11,38 @@ Properties:
>  
>   - reg : offset and length of the register set.
>  
> + - #clock-cells : must be <1>, since PMU requires once cell as clock specifier.

s/once/one

> +		The single specifier cell is used as index to list of clocks
> +		provided by PMU, which is currently:
> +			0 : SoC clock output (CLKOUT pin)

Will it make more sense if we add a macro for this clock number that
would be referred in the device tree files?

> +Example of clock consumer :
> +
> +usb3503: usb3503@08 {
> +	/* ... */
> +	clock-names = "refclk";
> +	clocks = <&pmu_system_controller 0>;
> +	/* ... */
>  };

-- 
Tushar Behera
