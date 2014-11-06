Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751800AbaKFIqR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 03:46:17 -0500
Received: from va-smtp01.263.net ([54.88.144.211]:50872 "EHLO
	va-smtp01.263.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751142AbaKFIqM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 03:46:12 -0500
X-RL-SENDER: kever.yang@rock-chips.com
X-FST-TO: jack.dai@rock-chips.com
X-SENDER-IP: 127.0.0.1
X-LOGIN-NAME: kever.yang@rock-chips.com
X-UNIQUE-TAG: <cc80bc10ca58081fafeda78da36c8c29>
X-DNS-TYPE: 1
Message-ID: <545B3518.2090409@rock-chips.com>
Date: Thu, 06 Nov 2014 16:45:12 +0800
From: Kever Yang <kever.yang@rock-chips.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Caesar Wang <caesar.wang@rock-chips.com>, linus.walleij@linaro.org,
        linux-arm-kernel@lists.infradead.org, Heiko Stuebner <heiko@sntech.de>,
        Russell King <linux@arm.linux.org.uk>
CC: Mark Rutland <mark.rutland@arm.com>, devicetree@vger.kernel.org,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        "jinkun.hong" <jinkun.hong@rock-chips.com>,
        Randy Dunlap <rdunlap@infradead.org>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, dianders@chromium.org,
        linux-rockchip@lists.infradead.org, Rob Herring <robh+dt@kernel.org>,
        fzf@rock-chips.com, Kumar Gala <galak@codeaurora.org>,
        Grant Likely <grant.likely@linaro.org>, cf@rock-chips.com,
        Jack Dai <jack.dai@rock-chips.com>
Subject: Re: [PATCH v8 3/3] ARM: dts: add rk3288 power-domain node
References: <1415254961-5746-1-git-send-email-caesar.wang@rock-chips.com> <1415254961-5746-4-git-send-email-caesar.wang@rock-chips.com>
In-Reply-To: <1415254961-5746-4-git-send-email-caesar.wang@rock-chips.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Caesar,

On 11/06/2014 02:22 PM, Caesar Wang wrote:
> Signed-off-by: Jack Dai <jack.dai@rock-chips.com>
> Signed-off-by: jinkun.hong <jinkun.hong@rock-chips.com>
> Signed-off-by: Caesar Wang <caesar.wang@rock-chips.com>
pls detail the reason why you need to add all the clocks into 
power-controller node.
> ---
>
> Changes in v8:
>      - DTS go back to v2
>
> Changes in v7: None
> Changes in v6: None
> Changes in v5: None
> Changes in v4: None
> Changes in v3:
>      - Decomposition power-controller, changed to multiple controller
>      (gpu-power-controller, hevc-power-controller)
>
> Changes in v2:
>      - make pd_vio clocks all one entry per line and alphabetize.
>      - power: power-controller move back to pinctrl: pinctrl.
>
>   arch/arm/boot/dts/rk3288.dtsi | 66 +++++++++++++++++++++++++++++++++++++++++++
>   1 file changed, 66 insertions(+)
>
> diff --git a/arch/arm/boot/dts/rk3288.dtsi b/arch/arm/boot/dts/rk3288.dtsi
> index cb18bb4..9cd269a 100644
> --- a/arch/arm/boot/dts/rk3288.dtsi
> +++ b/arch/arm/boot/dts/rk3288.dtsi
> @@ -989,4 +989,70 @@
>   			};
>   		};
>   	};
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
> +				 <&cru ACLK_RGA_NIU>,
> +				 <&cru ACLK_RGA>,
> +				 <&cru ACLK_VIO0_NIU>,
> +				 <&cru ACLK_VIO1_NIU>,
> +				 <&cru ACLK_VIP>,
> +				 <&cru ACLK_VOP0>,
> +				 <&cru ACLK_VOP1>,
> +				 <&cru DCLK_VOP0>,
> +				 <&cru DCLK_VOP1>,
> +				 <&cru HCLK_IEP>,
> +				 <&cru HCLK_ISP>,
> +				 <&cru HCLK_RGA>,
> +				 <&cru HCLK_VIO_AHB_ARBI>,
> +				 <&cru HCLK_VIO_NIU>,
> +				 <&cru HCLK_VIO2_H2P>,
> +				 <&cru HCLK_VIP>,
> +				 <&cru HCLK_VOP0>,
> +				 <&cru HCLK_VOP1>,
> +				 <&cru PCLK_EDP_CTRL>,
> +				 <&cru PCLK_HDMI_CTRL>,
> +				 <&cru PCLK_LVDS_PHY>,
> +				 <&cru PCLK_MIPI_CSI>,
> +				 <&cru PCLK_MIPI_DSI0>,
> +				 <&cru PCLK_MIPI_DSI1>,
> +				 <&cru PCLK_VIO2_H2P>,
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
> +			/* FIXME: add clocks */
remove the 'FIXME'.
> +			clocks = <&cru ACLK_VCODEC>,
> +				 <&cru HCLK_VCODEC>;
> +		};
> +	};
>   };

