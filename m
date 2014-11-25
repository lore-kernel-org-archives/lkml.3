Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751291AbaKYJ7d (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 04:59:33 -0500
Received: from va-smtp01.263.net ([54.88.144.211]:58612 "EHLO
	va-smtp01.263.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750760AbaKYJ7b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 04:59:31 -0500
X-RL-SENDER: kever.yang@rock-chips.com
X-FST-TO: eddie.cai@rock-chips.com
X-SENDER-IP: 127.0.0.1
X-LOGIN-NAME: kever.yang@rock-chips.com
X-UNIQUE-TAG: <29aa5592904a59287eecd66c054cc6e2>
X-ATTACHMENT-NUM: 0
X-DNS-TYPE: 1
Message-ID: <547452F0.1080307@rock-chips.com>
Date: Tue, 25 Nov 2014 17:59:12 +0800
From: Kever Yang <kever.yang@rock-chips.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Roger Chen <roger.chen@rock-chips.com>, heiko@sntech.de
CC: peppe.cavallaro@st.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-rockchip@lists.infradead.org,
        mark.yao@rock-chips.com, eddie.cai@rock-chips.com
Subject: Re: [PATCH 4/4] GMAC: dts: enable gmac on RK3288 evb board
References: <1416906549-26196-1-git-send-email-roger.chen@rock-chips.com>
In-Reply-To: <1416906549-26196-1-git-send-email-roger.chen@rock-chips.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Roger,

The subject should prefix:
Arm: dts: rockchip: enable ...

On 11/25/2014 05:09 PM, Roger Chen wrote:
> enable gmac in rk3288-evb-rk808.dts
>
> Signed-off-by: Roger Chen <roger.chen@rock-chips.com>
> ---
>   arch/arm/boot/dts/rk3288-evb-rk808.dts |   22 ++++++++++++++++++++++
>   1 file changed, 22 insertions(+)
>
> diff --git a/arch/arm/boot/dts/rk3288-evb-rk808.dts b/arch/arm/boot/dts/rk3288-evb-rk808.dts
> index d8c775e6..168b4fa 100644
> --- a/arch/arm/boot/dts/rk3288-evb-rk808.dts
> +++ b/arch/arm/boot/dts/rk3288-evb-rk808.dts
> @@ -152,3 +152,25 @@
>   		};
>   	};
>   };
> +
> +&ext_gmac {
> +	clock-frequency = <125000000>;
> +	clock-output-names = "ext_gmac";
> +};
> +
> +&gmac {
> +	//pmu_regulator = "act_ldo5";
> +	//pmu_enable_level = <1>; //1->HIGH, 0->LOW
remove these unused code.
> +	power-gpio = <&gpio0 6 GPIO_ACTIVE_HIGH>;
> +	reset-gpio = <&gpio4 7 GPIO_ACTIVE_LOW>;
> +	//phyirq-gpio = <&gpio4 2 GPIO_ACTIVE_LOW>;
same.
> +	phy-mode = "rgmii";
> +	clock_in_out = "input";
> +	assigned-clocks = <&cru SCLK_MAC>;
> +	assigned-clock-parents = <&ext_gmac>;
> +	pinctrl-names = "default";
> +	pinctrl-0 = <&rgmii_pin>; /*&rmii_pin*/
same.

- Kever
> +	tx_delay = <0x30>;
> +	rx_delay = <0x10>;
> +	status = "ok";
> +};

