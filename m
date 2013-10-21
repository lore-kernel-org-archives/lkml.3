Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755980Ab3JUJ2L (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Oct 2013 05:28:11 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:55970 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754071Ab3JUJ2E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Oct 2013 05:28:04 -0400
Message-ID: <5264F37E.9060307@ti.com>
Date: Mon, 21 Oct 2013 14:57:26 +0530
From: Kishon Vijay Abraham I <kishon@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Matt Porter <matt.porter@linaro.org>
CC: Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@nvidia.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Paul Zimmerman <paulz@synopsys.com>,
        Devicetree List <devicetree@vger.kernel.org>,
        Linux USB List <linux-usb@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] Does PHY UTMI data width belong to DWC2 or PHY binding?
References: <20131018141221.GH2721@beef>
In-Reply-To: <20131018141221.GH2721@beef>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 18 October 2013 07:42 PM, Matt Porter wrote:
> This is a summary of an unresolved issue resulting from this thread:
> http://www.spinics.net/lists/arm-kernel/msg277700.html
> 
> The BCM281xx family of SoCs contain an OTG subsystem consisting of a
> DWC2 HSOTG controller and an internal UTMI PHY. This is appears as
> follows (monospace font requirement ahead):
> 
> +----------------+              +-----------------+
> |                |              |                 |
> |                |       8      |                 |
> |      DWC2      |<------/----->|     BCM Kona    |
> |                |     UTMI     |     UTMI PHY    |
> |                |              |                 |
> +----------------+              +-----------------+
> 
> The internal UTMI phy is connected via an 8-bit data path. There is
> no way to autodetect whether the data path is 8-bit or 16-bit. As such,
> it was determined that a DT property is necessary to reflect this.
> 
> In the original patch submitted this property was offered as an
> additional optional dwc2 property:
> 
> --- a/Documentation/devicetree/bindings/staging/dwc2.txt
> +++ b/Documentation/devicetree/bindings/staging/dwc2.txt
> @@ -6,10 +6,14 @@ Required properties:
>  - reg : Should contain 1 register range (address and length)
>  - interrupts : Should contain 1 interrupt
> 
> +Optional properties:
> +- snps,phy-utmi-width: Must contain the UTMI data width (either 8 or 16)
> +
>  Example:
> 
>          usb@101c0000 {
>                  compatible = "ralink,rt3050-usb, snps,dwc2";
>                  reg = <0x101c0000 40000>;
>                  interrupts = <18>;
> +		snps,phy-utmi-width = <8>;
>          };
> 
> The open question is whether this required hardware property belongs to
> the DWC2 controller or the PHY itself.

I think it makes sense to keep the data width property in the dwc2 node itself.
I mean it describes how the dwc2 IP is configured in that particular SoC (given
that it can be either <8> or <16>).

Thanks
Kishon

> 
> If the UTMI data path width is considered to be a property of the PHY
> then this will impact both the generic PHY framework and the PHY device
> node (producer) binding. The binding would need to be extended to carry
> the data path width property. In addition, the generic PHY framework
> would need to allow for this information to be gathered in some manner
> for use by the controller driver (PHY consumer). In the case of DWC2,
> the driver needs to know whether to program the phy interface for 8 or
> 16 bit UTMI communication.
> 
> Thanks,
> Matt
> --
> To unsubscribe from this list: send the line "unsubscribe linux-usb" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

