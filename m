Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755929Ab3G2OMa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 10:12:30 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:38819 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751494Ab3G2OM3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 10:12:29 -0400
Date: Mon, 29 Jul 2013 15:11:54 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Mike Turquette <mturquette@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        "albert.u.boot@aribaud.net" <albert.u.boot@aribaud.net>,
        Emilio Lopez <emilio@elopez.com.ar>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "shuge@allwinnertech.com" <shuge@allwinnertech.com>,
        "linux-sunxi@googlegroups.com" <linux-sunxi@googlegroups.com>,
        "kevin.z.m.zh@gmail.com" <kevin.z.m.zh@gmail.com>,
        "sunny@allwinnertech.com" <sunny@allwinnertech.com>,
        Olof Johansson <olof@lixom.net>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 05/10] ARM: sunxi: Add Allwinner A31 DTSI
Message-ID: <20130729141154.GB25264@e106331-lin.cambridge.arm.com>
References: <1374618312-19001-1-git-send-email-maxime.ripard@free-electrons.com>
 <1374618312-19001-6-git-send-email-maxime.ripard@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1374618312-19001-6-git-send-email-maxime.ripard@free-electrons.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 23, 2013 at 11:25:07PM +0100, Maxime Ripard wrote:
> Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
> ---
>  arch/arm/boot/dts/Makefile       |   3 +-
>  arch/arm/boot/dts/sun6i-a31.dtsi | 155 +++++++++++++++++++++++++++++++++++++++
>  2 files changed, 157 insertions(+), 1 deletion(-)
>  create mode 100644 arch/arm/boot/dts/sun6i-a31.dtsi

[...]

> +	soc@01c20000 {
> +		compatible = "simple-bus";
> +		#address-cells = <1>;
> +		#size-cells = <1>;
> +		reg = <0x01c20000 0x300000>;

That's unnecessary, nothing should be using this for a simple-bus.

> +		ranges;
> +
> +		timer@01c20c00 {
> +			compatible = "allwinner,sun4i-timer";
> +			reg = <0x01c20c00 0xa0>;
> +			interrupts = <
> +					0 18 1
> +					0 19 1
> +					0 20 1
> +					0 21 1
> +					0 22 1
> +					>;

A cosmetic issue, but this would be nicer with each tuple bracketed:

			interrupts = <0 18 1>,
				     <0 19 1>,
				     <0 20 1>,
				     <0 21 1>,
				     <0 22 1>;

> +			clocks = <&osc>;
> +		};

Thanks,
Mark.
