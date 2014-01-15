Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752484AbaAOQ41 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 11:56:27 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:40266 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751502AbaAOQ4Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 11:56:25 -0500
Date: Wed, 15 Jan 2014 08:56:23 -0800
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
Message-ID: <20140115165623.GJ14405@codeaurora.org>
References: <1389735034-21430-1-git-send-email-sboyd@codeaurora.org>
 <1389735034-21430-3-git-send-email-sboyd@codeaurora.org>
 <20140115102701.GA27314@e102568-lin.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140115102701.GA27314@e102568-lin.cambridge.arm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/15, Lorenzo Pieralisi wrote:
> On Tue, Jan 14, 2014 at 09:30:32PM +0000, Stephen Boyd wrote:
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
> >  Documentation/devicetree/bindings/arm/cpus.txt | 52 ++++++++++++++++++++++++++
> >  1 file changed, 52 insertions(+)
> > 
> > diff --git a/Documentation/devicetree/bindings/arm/cpus.txt b/Documentation/devicetree/bindings/arm/cpus.txt
> > index 91304353eea4..c332b5168456 100644
> > --- a/Documentation/devicetree/bindings/arm/cpus.txt
> > +++ b/Documentation/devicetree/bindings/arm/cpus.txt
> > @@ -191,6 +191,16 @@ nodes to be present and contain the properties described below.
> >  			  property identifying a 64-bit zero-initialised
> >  			  memory location.
> >  
> > +	- interrupts
> > +		Usage: required for cpus with compatible string "qcom,krait".
> > +		Value type: <prop-encoded-array>
> > +		Definition: L1/CPU error interrupt
> 
> I reckon you want this property to belong in the cpus node (example below),
> not in cpu nodes, right ?

Yes.

> 
> Are you relying on a platform device to be created for /cpus node in
> order for this series to work ? I guess that's why you want the
> interrupts property to be defined in /cpus so that it becomes a platform
> device resource (and you also add a compatible property in /cpus that is
> missing in these bindings).

Ah yes. I'll move this to the /cpus section.

> 
> > +
> > +	- next-level-cache
> > +		Usage: optional
> > +		Value type: <phandle>
> > +		Definition: phandle pointing to the next level cache
> > +
> >  Example 1 (dual-cluster big.LITTLE system 32-bit):
> >  
> >  	cpus {
> > @@ -382,3 +392,45 @@ cpus {
> >  		cpu-release-addr = <0 0x20000000>;
> >  	};
> >  };
> > +
> > +
> > +Example 5 (Krait 32-bit system):
> > +
> > +cpus {
> > +	#address-cells = <1>;
> > +	#size-cells = <0>;
> > +	interrupts = <1 9 0xf04>;
> 
> In patch 4 you also add a compatible property here, and that's not documented,
> and honestly I do not think that's acceptable either. I guess you want a
> compatible property here to match the platform driver, right ?

Ah sorry, I forgot to put the compatible property here like in
the dts change. I'll do that in the next revision. Yes we need a
compatible property here to match the platform driver.

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation
