Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753103Ab3HBPCw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 11:02:52 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:60469 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752420Ab3HBPCt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 11:02:49 -0400
Message-ID: <51FBCA10.9070806@ti.com>
Date: Fri, 2 Aug 2013 20:32:40 +0530
From: George Cherian <george.cherian@ti.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Roger Quadros <rogerq@ti.com>
CC: <tony@atomide.com>, <rnayak@ti.com>, <benoit.cousson@linaro.org>,
        <balbi@ti.com>, <kishon@ti.com>, <dmurphy@ti.com>, <t-kristo@ti.com>,
        <linux-omap@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/4] ARM: dts: dra7: Add USB related nodes
References: <1375369134-26398-1-git-send-email-rogerq@ti.com> <1375369134-26398-3-git-send-email-rogerq@ti.com>
In-Reply-To: <1375369134-26398-3-git-send-email-rogerq@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/1/2013 8:28 PM, Roger Quadros wrote:
> Add nodes for the Super Speed USB controllers, omap-control-usb,
> USB2 PHY and USB3 PHY devices.
>
> Signed-off-by: Roger Quadros <rogerq@ti.com>
> ---
>   arch/arm/boot/dts/dra7.dtsi |  136 +++++++++++++++++++++++++++++++++++++++++++
>   1 files changed, 136 insertions(+), 0 deletions(-)
>
> diff --git a/arch/arm/boot/dts/dra7.dtsi b/arch/arm/boot/dts/dra7.dtsi
> index ce9a0f0..3a2e55e 100644

<snip>

> +		omap_dwc3_1@48880000 {

How about usb1: omap_dwc3@48880000 {
           usb2: omap_dwc3@488c0000 { etc.

> +			compatible = "ti,dwc3";
> +			ti,hwmods = "usb_otg_ss1";
> +			reg = <0x48880000 0x10000>;
> +			interrupts = <0 77 4>;
> +			#address-cells = <1>;
> +			#size-cells = <1>;
> +			utmi-mode = <2>;
> +			ranges;
> +			dwc3_1: dwc3@48890000 {
> +				compatible = "synopsys,dwc3";
> +				reg = <0x48890000 0x17000>;
> +				interrupts = <0 76 4>;
> +				usb-phy = <&usb2_phy1>, <&usb3_phy1>;
> +				tx-fifo-resize;
> +				maximum-speed = "super-speed";
> +				dr_mode = "otg";
> +			};
> +		};
> +
> +		omap_dwc3_2@488c0000 {
> +			compatible = "ti,dwc3";
> +			ti,hwmods = "usb_otg_ss2";
> +			reg = <0x488c0000 0x10000>;
> +			interrupts = <0 92 4>;
> +			#address-cells = <1>;
> +			#size-cells = <1>;
> +			utmi-mode = <2>;
> +			ranges;
> +			dwc3_2: dwc3@488d0000 {
> +				compatible = "synopsys,dwc3";
> +				reg = <0x488d0000 0x17000>;
> +				interrupts = <0 78 4>;
> +				usb-phy = <&usb2_phy2>;
> +				tx-fifo-resize;
> +				maximum-speed = "high-speed";
> +				dr_mode = "otg";
> +			};
> +		};
> +
> +		/* IRQ for DWC3_3 and DWC3_4 need IRQ crossbar */
> +		omap_dwc3_3@48900000 {
> +			compatible = "ti,dwc3";
> +			ti,hwmods = "usb_otg_ss3";
> +			reg = <0x48900000 0x10000>;
> +		/*	interrupts = <0 TBD 4>; */
> +			#address-cells = <1>;
> +			#size-cells = <1>;
> +			utmi-mode = <2>;
> +			ranges;
> +			dwc3_3: dwc3@48910000 {
> +				compatible = "synopsys,dwc3";
> +				reg = <0x48910000 0x17000>;
> +		/*		interrupts = <0 93 4>; */
> +				tx-fifo-resize;
> +				maximum-speed = "high-speed";
> +				dr_mode = "otg";
> +			};
> +		};
> +
> +		omap_dwc3_4@48940000 {
> +			compatible = "ti,dwc3";
> +			ti,hwmods = "usb_otg_ss4";
> +			reg = <0x48940000 0x10000>;
> +		/*	interrupts = <0 TBD 4>; */
> +			#address-cells = <1>;
> +			#size-cells = <1>;
> +			utmi-mode = <2>;
> +			ranges;
> +			dwc3_4: dwc3@48950000 {
> +				compatible = "synopsys,dwc3";
> +				reg = <0x48950000 0x17000>;
> +		/*		interrupts = <0 TBD 4>; */
> +				tx-fifo-resize;
> +				maximum-speed = "high-speed";
> +				dr_mode = "otg";
> +			};
> +		};
> +
>   	};
>   
>   	clocks {


-- 
-George

