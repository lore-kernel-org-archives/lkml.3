Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751772AbaIWDgY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 23:36:24 -0400
Received: from va-smtp01.263.net ([54.88.144.211]:56411 "EHLO
	va-smtp01.263.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750828AbaIWDgW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 23:36:22 -0400
X-RL-SENDER: kever.yang@rock-chips.com
X-FST-TO: caesar.wang@rock-chips.com
X-SENDER-IP: 127.0.0.1
X-LOGIN-NAME: kever.yang@rock-chips.com
X-UNIQUE-TAG: <1dec8537f83966342c1b2188b13a38a3>
X-ATTACHMENT-NUM: 0
X-DNS-TYPE: 1
Message-ID: <5420EAA9.5000508@rock-chips.com>
Date: Tue, 23 Sep 2014 11:36:09 +0800
From: Kever Yang <kever.yang@rock-chips.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: "jinkun.hong" <jinkun.hong@rock-chips.com>,
        linux-rockchip@lists.infradead.org, Heiko Stuebner <heiko@sntech.de>,
        Russell King <linux@arm.linux.org.uk>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Grant Likely <grant.likely@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, Randy Dunlap <rdunlap@infradead.org>,
        linux-doc@vger.kernel.org
CC: Jack Dai <jack.dai@rock-chips.com>,
        Wang Caesar <caesar.wang@rock-chips.com>
Subject: Re: [PATCH 3/3] ARM: dts: add rk3288 power-domain node
References: <1411440916-6830-1-git-send-email-jinkun.hong@rock-chips.com> <1411440916-6830-4-git-send-email-jinkun.hong@rock-chips.com>
In-Reply-To: <1411440916-6830-4-git-send-email-jinkun.hong@rock-chips.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 09/23/2014 10:55 AM, jinkun.hong wrote:
> From: "jinkun.hong" <jinkun.hong@rock-chips.com>
Any summary for rk3288 power controller?
Maybe you can say something about how rk3288 TRM described this module.
> Signed-off-by: Jack Dai <jack.dai@rock-chips.com>
> Signed-off-by: Wang Caesar <caesar.wang@rock-chips.com>
> Signed-off-by: jinkun.hong <jinkun.hong@rock-chips.com>
>
> ---
>
>   arch/arm/boot/dts/rk3288.dtsi |   45 +++++++++++++++++++++++++++++++++++++++++
>   1 file changed, 45 insertions(+)
>
> diff --git a/arch/arm/boot/dts/rk3288.dtsi b/arch/arm/boot/dts/rk3288.dtsi
> index 3bb5230..714b9d9 100644
> --- a/arch/arm/boot/dts/rk3288.dtsi
> +++ b/arch/arm/boot/dts/rk3288.dtsi
> @@ -15,6 +15,7 @@
>   #include <dt-bindings/interrupt-controller/arm-gic.h>
>   #include <dt-bindings/pinctrl/rockchip.h>
>   #include <dt-bindings/clock/rk3288-cru.h>
> +#include <dt-bindings/power-domain/rk3288.h>
>   #include "skeleton.dtsi"
>   
>   / {
> @@ -467,6 +468,50 @@
>   		compatible = "rockchip,rk3288-pmu", "syscon";
>   		reg = <0xff730000 0x100>;
>   	};
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
Some of clock id here is not in upstream or list, I will send the patch
including all these clock IDs later, maybe you should mention it in your
commit message?
> +
> +		pd_video {
> +			reg = <RK3288_PD_VIDEO>;
> +			/* FIXME: add clocks */
> +			};
> +
> +		pd_hevc {
> +			reg = <RK3288_PD_HEVC>;
> +			clocks = <&cru ACLK_HEVC>, <&cru HCLK_HEVC>,
> +				<&cru SCLK_HEVC_CABAC>, <&cru SCLK_HEVC_CORE>;
> +			};
> +	};
>   
>   	sgrf: syscon@ff740000 {
>   		compatible = "rockchip,rk3288-sgrf", "syscon";

