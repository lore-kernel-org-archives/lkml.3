Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755594Ab3HFOmr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Aug 2013 10:42:47 -0400
Received: from ns.mm-sol.com ([212.124.72.66]:39943 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754182Ab3HFOmp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Aug 2013 10:42:45 -0400
Message-ID: <1375800096.2027.35.camel@iivanov-dev.int.mm-sol.com>
Subject: Re: [RFC 2/2] usb: dwc3: Add Qualcomm DWC3 glue layer driver
From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
To: Mark Rutland <mark.rutland@arm.com>
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
Date: Tue, 06 Aug 2013 17:41:36 +0300
In-Reply-To: <20130806140710.GF25383@e106331-lin.cambridge.arm.com>
References: <1375789991-30041-1-git-send-email-iivanov@mm-sol.com>
	 <1375789991-30041-3-git-send-email-iivanov@mm-sol.com>
	 <20130806140710.GF25383@e106331-lin.cambridge.arm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi, 

On Tue, 2013-08-06 at 15:07 +0100, Mark Rutland wrote:
> On Tue, Aug 06, 2013 at 12:53:11PM +0100, Ivan T. Ivanov wrote:
> > From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
> 
> What does the "glue layer" do? Is it an actual piece of hardware, or
> just some platform-specific code?
> 

It is hardware layer around Synopsys DesignWare USB3 core. The 
term 'glue layer' is what is used in TI OMAP's and Samsung Exynos
drivers implementations.

> > 
> > Signed-off-by: Ivan T. Ivanov <iivanov@mm-sol.com>
> > ---
> >  .../devicetree/bindings/usb/msm-ssusb.txt          |   39 +++++
> >  drivers/usb/dwc3/Kconfig                           |    8 +
> >  drivers/usb/dwc3/Makefile                          |    1 +
> >  drivers/usb/dwc3/dwc3-msm.c                        |  175 ++++++++++++++++++++
> >  4 files changed, 223 insertions(+)
> >  create mode 100644 drivers/usb/dwc3/dwc3-msm.c
> > 
> > diff --git a/Documentation/devicetree/bindings/usb/msm-ssusb.txt b/Documentation/devicetree/bindings/usb/msm-ssusb.txt
> > index 550b496..313ae0d 100644
> > --- a/Documentation/devicetree/bindings/usb/msm-ssusb.txt
> > +++ b/Documentation/devicetree/bindings/usb/msm-ssusb.txt
> > @@ -22,6 +22,23 @@ Required "supply-name" examples are:
> >  	"v1p8" : 1.8v supply for SS-PHY
> >  	"vddcx" : vdd supply for SS-PHY digital circuit operation
> >  
> > +Required properties :
> > +- compatible : should be "qcom,dwc-usb3-msm"
> > +- reg : offset and length of the register set in the memory map
> > +	offset and length of the TCSR register for routing USB
> > +	signals to either picoPHY0 or picoPHY1.
> > +- clocks = <&usb30_master_cxc>, <&sys_noc_usb3_axi_cxc>, <&usb30_sleep_cxc>, <&usb30_mock_utmi_cxc>;
> 
> Similarly to my comment on patch 1, these need to be described better.

Sure, will fix this.

Thanks, 
Ivan

> 
> Thanks,
> Mark.


