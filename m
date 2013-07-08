Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752140Ab3GHLzK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jul 2013 07:55:10 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:38401 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751672Ab3GHLzI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jul 2013 07:55:08 -0400
Message-ID: <51DAA890.5090006@ti.com>
Date: Mon, 8 Jul 2013 17:24:56 +0530
From: Kishon Vijay Abraham I <kishon@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: George Cherian <george.cherian@ti.com>
CC: <linux-usb@vger.kernel.org>, <balbi@ti.com>,
        <linux-kernel@vger.kernel.org>, <gregkh@linuxfoundation.org>,
        <linux-omap@vger.kernel.org>, <bigeasy@linutronix.de>
Subject: Re: [PATCH 4/5] arm: dts: Add USB phy nodes for AM33XX
References: <1373280201-31785-1-git-send-email-george.cherian@ti.com> <1373280201-31785-5-git-send-email-george.cherian@ti.com>
In-Reply-To: <1373280201-31785-5-git-send-email-george.cherian@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Monday 08 July 2013 04:13 PM, George Cherian wrote:
> Add DT bindings of phy nodes for AM33XX platform.
>
> Signed-off-by: George Cherian <george.cherian@ti.com>
> ---
>   arch/arm/boot/dts/am33xx.dtsi | 22 ++++++++++++++++++++++
>   1 file changed, 22 insertions(+)
>
> diff --git a/arch/arm/boot/dts/am33xx.dtsi b/arch/arm/boot/dts/am33xx.dtsi
> index 8e1248f..4f3cca0 100644
> --- a/arch/arm/boot/dts/am33xx.dtsi
> +++ b/arch/arm/boot/dts/am33xx.dtsi
> @@ -326,6 +326,25 @@
>   			status = "disabled";
>   		};
>
> +		phy1: usbphy-gs70@44e10620 {

*44e10620* is not needed if you are not having the reg property.
> +			compatible = "ti,am335x-usb2";
> +			#phy-cells = <0>;
> +			id = <0>;
> +		};
> +
> +		phy2: usbphy-gs71@44e10628 {
ditto.
> +			compatible = "ti,am335x-usb2";
> +			#phy-cells = <0>;
> +			id = <1>;
> +		};
> +
> +		omap_control_usb: omap-control-usb@44e10620 {
> +			compatible = "ti,omap-control-usb";
> +			reg = <0x44e10620 0x10>;
> +			reg-names = "control_dev_conf";
> +			ti,type = <3>;
> +		};
> +
>   		usb@47400000 {
>   			compatible = "ti,musb-am33xx";
>   			reg = <0x47400000 0x1000	/* usbss */
> @@ -341,6 +360,9 @@
>   			port1-mode = <3>;
>   			power = <250>;
>   			ti,hwmods = "usb_otg_hs";
> +			phy-names = "am335x-usb0", "am335x-usb1";
> +			phys	= <&phy1>, <&phy2>;

Lets have *phys* before *phy-names*.

Thanks
Kishon
