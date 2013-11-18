Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751940Ab3KRM4Y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 07:56:24 -0500
Received: from ns.mm-sol.com ([37.157.136.199]:41218 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751734Ab3KRM4Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 07:56:16 -0500
Message-ID: <1384779277.13631.13.camel@iivanov-dev.int.mm-sol.com>
Subject: Re: [PATCH v4 10/15] usb: phy: msm: Add device tree support and
 binding information
From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
To: Mark Rutland <mark.rutland@arm.com>
Cc: "balbi@ti.com" <balbi@ti.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        Pawel Moll <Pawel.Moll@arm.com>,
        "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>,
        "davidb@codeaurora.org" <davidb@codeaurora.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Date: Mon, 18 Nov 2013 14:54:37 +0200
In-Reply-To: <20131115163818.GH24831@e106331-lin.cambridge.arm.com>
References: <1384267910-32066-1-git-send-email-iivanov@mm-sol.com>
	 <1384267910-32066-11-git-send-email-iivanov@mm-sol.com>
	 <20131115163818.GH24831@e106331-lin.cambridge.arm.com>
Content-Type: text/plain; charset="us-ascii"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark, 

On Fri, 2013-11-15 at 16:38 +0000, Mark Rutland wrote: 
> On Tue, Nov 12, 2013 at 02:51:45PM +0000, Ivan T. Ivanov wrote:
> > From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
> > 
> > Allows MSM OTG controller to be specified via device tree.
> > 
> > Signed-off-by: Ivan T. Ivanov <iivanov@mm-sol.com>
> > Cc: devicetree@vger.kernel.org
> > ---
> >  .../devicetree/bindings/usb/msm-hsusb.txt          |   57 +++++++++++++-
> >  drivers/usb/phy/phy-msm-usb.c                      |   79 +++++++++++++++++---
> >  2 files changed, 124 insertions(+), 12 deletions(-)
> > 
> > diff --git a/Documentation/devicetree/bindings/usb/msm-hsusb.txt b/Documentation/devicetree/bindings/usb/msm-hsusb.txt
> > index 0a85eba..f1045e3 100644
> > --- a/Documentation/devicetree/bindings/usb/msm-hsusb.txt
> > +++ b/Documentation/devicetree/bindings/usb/msm-hsusb.txt
> > @@ -30,4 +30,59 @@ Required properties:
> >  		dr_mode = "peripheral";
> >  		interrupts = <0 134 0>;
> >  		usb-phy = <&usb_otg>;
> > -	};
> > \ No newline at end of file
> > +	};
> > +
> > +USB PHY with optional OTG:
> > +
> > +Required properties:
> > +- compatible:	should contain "qcom,usb-otg-ci" for chipsets with
> > +				Chipidea 45nm PHY or "qcom,usb-otg-snps" for chipsets
> > +				with Synopsys 28nm PHY
> 
> To make this easier to read and extend in future, I'd reorganise this
> like so:
> 
> compatible: should contain:
>  * "qcom,usb-otg-ci" for chipsets with Chipidea 45nm PHY
>  * "qcom,usb-otg-snps" for chipsets with Synopsys 28nm PHY


Ok.

> 
> > +- regs:			offset and length of the register set in the memory map
> > +- interrupts:	interrupt-specifier for the OTG interrupt.
> > +
> > +- clocks:		A list of phandle + clock-specifier pairs for the
> > +				clocks listed in clock-names
> > +- clock-names:	Should contain the following:
> > +  "phy"			USB PHY reference clock
> > +  "core"		Protocol engine clock
> > +  "iface"		Interface bus clock
> > +  "alt_core"	Optional: Protocol engine clock for targets with asynchronous
> > +				reset methodology.
> 
> I'd rearrange that last entry:
> 
> "alt_core": Protocol engine clock for targets with asynchronous
>             reset methodology. (optional)

ok.

> 
> > +
> > +- dr_mode:		One of "host", "peripheral" or "otg". Defaults to "otg"
> 
> If this has a default and thus isn't required, it should be listed as
> optional.

This is part of the standard USB bindings, Perhaps I could just
refer to:  Documentation/devicetree/bindings/usb/generic.txt


> 
> > +
> > +- vdccx-supply:	phandle to the regulator for the vdd supply for
> > +				digital circuit operation.
> > +- v1p8-supply:	phandle to the regulator for the 1.8V supply
> > +- v3p3-supply:	phandle to the regulator for the 3.3V supply
> > +
> > +- qcom,otg-control: OTG control (VBUS and ID notifications) can be one of
> > +				1 - PHY control
> > +				2 - PMIC control
> > +				3 - User control (via debugfs)
> 
> NAK. This does not seem like a description of the hardware, and given
> the debugfs comment is fundamentally tied to the way Linux functions
> today.

I will remove option 3, but rest are really property of the chipset. 

> 
> > +
> > +Optional properties:
> > +- qcom,phy-init-sequence: PHY configuration sequence. val, reg pairs
> > +				terminate with -1
> 
> What is this? I'm really not keen on having arbitrary register/memory
> poking sequences in the dt.

This is related Device Mode Eye Diagram test and values used could be
different between chipsets.

> 
> Why does it need to be terminated? Surely the size of the property tells
> you that it's terminated.

Yes. -1 termination could be done in driver.

> 
> > +
> > +Example HSUSB OTG controller device node:
> > +
> > +	usb@f9a55000 {
> > +		compatible = "qcom,usb-otg-snps";
> > +		reg = <0xf9a55000 0x400>;
> > +		interrupts = <0 134 0>;;
> 
> s/;;/;/

thanks

> 
> > +		dr_mode = "peripheral";
> > +
> > +		clocks = <&gcc GCC_XO_CLK>, <&gcc GCC_USB_HS_SYSTEM_CLK>,
> > +				<&gcc GCC_USB_HS_AHB_CLK>;
> > +
> > +		clock-names = "phy", "core", "iface";
> > +
> > +		vddcx-supply = <&pm8841_s2_corner>;
> > +		v1p8-supply = <&pm8941_l6>;
> > +		v3p3-supply = <&pm8941_l24>;
> > +
> > +		qcom,otg-control = <1>;
> > +		qcom,phy-init-sequence = <0x01 0x90 0xffffffff>;
> 
> I believe modern dtc versions can handle negative numbers directly.
> 
> [...]
> 
> > +static int msm_otg_read_dt(struct platform_device *pdev, struct msm_otg *motg)
> > +{
> > +	struct msm_otg_platform_data *pdata;
> > +	const struct of_device_id *id;
> > +	struct device_node *node = pdev->dev.of_node;
> > +	int len = 0;
> > +	u32 val;
> > +
> > +	pdata = devm_kzalloc(&pdev->dev, sizeof(*pdata), GFP_KERNEL);
> > +	if (!pdata)
> > +		return -ENOMEM;
> > +
> > +	motg->pdata = pdata;
> > +
> > +	id = of_match_device(msm_otg_dt_match, &pdev->dev);
> > +	pdata->phy_type = (int) id->data;
> > +
> > +	pdata->mode = of_usb_get_dr_mode(node);
> > +	if (pdata->mode == USB_DR_MODE_UNKNOWN)
> > +		pdata->mode = USB_DR_MODE_OTG;
> > +
> > +	pdata->otg_control = OTG_PHY_CONTROL;
> > +	if (!of_property_read_u32(node, "qcom,otg-control", &val))
> > +		pdata->otg_control = val;
> 
> Is this validated elsewhere?

No. I will add check.

Thanks.
Ivan

> 
> Thanks,
> Mark.


