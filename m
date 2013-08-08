Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934175Ab3HHJQX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 05:16:23 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:59772 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751336Ab3HHJQU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 05:16:20 -0400
Date: Thu, 8 Aug 2013 10:16:16 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: "Ivan T. Ivanov" <iivanov@mm-sol.com>
Cc: "balbi@ti.com" <balbi@ti.com>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        Pawel Moll <Pawel.Moll@arm.com>,
        "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        "ian.campbell@citrix.com" <ian.campbell@citrix.com>,
        "rob@landley.net" <rob@landley.net>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>
Subject: Re: [RFC 1/2] usb: phy: Add Qualcomm SS-USB and HS-USB drivers for
 DWC3 core
Message-ID: <20130808091616.GE14648@e106331-lin.cambridge.arm.com>
References: <1375789991-30041-1-git-send-email-iivanov@mm-sol.com>
 <1375789991-30041-2-git-send-email-iivanov@mm-sol.com>
 <20130806140301.GE25383@e106331-lin.cambridge.arm.com>
 <1375799793.2027.30.camel@iivanov-dev.int.mm-sol.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1375799793.2027.30.camel@iivanov-dev.int.mm-sol.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 06, 2013 at 03:36:33PM +0100, Ivan T. Ivanov wrote:
> Hi,
> 
> On Tue, 2013-08-06 at 15:03 +0100, Mark Rutland wrote:
> > On Tue, Aug 06, 2013 at 12:53:10PM +0100, Ivan T. Ivanov wrote:
> > > From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
> > >
> > > Signed-off-by: Ivan T. Ivanov <iivanov@mm-sol.com>
> > > ---
> > >  .../devicetree/bindings/usb/msm-ssusb.txt          |   49 +++
> > >  drivers/usb/phy/Kconfig                            |   11 +
> > >  drivers/usb/phy/Makefile                           |    2 +
> > >  drivers/usb/phy/phy-msm-dwc3-usb2.c                |  342 +++++++++++++++++
> > >  drivers/usb/phy/phy-msm-dwc3-usb3.c                |  389 ++++++++++++++++++++
> > >  5 files changed, 793 insertions(+)
> > >  create mode 100644 Documentation/devicetree/bindings/usb/msm-ssusb.txt
> > >  create mode 100644 drivers/usb/phy/phy-msm-dwc3-usb2.c
> > >  create mode 100644 drivers/usb/phy/phy-msm-dwc3-usb3.c
> > >
> > > diff --git a/Documentation/devicetree/bindings/usb/msm-ssusb.txt b/Documentation/devicetree/bindings/usb/msm-ssusb.txt
> > > new file mode 100644
> > > index 0000000..550b496
> > > --- /dev/null
> > > +++ b/Documentation/devicetree/bindings/usb/msm-ssusb.txt
> > > @@ -0,0 +1,49 @@
> > > +MSM SuperSpeed USB3.0 SoC controllers
> > > +
> > > +Required properities :
> > > +- compatible sould be "qcom,dwc3-usb2";
> > > +- reg : offset and length of the register set in the memory map
> > > +- clocks: <&cxo>, <&usb2a_phy_sleep_cxc>;
> > 
> > Huh? That doesn't describe what these are. These would be better
> > explained with a reference to clock-names and a basic description as to
> > what the input's called, what it drives, etc, as you've done done for
> > the *-supply properties.
> 
> Ok, I will fix this.
> 
> > 
> > > +- clock-names: "xo", "sleep_a_clk";
> > > +<supply-name>-supply: phandle to the regulator device tree node
> > > +Required "supply-name" examples are:
> > > +       "v1p8" : 1.8v supply for HSPHY
> > > +       "v3p3" : 3.3v supply for HSPHY
> > > +       "vbus" : vbus supply for host mode
> > > +       "vddcx" : vdd supply for HS-PHY digital circuit operation
> > > +
> > > +Required properities :
> > > +- compatible sould be "qcom,dwc3-usb3";
> > > +- reg : offset and length of the register set in the memory map
> > > +- clocks: <&cxo>, <&usb30_mock_utmi_cxc>;
> > 
> > Similarly, this doesn't describe what the clocks are.
> 
> Understood.
> 
> > 
> > > +- clock-names: "xo", "ref_clk";
> > > +<supply-name>-supply: phandle to the regulator device tree node
> > > +Required "supply-name" examples are:
> > > +       "v1p8" : 1.8v supply for SS-PHY
> > > +       "vddcx" : vdd supply for SS-PHY digital circuit operation
> > > +
> > > +Example device nodes:
> > > +
> > > +       dwc3_usb2: phy@f92f8800 {
> > > +               compatible = "qcom,dwc3-usb2";
> > > +               reg = <0xf92f8800 0x30>;
> > > +
> > > +               clocks = <&cxo>, <&usb2a_phy_sleep_cxc>;
> > > +               clock-names = "xo", "sleep_a_clk";
> > > +
> > > +               vbus-supply = <&supply>;
> > > +               vddcx-supply = <&supply>;
> > > +               v1p8-supply = <&supply>;
> > > +               v3p3-supply = <&supply>;
> > > +       };
> > > +
> > > +       dwc3_usb3: phy@f92f8830 {
> > > +               compatible = "qcom,dwc3-usb3";
> > > +               reg = <0xf92f8830 0x30>;
> > > +
> > > +               clocks = <&cxo>, <&usb30_mock_utmi_cxc>;
> > > +               clock-names = "xo", "ref_clk";
> > > +
> > > +               vddcx-supply = <&supply>;
> > > +               v1p8-supply = <&supply>;
> > > +       };
> > 
> > 
> > Those regster banks look suspiciously close. Are these the same IP
> > block? Can they ever appear separately?
> > 
> 
> They are part of the wrapper Qualcomm logic around Synopsys USB3 core.
> In this sense they are part of the one IP, I believe. Manage them from
> separate drivers simplify code.

Hmmm. I'm not entirely certain on this. On the one hand, they're
separate IP blocks, and have lgoically separate drivers, so describing
them as two devices makes sense. On the other hand, they've been fused
into one IP block with shared resources. Describing them as two devices
probably makes sense given you have the wrapper driver.

> 
> > Do the drivers not trample each other when messing with shared clocks
> > and regulators?
> > 
> 
> Regulators and clocks have reference counting, right?, so this should
> be safe. Even if they are part of the one driver, clocks and regulators
> could be switched off only if both PHY's do not use them.

Ok, I just wanted to be sure this had been considered :)

Thanks,
Mark.
