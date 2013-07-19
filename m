Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760259Ab3GSNea (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 09:34:30 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:33656 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751195Ab3GSNe2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 09:34:28 -0400
Message-ID: <51E94059.6090900@ti.com>
Date: Fri, 19 Jul 2013 19:04:17 +0530
From: Kishon Vijay Abraham I <kishon@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: George Cherian <george.cherian@ti.com>
CC: <linux-usb@vger.kernel.org>, <balbi@ti.com>,
        <linux-kernel@vger.kernel.org>, <gregkh@linuxfoundation.org>,
        <linux-omap@vger.kernel.org>, <bigeasy@linutronix.de>
Subject: Re: [PATCH v2 3/4] arm: dts: Add USB phy nodes for AM33XX
References: <1374237277-17769-1-git-send-email-george.cherian@ti.com> <1374237277-17769-4-git-send-email-george.cherian@ti.com>
In-Reply-To: <1374237277-17769-4-git-send-email-george.cherian@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Friday 19 July 2013 06:04 PM, George Cherian wrote:
> Add phy nodes for AM33XX platform and split the musb nodes
> per instance.
> 
> Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> Signed-off-by: George Cherian <george.cherian@ti.com>
> ---
>  arch/arm/boot/dts/am33xx.dtsi | 68 +++++++++++++++++++++++++++++++++----------
>  1 file changed, 53 insertions(+), 15 deletions(-)
> 
> diff --git a/arch/arm/boot/dts/am33xx.dtsi b/arch/arm/boot/dts/am33xx.dtsi
> index 8e1248f..e3890c4 100644
> --- a/arch/arm/boot/dts/am33xx.dtsi
> +++ b/arch/arm/boot/dts/am33xx.dtsi
> @@ -326,21 +326,59 @@
>  			status = "disabled";
>  		};
>  
> -		usb@47400000 {
> -			compatible = "ti,musb-am33xx";
> -			reg = <0x47400000 0x1000	/* usbss */
> -			       0x47401000 0x800		/* musb instance 0 */
> -			       0x47401800 0x800>;	/* musb instance 1 */
> -			interrupts = <17		/* usbss */
> -				      18		/* musb instance 0 */
> -				      19>;		/* musb instance 1 */
> -			multipoint = <1>;
> -			num-eps = <16>;
> -			ram-bits = <12>;
> -			port0-mode = <3>;
> -			port1-mode = <3>;
> -			power = <250>;
> -			ti,hwmods = "usb_otg_hs";
> +		phy1: am335x-usb0@44e10620 {

*44e10620* is not needed if you are not having the reg property.
> +			compatible = "ti,am335x-usb2";
> +			#phy-cells = <0>;
> +			id= <0>;
> +		};
> +
> +		phy2: am335x-usb1@44e10628 {
> +			compatible = "ti,am335x-usb2";

ditto..
> +			#phy-cells = <0>;
> +			id= <1>;
> +		};
> +
> +		omap_control_usb: omap-control-usb@44e10620 {
> +			compatible = "ti,omap-control-usb";
> +			reg = <0x44e10620 0x10>;
> +			reg-names = "control_dev_conf";
> +			ti,type = <3>;
> +		};
> +
> +                musb: usb@47400000 {
> +                        compatible = "ti,musb-am33xx";
> +                        reg = <0x47400000 0x1000>;
> +                        ranges;
> +                        #address-cells = <1>;
> +                        #size-cells = <1>;
> +                        interrupts = <17>;
> +                        ti,hwmods = "usb_otg_hs";
> +
> +                        usb0@47401000 {
> +                                reg = <0x47401000 0x800>;
> +                                interrupts = <18>;
> +                                interrupt-names = "mc";
> +                                multipoint = <1>;
> +                                num-eps = <16>;
> +                                ram-bits = <12>;
> +                                port-mode = <3>;
> +                                power = <250>;
> +                                phys = <&phy1>;
> +				phy-names = "am335x-usb0";

Looks like alignment has gone wrong here.
> +                        };
> +
> +                        usb1@47401800 {
> +                                reg = <0x47401800 0x800>;
> +                                interrupts = <19>;
> +                                interrupt-names = "mc";
> +                                multipoint = <1>;
> +                                num-eps = <16>;
> +                                ram-bits = <12>;
> +                                port-mode = <3>;
> +                                power = <250>;
> +                                phys = <&phy2>;
> +				phy-names = "am335x-usb1";
ditto.

Thanks
Kishon
