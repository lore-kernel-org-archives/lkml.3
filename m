Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752439AbaJKSBg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Oct 2014 14:01:36 -0400
Received: from gloria.sntech.de ([95.129.55.99]:56117 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750834AbaJKSBe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Oct 2014 14:01:34 -0400
From: Heiko =?ISO-8859-1?Q?St=FCbner?= <heiko@sntech.de>
To: Kever Yang <kever.yang@rock-chips.com>
Cc: dianders@chromium.org, sonnyrao@chromium.org, addy.ke@rock-chips.com,
        cf@rock-chips.com, xjq@rock-chips.com, hj@rock-chips.com,
        huangtao@rock-chips.com, linux-rockchip@lists.infradead.org,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 6/6] ARM: dts: rockchip: add intmem node for rk3288 smp support
Date: Sat, 11 Oct 2014 20:01:01 +0200
Message-ID: <1772006.xWk9SpEHRu@phil>
User-Agent: KMail/4.11.5 (Linux/3.13-1-amd64; KDE/4.11.3; x86_64; ; )
In-Reply-To: <1412976370-14468-7-git-send-email-kever.yang@rock-chips.com>
References: <1412976370-14468-1-git-send-email-kever.yang@rock-chips.com> <1412976370-14468-7-git-send-email-kever.yang@rock-chips.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Freitag, 10. Oktober 2014, 14:26:10 schrieb Kever Yang:
> This patch add intmem node des which is needed by platsmp.c
> 
> Signed-off-by: Heiko Stuebner <heiko@sntech.de>

again without this Signed-off please (also true for patch 5/6 where I forgot to 
mention it)

> Signed-off-by: Kever Yang <kever.yang@rock-chips.com>
> ---
> 
> Changes in v3:
> - remove 'enable-method' from this patch
> - add compitable name "rockchip,rk3288-pmu-sram" for pmu-intmem
> 
> Changes in v2:
> - adjust the alignment
> 
>  arch/arm/boot/dts/rk3288.dtsi | 17 +++++++++++++++++
>  1 file changed, 17 insertions(+)
> 
> diff --git a/arch/arm/boot/dts/rk3288.dtsi b/arch/arm/boot/dts/rk3288.dtsi
> index 44108fe..5e9c56d 100644
> --- a/arch/arm/boot/dts/rk3288.dtsi
> +++ b/arch/arm/boot/dts/rk3288.dtsi
> @@ -441,6 +441,23 @@
>  		status = "disabled";
>  	};
> 
> +	bus_intmem@ff700000 {
> +		compatible = "mmio-sram";
> +		reg = <0xff700000 0x18000>;
> +		#address-cells = <1>;
> +		#size-cells = <1>;
> +		ranges = <0 0xff700000 0x18000>;
> +		smp-sram@0 {
> +			compatible = "rockchip,rk3066-smp-sram";
> +			reg = <0x00 0x10>;
> +		};
> +	};
> +
> +	pmu_intmem@ff720000 {
> +		compatible = "mmio-sram", "rockchip,rk3288-pmu-sram";

general rule, the more specific compatible should be in front, so
		compatible = "rockchip,rk3288-pmu-sram", "mmio-sram";

This way, if there is a driver for "rockchip,rk3288-pmu-sram" at some point in 
the future, it will grab the node before the more generic sram driver does.

But in general, what is the pmu sram necessary for, as no part of this series 
uses it?

> +		reg = <0xff720000 0x4000>;
> +	};
> +
>  	pmu: power-management@ff730000 {
>  		compatible = "rockchip,rk3066-pmu", "syscon";
>  		reg = <0xff730000 0x100>;

