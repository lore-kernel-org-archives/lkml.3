Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933498AbaDIOIO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 10:08:14 -0400
Received: from yotta.elopez.com.ar ([31.220.24.173]:40747 "EHLO
	yotta.elopez.com.ar" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932866AbaDIOIL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 10:08:11 -0400
Message-ID: <534553FF.4060401@elopez.com.ar>
Date: Wed, 09 Apr 2014 11:06:55 -0300
From: =?ISO-8859-1?Q?Emilio_L=F3pez?= <emilio@elopez.com.ar>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Boris BREZILLON <boris.brezillon@free-electrons.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Mike Turquette <mturquette@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>
CC: devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 07/15] ARM: sunxi: dt: define A31's APB0 clk gates node
References: <1397051478-4113-1-git-send-email-boris.brezillon@free-electrons.com> <1397051478-4113-8-git-send-email-boris.brezillon@free-electrons.com>
In-Reply-To: <1397051478-4113-8-git-send-email-boris.brezillon@free-electrons.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Boris,

El 09/04/14 10:51, Boris BREZILLON escribió:
> Define the APB0 clk gates controlled by the PRCM (Power/Reset/Clock
> Management) block.
>
> Signed-off-by: Boris BREZILLON <boris.brezillon@free-electrons.com>
> ---
>   arch/arm/boot/dts/sun6i-a31.dtsi | 10 ++++++++++
>   1 file changed, 10 insertions(+)
>
> diff --git a/arch/arm/boot/dts/sun6i-a31.dtsi b/arch/arm/boot/dts/sun6i-a31.dtsi
> index 3858424..61e8b34 100644
> --- a/arch/arm/boot/dts/sun6i-a31.dtsi
> +++ b/arch/arm/boot/dts/sun6i-a31.dtsi
> @@ -141,6 +141,16 @@
>   					"ahb1_drc0", "ahb1_drc1";
>   		};
>
> +		apb0_gates: apb0_gates@01f01428 {

Looks like this node is out of place, judging by the address. Try to 
keep them in order.

> +			#clock-cells = <1>;
> +			compatible = "allwinner,sun6i-a31-apb0-gates-clk";
> +			reg = <0x01f01428 0x4>;
> +			clock-output-names = "apb0_pio", "apb0_ir",
> +					"apb0_timer01", "apb0_p2wi",
> +					"apb0_uart", "apb0_1wire",
> +					"apb0_i2c";
> +		};
> +
>   		apb1: apb1@01c20054 {
>   			#clock-cells = <0>;
>   			compatible = "allwinner,sun4i-apb0-clk";
>

Cheers,

Emilio
