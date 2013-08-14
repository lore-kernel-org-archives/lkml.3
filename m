Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759480Ab3HNHpc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 03:45:32 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:44094 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759393Ab3HNHpa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 03:45:30 -0400
Message-ID: <520B3593.3020408@ti.com>
Date: Wed, 14 Aug 2013 10:45:23 +0300
From: Roger Quadros <rogerq@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: <bcousson@baylibre.com>
CC: Roger Quadros <rogerq@ti.com>, <balbi@ti.com>, <tony@atomide.com>,
        <kishon@ti.com>, <george.cherian@ti.com>, <dmurphy@ti.com>,
        <linux-usb@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 6/7] ARM: dts: omap4: update omap-control-usb nodes
References: <1375365915-21380-1-git-send-email-rogerq@ti.com> <1375365915-21380-7-git-send-email-rogerq@ti.com>
In-Reply-To: <1375365915-21380-7-git-send-email-rogerq@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

+Benoit

On 08/01/2013 05:05 PM, Roger Quadros wrote:
> Split otghs_ctrl and USB2 PHY power down into separate
> omap-control-usb nodes. Update ti,mode property.
> 
> CC: Benoit Cousson <benoit.cousson@linaro.org>
> Signed-off-by: Roger Quadros <rogerq@ti.com>
> ---
>  arch/arm/boot/dts/omap4.dtsi |   17 ++++++++++++-----
>  1 files changed, 12 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/arm/boot/dts/omap4.dtsi b/arch/arm/boot/dts/omap4.dtsi
> index 22d9f2b..9a6fa27 100644
> --- a/arch/arm/boot/dts/omap4.dtsi
> +++ b/arch/arm/boot/dts/omap4.dtsi
> @@ -519,7 +519,7 @@
>  			usb2_phy: usb2phy@4a0ad080 {
>  				compatible = "ti,omap-usb2";
>  				reg = <0x4a0ad080 0x58>;
> -				ctrl-module = <&omap_control_usb>;
> +				ctrl-module = <&omap_control_usb2phy>;
>  			};
>  		};
>  
> @@ -643,11 +643,17 @@
>  			};
>  		};
>  
> -		omap_control_usb: omap-control-usb@4a002300 {
> +		omap_control_usb2phy: omap-control-usb@4a002300 {
>  			compatible = "ti,omap-control-usb";
> -			reg = <0x4a002300 0x4>,
> -			      <0x4a00233c 0x4>;
> -			reg-names = "control_dev_conf", "otghs_control";
> +			reg = <0x4a002300 0x4>;
> +			reg-names = "power";
> +			ti,type = <2>;
> +		};
> +
> +		omap_control_usbotg: omap-control-usb@4a00233c {
> +			compatible = "ti,omap-control-usb";
> +			reg = <0x4a00233c 0x4>;
> +			reg-names = "otghs_control";
>  			ti,type = <1>;
>  		};
>  
> @@ -662,6 +668,7 @@
>  			num-eps = <16>;
>  			ram-bits = <12>;
>  			ti,has-mailbox;
> +			ctrl-module = <&omap_control_usbotg>;
>  		};
>  	};
>  };
> 

