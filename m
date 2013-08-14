Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759489Ab3HNHp5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 03:45:57 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:47184 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759393Ab3HNHpz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 03:45:55 -0400
Message-ID: <520B35AD.7070607@ti.com>
Date: Wed, 14 Aug 2013 10:45:49 +0300
From: Roger Quadros <rogerq@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: <bcousson@baylibre.com>
CC: Roger Quadros <rogerq@ti.com>, <balbi@ti.com>, <tony@atomide.com>,
        <kishon@ti.com>, <george.cherian@ti.com>, <dmurphy@ti.com>,
        <linux-usb@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 7/7] ARM: dts: omap5: update omap-control-usb node
References: <1375365915-21380-1-git-send-email-rogerq@ti.com> <1375365915-21380-8-git-send-email-rogerq@ti.com>
In-Reply-To: <1375365915-21380-8-git-send-email-rogerq@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

+Benoit

On 08/01/2013 05:05 PM, Roger Quadros wrote:
> Split USB2 PHY and USB3 PHY into separate omap-control-usb
> nodes. Update ti,mode property.
> 
> CC: Benoit Cousson <benoit.cousson@linaro.org>
> Signed-off-by: Roger Quadros <rogerq@ti.com>
> ---
>  arch/arm/boot/dts/omap5.dtsi |   18 ++++++++++++------
>  1 files changed, 12 insertions(+), 6 deletions(-)
> 
> diff --git a/arch/arm/boot/dts/omap5.dtsi b/arch/arm/boot/dts/omap5.dtsi
> index 07be2cd..af8ef77 100644
> --- a/arch/arm/boot/dts/omap5.dtsi
> +++ b/arch/arm/boot/dts/omap5.dtsi
> @@ -626,14 +626,20 @@
>  			hw-caps-temp-alert;
>  		};
>  
> -		omap_control_usb: omap-control-usb@4a002300 {
> +		omap_control_usb2phy: omap-control-usb@4a002300 {
>  			compatible = "ti,omap-control-usb";
> -			reg = <0x4a002300 0x4>,
> -			      <0x4a002370 0x4>;
> -			reg-names = "control_dev_conf", "phy_power_usb";
> +			reg = <0x4a002300 0x4>;
> +			reg-names = "power";
>  			ti,type = <2>;
>  		};
>  
> +		omap_control_usb3phy: omap-control-usb@0x4a002370 {
> +			compatible = "ti,omap-control-usb";
> +			reg = <0x4a002370 0x4>;
> +			reg-names = "power";
> +			ti,type = <3>;
> +		};
> +
>  		omap_dwc3@4a020000 {
>  			compatible = "ti,dwc3";
>  			ti,hwmods = "usb_otg_ss";
> @@ -661,7 +667,7 @@
>  			usb2_phy: usb2phy@4a084000 {
>  				compatible = "ti,omap-usb2";
>  				reg = <0x4a084000 0x7c>;
> -				ctrl-module = <&omap_control_usb>;
> +				ctrl-module = <&omap_control_usb2phy>;
>  			};
>  
>  			usb3_phy: usb3phy@4a084400 {
> @@ -670,7 +676,7 @@
>  				      <0x4a084800 0x64>,
>  				      <0x4a084c00 0x40>;
>  				reg-names = "phy_rx", "phy_tx", "pll_ctrl";
> -				ctrl-module = <&omap_control_usb>;
> +				ctrl-module = <&omap_control_usb3phy>;
>  			};
>  		};
>  
> 

