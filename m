Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753918AbaGJPMy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 11:12:54 -0400
Received: from hqemgate15.nvidia.com ([216.228.121.64]:18258 "EHLO
	hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752136AbaGJPMw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 11:12:52 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Thu, 10 Jul 2014 08:01:58 -0700
Message-ID: <53BEAD70.5010504@nvidia.com>
Date: Thu, 10 Jul 2014 18:12:48 +0300
From: Tuomas Tynkkynen <ttynkkynen@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>
CC: Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Felipe Balbi <balbi@ti.com>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [PATCH v2 2/4] ARM: tegra: Add resets & has-utmi-pad-registers
 flag to all USB PHYs
References: <1404436179-10745-1-git-send-email-ttynkkynen@nvidia.com> <1404436179-10745-3-git-send-email-ttynkkynen@nvidia.com>
In-Reply-To: <1404436179-10745-3-git-send-email-ttynkkynen@nvidia.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thierry,

Since Stephen's on a vacation, I'd like to double-check with you that 
the DT changes looks good. Greg has applied these to the USB tree today.

Thanks,
Tuomas

On 04/07/14 04:09, Tuomas Tynkkynen wrote:
> Add new properties to all of the Tegra PHYs that are now required
> according to the binding.
>
> In order to stay compatible with old device trees, the USB drivers
> will still function without these reset properties but with the old,
> potentially buggy behaviour.
>
> Signed-off-by: Tuomas Tynkkynen <ttynkkynen@nvidia.com>
> ---
> v2 changes: new patch, didn't exist in v1
>   arch/arm/boot/dts/tegra114.dtsi |    5 +++++
>   arch/arm/boot/dts/tegra124.dtsi |    7 +++++++
>   arch/arm/boot/dts/tegra20.dtsi  |    7 +++++++
>   arch/arm/boot/dts/tegra30.dtsi  |    7 +++++++
>   4 files changed, 26 insertions(+)
>
> diff --git a/arch/arm/boot/dts/tegra114.dtsi b/arch/arm/boot/dts/tegra114.dtsi
> index 335a1d8..80b8edd 100644
> --- a/arch/arm/boot/dts/tegra114.dtsi
> +++ b/arch/arm/boot/dts/tegra114.dtsi
> @@ -672,6 +672,8 @@
>   			 <&tegra_car TEGRA114_CLK_PLL_U>,
>   			 <&tegra_car TEGRA114_CLK_USBD>;
>   		clock-names = "reg", "pll_u", "utmi-pads";
> +		resets = <&tegra_car 22>, <&tegra_car 22>;
> +		reset-names = "usb", "utmi-pads";
>   		nvidia,hssync-start-delay = <0>;
>   		nvidia,idle-wait-delay = <17>;
>   		nvidia,elastic-limit = <16>;
> @@ -682,6 +684,7 @@
>   		nvidia,hssquelch-level = <2>;
>   		nvidia,hsdiscon-level = <5>;
>   		nvidia,xcvr-hsslew = <12>;
> +		nvidia,has-utmi-pad-registers;
>   		status = "disabled";
>   	};
>
> @@ -705,6 +708,8 @@
>   			 <&tegra_car TEGRA114_CLK_PLL_U>,
>   			 <&tegra_car TEGRA114_CLK_USBD>;
>   		clock-names = "reg", "pll_u", "utmi-pads";
> +		resets = <&tegra_car 59>, <&tegra_car 22>;
> +		reset-names = "usb", "utmi-pads";
>   		nvidia,hssync-start-delay = <0>;
>   		nvidia,idle-wait-delay = <17>;
>   		nvidia,elastic-limit = <16>;
> diff --git a/arch/arm/boot/dts/tegra124.dtsi b/arch/arm/boot/dts/tegra124.dtsi
> index d675186..5b14d79 100644
> --- a/arch/arm/boot/dts/tegra124.dtsi
> +++ b/arch/arm/boot/dts/tegra124.dtsi
> @@ -643,6 +643,8 @@
>   			 <&tegra_car TEGRA124_CLK_PLL_U>,
>   			 <&tegra_car TEGRA124_CLK_USBD>;
>   		clock-names = "reg", "pll_u", "utmi-pads";
> +		resets = <&tegra_car 22>, <&tegra_car 22>;
> +		reset-names = "usb", "utmi-pads";
>   		nvidia,hssync-start-delay = <0>;
>   		nvidia,idle-wait-delay = <17>;
>   		nvidia,elastic-limit = <16>;
> @@ -653,6 +655,7 @@
>   		nvidia,hssquelch-level = <2>;
>   		nvidia,hsdiscon-level = <5>;
>   		nvidia,xcvr-hsslew = <12>;
> +		nvidia,has-utmi-pad-registers;
>   		status = "disabled";
>   	};
>
> @@ -677,6 +680,8 @@
>   			 <&tegra_car TEGRA124_CLK_PLL_U>,
>   			 <&tegra_car TEGRA124_CLK_USBD>;
>   		clock-names = "reg", "pll_u", "utmi-pads";
> +		resets = <&tegra_car 58>, <&tegra_car 22>;
> +		reset-names = "usb", "utmi-pads";
>   		nvidia,hssync-start-delay = <0>;
>   		nvidia,idle-wait-delay = <17>;
>   		nvidia,elastic-limit = <16>;
> @@ -711,6 +716,8 @@
>   			 <&tegra_car TEGRA124_CLK_PLL_U>,
>   			 <&tegra_car TEGRA124_CLK_USBD>;
>   		clock-names = "reg", "pll_u", "utmi-pads";
> +		resets = <&tegra_car 59>, <&tegra_car 22>;
> +		reset-names = "usb", "utmi-pads";
>   		nvidia,hssync-start-delay = <0>;
>   		nvidia,idle-wait-delay = <17>;
>   		nvidia,elastic-limit = <16>;
> diff --git a/arch/arm/boot/dts/tegra20.dtsi b/arch/arm/boot/dts/tegra20.dtsi
> index 243d84c..1908f69 100644
> --- a/arch/arm/boot/dts/tegra20.dtsi
> +++ b/arch/arm/boot/dts/tegra20.dtsi
> @@ -645,6 +645,8 @@
>   			 <&tegra_car TEGRA20_CLK_CLK_M>,
>   			 <&tegra_car TEGRA20_CLK_USBD>;
>   		clock-names = "reg", "pll_u", "timer", "utmi-pads";
> +		resets = <&tegra_car 22>, <&tegra_car 22>;
> +		reset-names = "usb", "utmi-pads";
>   		nvidia,has-legacy-mode;
>   		nvidia,hssync-start-delay = <9>;
>   		nvidia,idle-wait-delay = <17>;
> @@ -653,6 +655,7 @@
>   		nvidia,xcvr-setup = <9>;
>   		nvidia,xcvr-lsfslew = <1>;
>   		nvidia,xcvr-lsrslew = <1>;
> +		nvidia,has-utmi-pad-registers;
>   		status = "disabled";
>   	};
>
> @@ -676,6 +679,8 @@
>   			 <&tegra_car TEGRA20_CLK_PLL_U>,
>   			 <&tegra_car TEGRA20_CLK_CDEV2>;
>   		clock-names = "reg", "pll_u", "ulpi-link";
> +		resets = <&tegra_car 58>, <&tegra_car 22>;
> +		reset-names = "usb", "utmi-pads";
>   		status = "disabled";
>   	};
>
> @@ -700,6 +705,8 @@
>   			 <&tegra_car TEGRA20_CLK_CLK_M>,
>   			 <&tegra_car TEGRA20_CLK_USBD>;
>   		clock-names = "reg", "pll_u", "timer", "utmi-pads";
> +		resets = <&tegra_car 59>, <&tegra_car 22>;
> +		reset-names = "usb", "utmi-pads";
>   		nvidia,hssync-start-delay = <9>;
>   		nvidia,idle-wait-delay = <17>;
>   		nvidia,elastic-limit = <16>;
> diff --git a/arch/arm/boot/dts/tegra30.dtsi b/arch/arm/boot/dts/tegra30.dtsi
> index 0b1ede9..6b35c29 100644
> --- a/arch/arm/boot/dts/tegra30.dtsi
> +++ b/arch/arm/boot/dts/tegra30.dtsi
> @@ -790,6 +790,8 @@
>   			 <&tegra_car TEGRA30_CLK_PLL_U>,
>   			 <&tegra_car TEGRA30_CLK_USBD>;
>   		clock-names = "reg", "pll_u", "utmi-pads";
> +		resets = <&tegra_car 22>, <&tegra_car 22>;
> +		reset-names = "usb", "utmi-pads";
>   		nvidia,hssync-start-delay = <9>;
>   		nvidia,idle-wait-delay = <17>;
>   		nvidia,elastic-limit = <16>;
> @@ -801,6 +803,7 @@
>   		nvidia,xcvr-hsslew = <32>;
>   		nvidia,hssquelch-level = <2>;
>   		nvidia,hsdiscon-level = <5>;
> +		nvidia,has-utmi-pad-registers;
>   		status = "disabled";
>   	};
>
> @@ -824,6 +827,8 @@
>   			 <&tegra_car TEGRA30_CLK_PLL_U>,
>   			 <&tegra_car TEGRA30_CLK_USBD>;
>   		clock-names = "reg", "pll_u", "utmi-pads";
> +		resets = <&tegra_car 58>, <&tegra_car 22>;
> +		reset-names = "usb", "utmi-pads";
>   		nvidia,hssync-start-delay = <9>;
>   		nvidia,idle-wait-delay = <17>;
>   		nvidia,elastic-limit = <16>;
> @@ -858,6 +863,8 @@
>   			 <&tegra_car TEGRA30_CLK_PLL_U>,
>   			 <&tegra_car TEGRA30_CLK_USBD>;
>   		clock-names = "reg", "pll_u", "utmi-pads";
> +		resets = <&tegra_car 59>, <&tegra_car 22>;
> +		reset-names = "usb", "utmi-pads";
>   		nvidia,hssync-start-delay = <0>;
>   		nvidia,idle-wait-delay = <17>;
>   		nvidia,elastic-limit = <16>;
>

-- 
nvpublic
