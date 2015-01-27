Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932396AbbA0QbB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 11:31:01 -0500
Received: from mail-lb0-f179.google.com ([209.85.217.179]:46825 "EHLO
	mail-lb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755110AbbA0Qa6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 11:30:58 -0500
Message-ID: <54C7BD3D.4010707@cogentembedded.com>
Date: Tue, 27 Jan 2015 19:30:53 +0300
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Organization: Cogent Embedded
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Zubair Lutfullah Kakakhel <Zubair.Kakakhel@imgtec.com>,
        stern@rowland.harvard.edu
CC: gregkh@linuxfoundation.org, lars@metafoo.de, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: [PATCH 1/3] dt: usb: jz4740: Add DT binding document for OHCI
References: <1422366439-34641-1-git-send-email-Zubair.Kakakhel@imgtec.com> <1422366439-34641-2-git-send-email-Zubair.Kakakhel@imgtec.com>
In-Reply-To: <1422366439-34641-2-git-send-email-Zubair.Kakakhel@imgtec.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 01/27/2015 04:47 PM, Zubair Lutfullah Kakakhel wrote:

> From: Paul Burton <paul.burton@imgtec.com>

> Add the binding documentation for the JZ47xx OHCI controller.

> Signed-off-by: Paul Burton <paul.burton@imgtec.com>
> Signed-off-by: Zubair Lutfullah Kakakhel <Zubair.Kakakhel@imgtec.com>

> ---
> The jz4740 is platform only at the moment.

> But DT support is being added

> See http://patchwork.linux-mips.org/bundle/paulburton/ci20-v3.20/

> jz47xx is used because jz4780 will also use this driver
> ---
>   .../bindings/usb/ingenic,jz47xx-ohci.txt           | 28 ++++++++++++++++++++++
>   1 file changed, 28 insertions(+)
>   create mode 100644 Documentation/devicetree/bindings/usb/ingenic,jz47xx-ohci.txt

> diff --git a/Documentation/devicetree/bindings/usb/ingenic,jz47xx-ohci.txt b/Documentation/devicetree/bindings/usb/ingenic,jz47xx-ohci.txt
> new file mode 100644
> index 0000000..2fada8b
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/usb/ingenic,jz47xx-ohci.txt
> @@ -0,0 +1,28 @@
> +Ingenic JZ47XX SoC OHCI controller binding

    I think JZ47xx would look a bit better.

> +
> +The Ingenic JZ47XX SoC includes an OHCI compliant USB host controller
> +interface for use with USB 1.1 devices.
> +
> +Required properties:
> + - compatible: Should be "ingenic,jz4740-ohci"
> + - reg: Should contain the address & size of the OHCI controller registers.
> + - interrupt-parent: Should be the phandle of the interrupt controller that
> +   delivers interrupts to the OHCI block.

    This is never a required prop, it can be inherited from a parent node.

> + - interrupts: Should specify the interrupt provided by interrupt-parent.
> + - clocks: Should contain a single clock specifier for the SoC UHC clock.
> +
> +Example SoC include file for jz4780:
> +
> +/ {
> +	ohci: jz4780-ohci@0x134a0000 {

    The ePAPR standard says we shouldn't name the nodes after the chips used 
but use the generic names, which would be "usb" in this case. And please drop 
"0x" from the <unit-address> part of the name.

> +		compatible = "ingenic,jz4780-ohci";
> +		reg = <0x134a0000 0x10000>;
> +
> +		interrupt-parent = <&intc>;
> +		interrupts = <5>;
> +
> +		clocks = <&cgu JZ4780_CLK_UHC>;
> +		clock-names = "uhc";

    You forgot to mention this prop above.

[...]

WBR, Sergei

