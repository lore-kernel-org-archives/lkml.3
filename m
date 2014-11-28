Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751348AbaK1IyL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2014 03:54:11 -0500
Received: from gloria.sntech.de ([95.129.55.99]:34920 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750935AbaK1IyI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2014 03:54:08 -0500
From: Heiko =?ISO-8859-1?Q?St=FCbner?= <heiko@sntech.de>
To: Caesar Wang <caesar.wang@rock-chips.com>, khilman@kernel.org
Cc: linus.walleij@linaro.org, linux-arm-kernel@lists.infradead.org,
        Russell King <linux@arm.linux.org.uk>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Grant Likely <grant.likely@linaro.org>, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, Randy Dunlap <rdunlap@infradead.org>,
        linux-doc@vger.kernel.org, dianders@chromium.org,
        linux-rockchip@lists.infradead.org,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>, fzf@rock-chips.com,
        cf@rock-chips.com, chris.zhong@rock-chips.com, xxm@rock-chips.com,
        chm@rock-chips.com, djkurtz@chromium.org,
        Jack Dai <jack.dai@rock-chips.com>,
        "jinkun.hong" <jinkun.hong@rock-chips.com>
Subject: Re: [PATCH v12 3/3] ARM: dts: add rk3288 power-domain node
Date: Fri, 28 Nov 2014 09:57:47 +0100
Message-ID: <5063652.5fn5DLTjuV@diego>
User-Agent: KMail/4.14.1 (Linux/3.16-3-amd64; KDE/4.14.2; x86_64; ; )
In-Reply-To: <1416217842-4716-4-git-send-email-caesar.wang@rock-chips.com>
References: <1416217842-4716-1-git-send-email-caesar.wang@rock-chips.com> <1416217842-4716-4-git-send-email-caesar.wang@rock-chips.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Caesar,

Am Montag, 17. November 2014, 17:50:41 schrieb Caesar Wang:
> This patch add the needed clocks into power-controller.
> 
> why need we do so that?
> 
> Firstly, we always be needed turn off clocks to save power when
> the system enter suspend.So we need to enumerate the clocks are needed
> to switch power doamin no and off.
> 
> Secondly, Rk3288 reset circuit should be syncchronous reset and
> then sync revoked.so we need to enable clocks of all devices.
> 
> Signed-off-by: Jack Dai <jack.dai@rock-chips.com>
> Signed-off-by: jinkun.hong <jinkun.hong@rock-chips.com>
> Signed-off-by: Caesar Wang <caesar.wang@rock-chips.com>
> 
> ---
> 
> Changes in v12:
>     - Remove essential clocks from rk3288 PD_VIO domain,
>       Some clocks are essential for the system health and should not be
>       turned down. However there is no owner for them so if they listed as
>       belonging to power domain we'll try toggling them up and down during
>       power domain transition. As a result we either fail to suspend or
> resume the system.
> 
> Changes in v11: None
> Changes in v10:
>     - fix missing the #include <dt-bindings/power-domain/rk3288.h>
>     - remove the notes
> 
> Changes in v9:
>     - add decription for power-doamin node
> 
> Changes in v8:
>     - DTS go back to v2
> 
> Changes in v7: None
> Changes in v6: None
> Changes in v5: None
> Changes in v4: None
> Changes in v3:
>     - Decomposition power-controller, changed to multiple controller
>     (gpu-power-controller, hevc-power-controller)
> 
> Changes in v2:
>     - make pd_vio clocks all one entry per line and alphabetize.
>     - power: power-controller move back to pinctrl: pinctrl.
> 
>  arch/arm/boot/dts/rk3288.dtsi | 59
> +++++++++++++++++++++++++++++++++++++++++++ 1 file changed, 59
> insertions(+)
> 
> diff --git a/arch/arm/boot/dts/rk3288.dtsi b/arch/arm/boot/dts/rk3288.dtsi
> index cb18bb4..d9cd8c0 100644
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
> @@ -989,4 +990,62 @@
>  			};
>  		};
>  	};
> +
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
> +		pd_hevc {
> +			reg = <RK3288_PD_HEVC>;
> +			clocks = <&cru ACLK_HEVC>,
> +				 <&cru SCLK_HEVC_CABAC>,
> +				 <&cru SCLK_HEVC_CORE>,
> +				 <&cru HCLK_HEVC>;
> +		};
> +
> +		pd_vio {
> +			reg = <RK3288_PD_VIO>;
> +			clocks = <&cru ACLK_IEP>,
> +				 <&cru ACLK_ISP>,
> +				 <&cru ACLK_RGA>,
> +				 <&cru ACLK_VIP>,
> +				 <&cru ACLK_VOP0>,
> +				 <&cru ACLK_VOP1>,
> +				 <&cru DCLK_VOP0>,
> +				 <&cru DCLK_VOP1>,
> +				 <&cru HCLK_IEP>,
> +				 <&cru HCLK_ISP>,
> +				 <&cru HCLK_RGA>,
> +				 <&cru HCLK_VIP>,
> +				 <&cru HCLK_VOP0>,
> +				 <&cru HCLK_VOP1>,
> +				 <&cru PCLK_EDP_CTRL>,
> +				 <&cru PCLK_HDMI_CTRL>,
> +				 <&cru PCLK_LVDS_PHY>,
> +				 <&cru PCLK_MIPI_CSI>,
> +				 <&cru PCLK_MIPI_DSI0>,
> +				 <&cru PCLK_MIPI_DSI1>,
> +				 <&cru SCLK_EDP_24M>,
> +				 <&cru SCLK_EDP>,
> +				 <&cru SCLK_HDMI_CEC>,
> +				 <&cru SCLK_HDMI_HDCP>,
> +				 <&cru SCLK_ISP_JPE>,
> +				 <&cru SCLK_ISP>,
> +				 <&cru SCLK_RGA>;
> +		};
> +
> +		pd_video {
> +			reg = <RK3288_PD_VIDEO>;
> +			clocks = <&cru ACLK_VCODEC>,
> +				 <&cru HCLK_VCODEC>;
> +		};
> +	};
>  };
