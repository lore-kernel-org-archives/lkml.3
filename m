Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755616Ab3KAWwr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 18:52:47 -0400
Received: from mail-ie0-f180.google.com ([209.85.223.180]:35774 "EHLO
	mail-ie0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755408Ab3KAWwn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 18:52:43 -0400
Date: Fri, 1 Nov 2013 18:52:36 -0400
From: Matt Porter <matt.porter@linaro.org>
To: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Cc: Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>, Kumar Gala <galak@codeaurora.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Christian Daudt <bcm@fixthebug.org>,
        Paul Zimmerman <paulz@synopsys.com>,
        Linux USB List <linux-usb@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Devicetree List <devicetree@vger.kernel.org>,
        Linaro Patches <patches@linaro.org>
Subject: Re: [PATCH v2 9/9] ARM: dts: add usb udc support to bcm281xx
Message-ID: <20131101225236.GB17505@beef>
References: <1383335158-19730-1-git-send-email-matt.porter@linaro.org>
 <1383335158-19730-10-git-send-email-matt.porter@linaro.org>
 <52741581.9020106@cogentembedded.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52741581.9020106@cogentembedded.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 01, 2013 at 11:56:33PM +0300, Sergei Shtylyov wrote:
> Hello.
> 
> On 11/01/2013 10:45 PM, Matt Porter wrote:
> 
> >Adds USB OTG/PHY and clock support to BCM281xx and enables
> >UDC support on the bcm11351-brt and bcm28155-ap boards.
> 
> >Signed-off-by: Matt Porter <matt.porter@linaro.org>
> >Reviewed-by: Markus Mayer <markus.mayer@linaro.org>
> >Reviewed-by: Tim Kryger <tim.kryger@linaro.org>
> >---
> >  arch/arm/boot/dts/bcm11351-brt.dts |  6 ++++++
> >  arch/arm/boot/dts/bcm11351.dtsi    | 18 ++++++++++++++++++
> >  arch/arm/boot/dts/bcm28155-ap.dts  |  8 ++++++++
> >  3 files changed, 32 insertions(+)
> 
> [...]
> >diff --git a/arch/arm/boot/dts/bcm11351.dtsi b/arch/arm/boot/dts/bcm11351.dtsi
> >index 0755f43..247f9fd 100644
> >--- a/arch/arm/boot/dts/bcm11351.dtsi
> >+++ b/arch/arm/boot/dts/bcm11351.dtsi
> >@@ -284,4 +284,22 @@
> >  			#clock-cells = <0>;
> >  		};
> >  	};
> >+
> >+	usbotg: usbotg@3f120000 {
> 
>    According to ePAPR spec [1], the node name should be "usb@3f120000".

Will address in v3.

> >+		compatible = "snps,dwc2";
> >+		reg = <0x3f120000 0x10000>;
> >+		interrupts = <GIC_SPI 47 IRQ_TYPE_LEVEL_HIGH>;
> >+		clocks = <&usb_otg_ahb_clk>;
> >+		clock-names = "otg";
> >+		phys = <&usbphy>;
> >+		phy-names = "usb2-phy";
> >+		status = "disabled";
> >+	};
> >+
> >+	usbphy: usbphy@3f130000 {
> 
>    This one should probably be named "usb-phy@3f130000", just like
> "ethernet-phy" from the ePAPR spec.

Yes, agreed that will follow the same naming convention. I'll roll this
in v3. Thanks for the review.

-Matt

> >+		compatible = "brcm,kona-usb2-phy";
> >+		reg = <0x3f130000 0x28>;
> >+		#phy-cells = <0>;
> >+		status = "disabled";
> >+	};
> >  };
> 
> [1] http://www.power.org/resources/downloads/Power_ePAPR_APPROVED_v1.0.pdf
> 
> WBR, Sergei
> 
