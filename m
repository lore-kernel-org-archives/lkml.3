Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754258AbaEON0h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 09:26:37 -0400
Received: from mail-la0-f47.google.com ([209.85.215.47]:45992 "EHLO
	mail-la0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752700AbaEON0f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 09:26:35 -0400
Message-ID: <5374C08C.7040700@cogentembedded.com>
Date: Thu, 15 May 2014 17:26:36 +0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Organization: Cogent Embedded
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Gregory CLEMENT <gregory.clement@free-electrons.com>,
        Mathias Nyman <mathias.nyman@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Felipe Balbi <balbi@ti.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jason Cooper <jason@lakedaemon.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
CC: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org, Lior Amsalem <alior@marvell.com>,
        Tawfik Bayouk <tawfik@marvell.com>, Nadav Haklai <nadavh@marvell.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org
Subject: Re: [PATCH v6 17/17] ARM: mvebu: add Device Tree description of the
 EHCI controller on Armada 375
References: <1400149062-32661-1-git-send-email-gregory.clement@free-electrons.com> <1400149062-32661-18-git-send-email-gregory.clement@free-electrons.com>
In-Reply-To: <1400149062-32661-18-git-send-email-gregory.clement@free-electrons.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 05/15/2014 02:17 PM, Gregory CLEMENT wrote:

> The Marvell Armada 375 SoCs contains one EHCI controller. This commit

    However, you're adding two. :-)

> adds the Device Tree description of this interfaces at the SoC level,
> and also enables the USB2 port on the Armada 375 DB platform.

> Signed-off-by: Gregory CLEMENT <gregory.clement@free-electrons.com>
> Signed-off-by: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
> ---
>   arch/arm/boot/dts/armada-375-db.dts |  4 ++++
>   arch/arm/boot/dts/armada-375.dtsi   | 16 ++++++++++++++++
>   2 files changed, 20 insertions(+)

[...]

> diff --git a/arch/arm/boot/dts/armada-375.dtsi b/arch/arm/boot/dts/armada-375.dtsi
> index 7b303ecc2490..53baeb2f1fe8 100644
> --- a/arch/arm/boot/dts/armada-375.dtsi
> +++ b/arch/arm/boot/dts/armada-375.dtsi
> @@ -320,6 +320,22 @@
>   				clocks = <&coreclk 0>;
>   			};
>
> +			usb@50000 {
> +				compatible = "marvell,orion-ehci";
> +				reg = <0x50000 0x500>;
> +				interrupts = <GIC_SPI 17 IRQ_TYPE_LEVEL_HIGH>;
> +				clocks = <&gateclk 18>;
> +				status = "disabled";
> +			};
> +
> +			usb@54000 {
> +				compatible = "marvell,orion-ehci";
> +				reg = <0x54000 0x500>;
> +				interrupts = <GIC_SPI 18 IRQ_TYPE_LEVEL_HIGH>;
> +				clocks = <&gateclk 26>;
> +				status = "disabled";
> +			};
> +
>   			usb3@58000 {
>   				compatible = "marvell,armada-375-xhci";
>   				reg = <0x58000 0x20000>,<0x5b880 0x80>;
>

WBR, Sergei

