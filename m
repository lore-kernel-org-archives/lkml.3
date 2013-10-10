Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757469Ab3JJSQI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 14:16:08 -0400
Received: from alvesta.synopsys.com ([198.182.60.77]:45073 "EHLO
	alvesta.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756577Ab3JJSQF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 14:16:05 -0400
From: Paul Zimmerman <Paul.Zimmerman@synopsys.com>
To: "balbi@ti.com" <balbi@ti.com>, Matt Porter <matt.porter@linaro.org>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@nvidia.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Christian Daudt <bcm@fixthebug.org>,
        "Linux USB List" <linux-usb@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Devicetree List <devicetree@vger.kernel.org>,
        Linaro Patches <patches@linaro.org>
Subject: RE: [PATCH 2/5] usb: gadget: s3c-hsotg: support configurable UTMI
 PHY width
Thread-Topic: [PATCH 2/5] usb: gadget: s3c-hsotg: support configurable UTMI
 PHY width
Thread-Index: AQHOw0XFmqXky787GEa2SFluyDmi85nuicoAgAAX1QCAAA5vAP//i7qwgAB6KID//4un0A==
Date: Thu, 10 Oct 2013 18:14:19 +0000
Message-ID: <A2CA0424C0A6F04399FB9E1CD98E030458E168E8@US01WEMBX2.internal.synopsys.com>
References: <1381140752-312-1-git-send-email-matt.porter@linaro.org>
 <1381140752-312-3-git-send-email-matt.porter@linaro.org>
 <20131010152922.GF28375@radagast> <5256DBD0.8030008@linaro.org>
 <20131010174620.GC19802@radagast>
 <A2CA0424C0A6F04399FB9E1CD98E030458E16893@US01WEMBX2.internal.synopsys.com>
 <20131010180723.GF19802@radagast>
In-Reply-To: <20131010180723.GF19802@radagast>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.9.64.241]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Felipe Balbi [mailto:balbi@ti.com]
> Sent: Thursday, October 10, 2013 11:07 AM
> 
> On Thu, Oct 10, 2013 at 05:57:54PM +0000, Paul Zimmerman wrote:
> > > From: Felipe Balbi [mailto:balbi@ti.com]
> > > Sent: Thursday, October 10, 2013 10:46 AM
> > >
> > > On Thu, Oct 10, 2013 at 12:54:40PM -0400, Matt Porter wrote:
> > > > On 10/10/2013 11:29 AM, Felipe Balbi wrote:
> > > > >On Mon, Oct 07, 2013 at 06:12:29AM -0400, Matt Porter wrote:
> > > > >>Extend dwc2 binding with an optional utmi phy width property.
> > > > >>Enable the s3c-hsotg.c driver to use standard dwc2 binding
> > > > >>and enable configuration of the UTMI phy width based on the
> > > > >>property.
> > > > >>
> > > > >>Signed-off-by: Matt Porter <matt.porter@linaro.org>
> > > > >>Reviewed-by: Markus Mayer <markus.mayer@linaro.org>
> > > > >>Reviewed-by: Tim Kryger <tim.kryger@linaro.org>
> > > > >>---
> > > > >>  Documentation/devicetree/bindings/staging/dwc2.txt |  4 ++++
> > > > >>  drivers/usb/gadget/s3c-hsotg.c                     | 18 +++++++++++++++++-
> > > > >>  drivers/usb/gadget/s3c-hsotg.h                     |  1 +
> > > > >>  3 files changed, 22 insertions(+), 1 deletion(-)
> > > > >>
> > > > >>diff --git a/Documentation/devicetree/bindings/staging/dwc2.txt
> > > b/Documentation/devicetree/bindings/staging/dwc2.txt
> > > > >>index 1a1b7cf..fb6b8ee 100644
> > > > >>--- a/Documentation/devicetree/bindings/staging/dwc2.txt
> > > > >>+++ b/Documentation/devicetree/bindings/staging/dwc2.txt
> > > > >>@@ -6,10 +6,14 @@ Required properties:
> > > > >>  - reg : Should contain 1 register range (address and length)
> > > > >>  - interrupts : Should contain 1 interrupt
> > > > >>
> > > > >>+Optional properties:
> > > > >>+- snps,phy-utmi-width: Must contain the UTMI data width (either 8 or 16)
> > > > >
> > > > >isn't this available in any of the configuration registers ?
> > > >
> > > > Yes and no. HWCFG4 has a UTMI data width field. However, it has 3
> > > > valid states, "8", "16", or "8 or 16". The BCM281xx implementation is
> > > > set to the latter and the attached phy is 8-bit.
> > > >
> > > > Looking at dwc2 prior to Matthijs Kooijman's patch [1] which starts
> > > > validating the value of phy_utmi_width in that driver, the pci.c
> > > > dwc2_module_params .phy_utmi_width field there even had the comment,
> > > > "/* 16 bits - NOT DETECTABLE */". The autodetect code in
> > > > dwc2_set_param_phy_utmi_width() will fail if HWCFG4 has the "8 or 16"
> > > > option as it just decides to default to a phy width of 16 if nothing
> > > > is configured by the platform glue. This property would also allow
> > > > this issue to be addressed in that driver.
> > >
> > > fair enough, but I'd really like to hear from DT folks if your suggested
> > > binding is acceptable. It seems like we can equally argue that it's a SW
> > > configuration or HW description.
> >
> > It's definitely a HW description - the width of the UTMI data connection.
> 
> right, but that description should be passed to the PHY, right ? DWC2
> works with both widths (8 or 16).

I don't know what you mean by "passed to the PHY". The data width is the
number of physical wires connecting the PHY to the DWC2 controller. If
that value can be read from the PHY, fine. Otherwise, I think a DT
binding is the way to go.

-- 
Paul

