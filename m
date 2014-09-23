Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756477AbaIWRxt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 13:53:49 -0400
Received: from gloria.sntech.de ([95.129.55.99]:56275 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754877AbaIWRxr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 13:53:47 -0400
From: Heiko =?ISO-8859-1?Q?St=FCbner?= <heiko@sntech.de>
To: "jinkun.hong" <jinkun.hong@rock-chips.com>
Cc: linux-rockchip@lists.infradead.org, Russell King <linux@arm.linux.org.uk>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Grant Likely <grant.likely@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, Randy Dunlap <rdunlap@infradead.org>,
        linux-doc@vger.kernel.org, Jack Dai <jack.dai@rock-chips.com>,
        Wang Caesar <caesar.wang@rock-chips.com>
Subject: Re: [PATCH 3/3] ARM: dts: add rk3288 power-domain node
Date: Tue, 23 Sep 2014 19:52:49 +0200
Message-ID: <2840362.2VhRfgMh5I@phil>
User-Agent: KMail/4.11.5 (Linux/3.13-1-amd64; KDE/4.11.3; x86_64; ; )
In-Reply-To: <1411440916-6830-4-git-send-email-jinkun.hong@rock-chips.com>
References: <1411440916-6830-1-git-send-email-jinkun.hong@rock-chips.com> <1411440916-6830-4-git-send-email-jinkun.hong@rock-chips.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag, 22. September 2014, 19:55:16 schrieb jinkun.hong:
> From: "jinkun.hong" <jinkun.hong@rock-chips.com>
> 
> Signed-off-by: Jack Dai <jack.dai@rock-chips.com>
> Signed-off-by: Wang Caesar <caesar.wang@rock-chips.com>
> Signed-off-by: jinkun.hong <jinkun.hong@rock-chips.com>
> 
> ---
> 
>  arch/arm/boot/dts/rk3288.dtsi |   45
> +++++++++++++++++++++++++++++++++++++++++ 1 file changed, 45 insertions(+)
> 
> diff --git a/arch/arm/boot/dts/rk3288.dtsi b/arch/arm/boot/dts/rk3288.dtsi
> index 3bb5230..714b9d9 100644
> --- a/arch/arm/boot/dts/rk3288.dtsi
> +++ b/arch/arm/boot/dts/rk3288.dtsi
> @@ -15,6 +15,7 @@
>  #include <dt-bindings/interrupt-controller/arm-gic.h>
>  #include <dt-bindings/pinctrl/rockchip.h>
>  #include <dt-bindings/clock/rk3288-cru.h>
> +#include <dt-bindings/power-domain/rk3288.h>
>  #include "skeleton.dtsi"
> 
>  / {
> @@ -467,6 +468,50 @@
>  		compatible = "rockchip,rk3288-pmu", "syscon";
>  		reg = <0xff730000 0x100>;
>  	};

missing blank line here

Also please mind the ordering. We have the nodes without registers (like the 
pinctrl) at the bottom, so maybe add the power-controller alphabetically after 
the pinctrl node.

> +	power: power-controller {
> +		compatible = "rockchip,rk3288-power-controller";
> +		#power-domain-cells = <1>;
> +		rockchip,pmu = <&pmu>;
> +		#address-cells = <1>;
> +		#size-cells = <0>;
> +
> +		pd_gpu {
> +			reg = <RK3288_PD_GPU>;
> +			clocks = <&cru ACLK_GPU>;
> +		};
> +
> +		pd_vio {
> +			reg = <RK3288_PD_VIO>;
> +			clocks = <&cru HCLK_RGA>, <&cru HCLK_VOP0>,
> +				<&cru HCLK_VOP1>, <&cru HCLK_VIO_AHB_ARBI>,
> +				<&cru HCLK_VIO_NIU>, <&cru HCLK_VIP>,
> +				<&cru HCLK_IEP>, <&cru HCLK_ISP>,
> +				<&cru HCLK_VIO2_H2P>, <&cru PCLK_MIPI_DSI0>,
> +				<&cru PCLK_MIPI_DSI1>, <&cru PCLK_MIPI_CSI>,
> +				<&cru PCLK_LVDS_PHY>, <&cru PCLK_EDP_CTRL>,
> +				<&cru PCLK_HDMI_CTRL>, <&cru PCLK_VIO2_H2P>,
> +				<&cru ACLK_VOP0>, <&cru ACLK_IEP>,
> +				<&cru ACLK_VIO0_NIU>, <&cru ACLK_VIP>,
> +				<&cru ACLK_VOP1>, <&cru ACLK_ISP>,
> +				<&cru ACLK_VIO1_NIU>, <&cru ACLK_RGA>,
> +				<&cru ACLK_RGA_NIU>,<&cru SCLK_RGA>,
> +				<&cru DCLK_VOP0>, <&cru DCLK_VOP1>,
> +				<&cru SCLK_EDP_24M>, <&cru SCLK_EDP>,
> +				<&cru SCLK_ISP>, <&cru SCLK_ISP_JPE>,
> +				<&cru SCLK_HDMI_HDCP>, <&cru SCLK_HDMI_CEC>;
> +		};
> +
> +		pd_video {
> +			reg = <RK3288_PD_VIDEO>;
> +			/* FIXME: add clocks */

what is missing for these clocks? If it's just more clock ids, please 
corrdinate with Kever

> +			};
> +
> +		pd_hevc {
> +			reg = <RK3288_PD_HEVC>;
> +			clocks = <&cru ACLK_HEVC>, <&cru HCLK_HEVC>,
> +				<&cru SCLK_HEVC_CABAC>, <&cru SCLK_HEVC_CORE>;
> +			};
> +	};
> 
>  	sgrf: syscon@ff740000 {
>  		compatible = "rockchip,rk3288-sgrf", "syscon";

