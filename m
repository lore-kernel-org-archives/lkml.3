Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751497AbaAPSFL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 13:05:11 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:47105 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751004AbaAPSFH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 13:05:07 -0500
Date: Thu, 16 Jan 2014 10:05:05 -0800
From: Stephen Boyd <sboyd@codeaurora.org>
To: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Cc: Borislav Petkov <bp@alien8.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>,
        Mark Rutland <Mark.Rutland@arm.com>, Kumar Gala <galak@codeaurora.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [PATCH v5 2/4] devicetree: bindings: Document Krait CPU/L1 EDAC
Message-ID: <20140116180505.GA30925@codeaurora.org>
References: <1389735034-21430-1-git-send-email-sboyd@codeaurora.org>
 <1389735034-21430-3-git-send-email-sboyd@codeaurora.org>
 <20140115102701.GA27314@e102568-lin.cambridge.arm.com>
 <20140115165623.GJ14405@codeaurora.org>
 <20140116013840.GA674@codeaurora.org>
 <20140116113332.GC25540@e102568-lin.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140116113332.GC25540@e102568-lin.cambridge.arm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/16, Lorenzo Pieralisi wrote:
> On Thu, Jan 16, 2014 at 01:38:40AM +0000, Stephen Boyd wrote:
> > On 01/15, Stephen Boyd wrote:
> > > 
> > > Ah sorry, I forgot to put the compatible property here like in
> > > the dts change. I'll do that in the next revision. Yes we need a
> > > compatible property here to match the platform driver.
> > > 
> > 
> > This is the replacement patch
> > 
> > -----8<------
> > From: Stephen Boyd <sboyd@codeaurora.org>
> > Subject: [PATCH v9] devicetree: bindings: Document Krait CPU/L1 EDAC
> > 
> > The Krait CPU/L1 error reporting device is made up a per-CPU
> > interrupt. While we're here, document the next-level-cache
> > property that's used by the Krait EDAC driver.
> > 
> > Cc: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
> > Cc: Mark Rutland <mark.rutland@arm.com>
> > Cc: Kumar Gala <galak@codeaurora.org>
> > Cc: <devicetree@vger.kernel.org>
> > Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
> > ---
> >  Documentation/devicetree/bindings/arm/cpus.txt | 58 ++++++++++++++++++++++++++
> >  1 file changed, 58 insertions(+)
> > 
> > diff --git a/Documentation/devicetree/bindings/arm/cpus.txt b/Documentation/devicetree/bindings/arm/cpus.txt
> > index 91304353eea4..03a529e791c4 100644
> > --- a/Documentation/devicetree/bindings/arm/cpus.txt
> > +++ b/Documentation/devicetree/bindings/arm/cpus.txt
> > @@ -62,6 +62,20 @@ nodes to be present and contain the properties described below.
> >  		Value type: <u32>
> >  		Definition: must be set to 0
> >  
> > +	- compatible
> > +		Usage: optional
> > +		Value type: <string>
> > +		Definition: should be one of the compatible strings listed
> > +			    in the cpu node compatible property. This property
> > +			    shall only be present if all the cpu nodes have the
> > +			    same compatible property.
> 
> Do we really want to do that ? I am not sure. A cpus node is supposed to
> be a container node, we should not define this binding just because we
> know the kernel creates a platform device for it then.

This is just copying more of the ePAPR spec into this document.
It just so happens that having a compatible field here allows a
platform device to be created. I don't see why that's a problem.

> 
> interrupts is a cpu node property and I think it should be kept as such.
> 
> I know it will be duplicated and I know you can't rely on a platform
> device for probing (since if I am not mistaken, removing a compatible
> string from cpus prevents its platform device creation), but that's an issue
> related to how the kernel works, you should not define DT bindings to solve
> that IMHO.

The interrupts property is also common for all cpus so it seems
fine to collapse the value down into a PPI specifier indicating
that all CPUs get the interrupt, similar to how we compress the
information about the compatible string.

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation
