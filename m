Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755565Ab3LEKmE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 05:42:04 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:40945 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751025Ab3LEKmB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 05:42:01 -0500
Date: Thu, 5 Dec 2013 10:41:50 +0000
From: Mark Rutland <mark.rutland@arm.com>
To: "Ivan T. Ivanov" <iivanov@mm-sol.com>
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
Subject: Re: [PATCH v4 10/15] usb: phy: msm: Add device tree support and
 binding information
Message-ID: <20131205104150.GJ29200@e106331-lin.cambridge.arm.com>
References: <1384267910-32066-1-git-send-email-iivanov@mm-sol.com>
 <1384267910-32066-11-git-send-email-iivanov@mm-sol.com>
 <20131115163818.GH24831@e106331-lin.cambridge.arm.com>
 <1384779277.13631.13.camel@iivanov-dev.int.mm-sol.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1384779277.13631.13.camel@iivanov-dev.int.mm-sol.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 18, 2013 at 12:54:37PM +0000, Ivan T. Ivanov wrote:
> Hi Mark, 
> 
> On Fri, 2013-11-15 at 16:38 +0000, Mark Rutland wrote: 
> > On Tue, Nov 12, 2013 at 02:51:45PM +0000, Ivan T. Ivanov wrote:
> > > From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
> > > 
> > > Allows MSM OTG controller to be specified via device tree.
> > > 
> > > Signed-off-by: Ivan T. Ivanov <iivanov@mm-sol.com>
> > > Cc: devicetree@vger.kernel.org
> > > ---
> > >  .../devicetree/bindings/usb/msm-hsusb.txt          |   57 +++++++++++++-
> > >  drivers/usb/phy/phy-msm-usb.c                      |   79 +++++++++++++++++---
> > >  2 files changed, 124 insertions(+), 12 deletions(-)

[...]

> > > +
> > > +- dr_mode:		One of "host", "peripheral" or "otg". Defaults to "otg"
> > 
> > If this has a default and thus isn't required, it should be listed as
> > optional.
> 
> This is part of the standard USB bindings, Perhaps I could just
> refer to:  Documentation/devicetree/bindings/usb/generic.txt

That would be fine, but it should also be moved to the optional
properties section.

> 
> 
> > 
> > > +
> > > +- vdccx-supply:	phandle to the regulator for the vdd supply for
> > > +				digital circuit operation.
> > > +- v1p8-supply:	phandle to the regulator for the 1.8V supply
> > > +- v3p3-supply:	phandle to the regulator for the 3.3V supply
> > > +
> > > +- qcom,otg-control: OTG control (VBUS and ID notifications) can be one of
> > > +				1 - PHY control
> > > +				2 - PMIC control
> > > +				3 - User control (via debugfs)
> > 
> > NAK. This does not seem like a description of the hardware, and given
> > the debugfs comment is fundamentally tied to the way Linux functions
> > today.
> 
> I will remove option 3, but rest are really property of the chipset. 

Can you elaborate on the diffence please?

> 
> > 
> > > +
> > > +Optional properties:
> > > +- qcom,phy-init-sequence: PHY configuration sequence. val, reg pairs
> > > +				terminate with -1
> > 
> > What is this? I'm really not keen on having arbitrary register/memory
> > poking sequences in the dt.
> 
> This is related Device Mode Eye Diagram test and values used could be
> different between chipsets.

Ok. Then we should encode the tuning data rather than adding a mechanism
to allow for writes to arbitrary addresses.

> 
> > 
> > Why does it need to be terminated? Surely the size of the property tells
> > you that it's terminated.
> 
> Yes. -1 termination could be done in driver.

Please do. There's no need for it to be in the DT.

Cheers,
Mark.
