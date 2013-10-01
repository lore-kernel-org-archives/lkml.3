Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752802Ab3JALse (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Oct 2013 07:48:34 -0400
Received: from ns.mm-sol.com ([212.124.72.66]:57150 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752408Ab3JALsb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Oct 2013 07:48:31 -0400
Message-ID: <1380628026.30666.7.camel@iivanov-dev.int.mm-sol.com>
Subject: Re: [PATCH v4 1/3] usb: dwc3: msm: Add device tree binding
 information
From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
To: Mark Rutland <mark.rutland@arm.com>
Cc: Felipe Balbi <balbi@ti.com>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        Pawel Moll <Pawel.Moll@arm.com>,
        "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        "ian.campbell@citrix.com" <ian.campbell@citrix.com>,
        "rob@landley.net" <rob@landley.net>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "idos@codeaurora.org" <idos@codeaurora.org>,
        "mgautam@codeaurora.org" <mgautam@codeaurora.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Date: Tue, 01 Oct 2013 14:47:06 +0300
In-Reply-To: <20130926094618.GD2411@e106331-lin.cambridge.arm.com>
References: <1376992565-22292-1-git-send-email-iivanov@mm-sol.com>
	 <1376992565-22292-2-git-send-email-iivanov@mm-sol.com>
	 <20130923193148.GN30811@radagast>
	 <20130926094618.GD2411@e106331-lin.cambridge.arm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi, I am sorry for delay answer.

On Thu, 2013-09-26 at 10:46 +0100, Mark Rutland wrote: 
> On Mon, Sep 23, 2013 at 08:31:48PM +0100, Felipe Balbi wrote:
> > Hi,
> > 
> > On Tue, Aug 20, 2013 at 12:56:03PM +0300, Ivan T. Ivanov wrote:
> > > From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
> > > 
> > > MSM USB3.0 core wrapper consist of USB3.0 IP from Synopsys
> > > (SNPS) and HS, SS PHY's control and configuration registers.
> > > 
> > > It could operate in device mode (SS, HS, FS) and host
> > > mode (SS, HS, FS, LS).
> > > 
> > > Signed-off-by: Ivan T. Ivanov <iivanov@mm-sol.com>
> > 
> > Any acks for the DT part ? This patch has been pending forever.
> 
> Apologies for the delay. I have a couple of comments that would be nice
> to fix up now.
> 
> > 
> > > ---
> > >  .../devicetree/bindings/usb/msm-ssusb.txt          |  104 ++++++++++++++++++++
> > >  1 file changed, 104 insertions(+)
> > >  create mode 100644 Documentation/devicetree/bindings/usb/msm-ssusb.txt
> > > 
> > > diff --git a/Documentation/devicetree/bindings/usb/msm-ssusb.txt b/Documentation/devicetree/bindings/usb/msm-ssusb.txt
> > > new file mode 100644
> > > index 0000000..cacbd3b
> > > --- /dev/null
> > > +++ b/Documentation/devicetree/bindings/usb/msm-ssusb.txt
> > > @@ -0,0 +1,104 @@
> > > +MSM SuperSpeed DWC3 USB SoC controller
> > > +
> > > +
> > > +DWC3 Highspeed USB PHY
> > > +======================
> > > +Required properities :
> > > +- compatible : sould be "qcom,dwc3-hsphy";
> 
> s/sould/should/
> 
> In general, compatible properties are "should contain" rather than
> "should be", as we might have backwards compatible hardware in future.

Ok.

> 
> > > +- reg : offset and length of the register set in the memory map
> > > +- clocks : phandles to clock instances of the device tree nodes
> 
> Clocks are referred to be phandle + clock-specifier pairs rather than
> phandles, it would be nice to fix the terminology here

Ok.

> 
> > > +- clock-names :
> > > +	"xo" : External reference clock 19 MHz
> > > +	"sleep_a" : Sleep clock, used when USB3 core goes into low
> > > +	power mode (U3).
> 
> I think it would be nicer to say:
> - clocks : A list of phandle + clock-specifier pairs for the clocks
>            listed in clock-names
> - clock-names: Should contain the following:
>                "xo"      - External reference clock (19MHz)
> 	       "sleep_a" - Sleep clock used when USB3 core goes into low
> 	                   power mode (U3).
> 
> I'm not sure we need to describe the frequency of the xo clock -- either
> it's a requriement of the IP and thus doesn't need to be a part of the
> binding, or it's configurable by the driver and thus doesn't need to be
> documented.

Ok. will remove explicit numbers here.

> 
> > > +<supply-name>-supply : phandle to the regulator device tree node
> > > +Required "supply-name" are:
> > > +	"v1p8" : 1.8v supply for HSPHY
> > > +	"v3p3" : 3.3v supply for HSPHY
> > > +	"vbus" : vbus supply for host mode
> > > +	"vddcx" : vdd supply for HS-PHY digital circuit operation
> 
> Any reason for the HSPHY/HS-PHY difference?

No, just lack of attention from my side.

> 
> I'd list these separately with their full names:
> 
> - v1p8-supply: phandle to the regulator for the 1.8v supply to HSPHY.
> - v3p3-supply: phandle to the regulator for the 3.3v supply to HSPHY.
> - vbus-supply: phandle to the regulator for the vbus supply for host
>                mode.
> - vddcx-supply: phandle to the regulator for the vdd supply for HSPHY
>   digital circuit operation.
> 

ok.

> > > +
> > > +DWC3 Superspeed USB PHY
> > > +=======================
> > > +Required properities :
> > > +- compatible : sould be "qcom,dwc3-ssphy";
> > > +- reg : offset and length of the register set in the memory map
> > > +- clocks : phandles to clock instances of the device tree nodes
> > > +- clock-names :
> > > +	"xo" : External reference clock 19 MHz
> > > +	"ref" : Reference clock - used in host mode.
> > > +<supply-name>-supply : phandle to the regulator device tree node
> > > +Required "supply-name" are:
> > > +	"v1p8" : 1.8v supply for SS-PHY
> > > +	"vddcx" : vdd supply for SS-PHY digital circuit operation
> 
> The commments on compatible, clocks, clock-names and the regulators
> apply here.


ok

> 
> > > +
> > > +DWC3 controller wrapper
> > > +=======================
> > > +Required properties :
> > > +- compatible : should be "qcom,dwc3"
> > > +- reg : offset and length of the register set in the memory map
> > > +	offset and length of the TCSR register for routing USB
> > > +	signals to either picoPHY0 or picoPHY1.
> > > +- clocks : phandles to clock instances of the device tree nodes
> > > +- clock-names :
> > > +	"core" : Master/Core clock, have to be >= 125 MHz for SS
> > > +	operation and >= 60MHz for HS operation
> > > +	"iface" : System bus AXI clock
> > > +	"sleep" : Sleep clock, used when USB3 core goes into low
> > > +	power mode (U3).
> > > +	"utmi" : Generated by HS-PHY. Used to clock the low power
> > > +	parts of thr HS Link layer.
> > > +Optional properties :
> > > +- gdsc-supply : phandle to the globally distributed switch controller
> > > +  regulator node to the USB controller.
> 
> The commments on compatible, clocks, and clock-names apply here too. I
> see the regulator is defined individually :)
> 
> I'm fine with the binding itself, I'd just like the documentation fixed
> up.
> 

Thanks, 
Ivan

> Cheers,
> Mark.
> 
> > > +Required child node:
> > > +A child node must exist to represent the core DWC3 IP block. The name of
> > > +the node is not important. The content of the node is defined in dwc3.txt.
> > > +
> > > +Example device nodes:
> > > +
> > > +	dwc3_hsphy: phy@f92f8800 {
> > > +		compatible = "qcom,dwc3-hsphy";
> > > +		reg = <0xf92f8800 0x30>;
> > > +
> > > +		clocks = <&cxo>, <&usb2a_phy_sleep_cxc>;
> > > +		clock-names = "xo", "sleep_a";
> > > +
> > > +		vbus-supply = <&supply>;
> > > +		vddcx-supply = <&supply>;
> > > +		v1p8-supply = <&supply>;
> > > +		v3p3-supply = <&supply>;
> > > +	};
> > > +
> > > +	dwc3_ssphy: phy@f92f8830 {
> > > +		compatible = "qcom,dwc3-ssphy";
> > > +		reg = <0xf92f8830 0x30>;
> > > +
> > > +		clocks = <&cxo>, <&usb30_mock_utmi_cxc>;
> > > +		clock-names = "xo", "ref";
> > > +
> > > +		vddcx-supply = <&supply>;
> > > +		v1p8-supply = <&supply>;
> > > +	};
> > > +
> > > +	usb@fd4ab000 {
> > > +		compatible = "qcom,dwc3";
> > > +		#address-cells = <1>;
> > > +		#size-cells = <1>;
> > > +		reg = <0xfd4ab000 0x4>;
> > > +
> > > +		clocks = <&usb30_master_cxc>, <&sys_noc_usb3_axi_cxc>,
> > > +				<&usb30_sleep_cxc>, <&usb30_mock_utmi_cxc>;
> > > +		clock-names = "core", "iface", "sleep", "utmi";
> > > +
> > > +		gdsc-supply = <&supply>;
> > > +
> > > +		ranges;
> > > +		dwc3@f9200000 {
> > > +			compatible = "snps,dwc3";
> > > +			reg = <0xf9200000 0xcd00>;
> > > +			interrupts = <0 131 0>;
> > > +			usb-phy = <&dwc3_hsphy>, <&dwc3_ssphy>;
> > > +			tx-fifo-resize;
> > > +		};
> > > +	};
> > > -- 
> > > 1.7.9.5
> > > 
> > 
> > -- 
> > balbi
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-arm-msm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


