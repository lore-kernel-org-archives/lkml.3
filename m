Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751965AbaEMPSg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 11:18:36 -0400
Received: from yotta.elopez.com.ar ([31.220.24.173]:58315 "EHLO
	yotta.elopez.com.ar" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750908AbaEMPSa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 11:18:30 -0400
Message-ID: <53723796.10308@elopez.com.ar>
Date: Tue, 13 May 2014 12:17:42 -0300
From: =?ISO-8859-1?Q?Emilio_L=F3pez?= <emilio@elopez.com.ar>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Boris BREZILLON <boris.brezillon@free-electrons.com>,
        Mike Turquette <mturquette@linaro.org>,
        Lee Jones <lee.jones@linaro.org>,
        Maxime Ripard <maxime.ripard@free-electrons.com>
CC: Samuel Ortiz <sameo@linux.intel.com>, Chen-Yu Tsai <wens@csie.org>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Shuge <shuge@allwinnertech.com>, kevin@allwinnertech.com,
        Hans de Goede <hdegoede@redhat.com>,
        Randy Dunlap <rdunlap@infradead.org>, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, dev@linux-sunxi.org
Subject: Re: [PATCH v3 7/7] ARM: sunxi: dt: add PRCM clk and reset controller
 subdevices
References: <1399633911-7094-1-git-send-email-boris.brezillon@free-electrons.com> <1399633911-7094-8-git-send-email-boris.brezillon@free-electrons.com>
In-Reply-To: <1399633911-7094-8-git-send-email-boris.brezillon@free-electrons.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Boris,

El 09/05/14 08:11, Boris BREZILLON escribió:
> Add DT definitions for PRCM (Power/Reset/Clock Management) clock and reset
> controller subdevices.
>
> Signed-off-by: Boris BREZILLON <boris.brezillon@free-electrons.com>
> ---
>   arch/arm/boot/dts/sun6i-a31.dtsi | 37 +++++++++++++++++++++++++++++++++++++
>   1 file changed, 37 insertions(+)
>
> diff --git a/arch/arm/boot/dts/sun6i-a31.dtsi b/arch/arm/boot/dts/sun6i-a31.dtsi
> index 9feb3f4..03d5258 100644
> --- a/arch/arm/boot/dts/sun6i-a31.dtsi
> +++ b/arch/arm/boot/dts/sun6i-a31.dtsi
> @@ -496,6 +496,43 @@
>   		prcm@01f01400 {
>   			compatible = "allwinner,sun6i-a31-prcm";
>   			reg = <0x01f01400 0x200>;
> +
> +			ar100: ar100_clk {
> +				compatible = "allwinner,sun6i-a31-ar100-clk";
> +				#clock-cells = <0>;
> +				clocks = <&osc32k>, <&osc24M>, <&pll6>, <&pll6>;

You could add
				clock-output-names = "ar100";
here, so you don't depend on the node name. Your code already checks for 
it and uses it when available.

> +			};

Cheers,

Emilio

