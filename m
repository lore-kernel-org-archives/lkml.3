Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932347AbaGaJWv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 05:22:51 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:55059 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932262AbaGaJWs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 05:22:48 -0400
Date: Thu, 31 Jul 2014 10:22:41 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Thierry Reding <thierry.reding@gmail.com>
Cc: Rob Herring <robh+dt@kernel.org>, Pawel Moll <Pawel.Moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Stephen Warren <swarren@wwwdotorg.org>, Arnd Bergmann <arnd@arndb.de>,
        Will Deacon <Will.Deacon@arm.com>, Joerg Roedel <joro@8bytes.org>,
        Cho KyongHo <pullip.cho@samsung.com>,
        Grant Grundler <grundler@chromium.org>,
        Dave P Martin <Dave.Martin@arm.com>,
        Marc Zyngier <Marc.Zyngier@arm.com>, Hiroshi Doyu <hdoyu@nvidia.com>,
        Olav Haugan <ohaugan@codeaurora.org>,
        Varun Sethi <varun.sethi@freescale.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4] devicetree: Add generic IOMMU device tree bindings
Message-ID: <20140731092241.GA21850@leverpostej>
References: <1404487757-18829-1-git-send-email-thierry.reding@gmail.com>
 <20140730152646.GC20162@leverpostej>
 <20140731083923.GA31218@ulmo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140731083923.GA31218@ulmo>
Thread-Topic: [PATCH v4] devicetree: Add generic IOMMU device tree bindings
Accept-Language: en-GB, en-US
Content-Language: en-US
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[...]

> > > +Examples:
> > > +=========
> > > +
> > > +Single-master IOMMU:
> > > +--------------------
> > > +
> > > +	iommu {
> > > +		#iommu-cells = <0>;
> > > +	};
> > > +
> > > +	master {
> > > +		iommus = <&/iommu>;
> > 
> > Nit: this should be iommus = <&{/iommu}>, or it's not valid dts syntax.
> 
> Done.

Cheers. I take it that was done for the other occurrences too?

> 
> > > +	};
> > > +
> > > +Multiple-master IOMMU with fixed associations:
> > > +----------------------------------------------
> > > +
> > > +	/* multiple-master IOMMU */
> > > +	iommu {
> > > +		/*
> > > +		 * Masters are statically associated with this IOMMU and
> > > +		 * address translation is always enabled.
> > > +		 */
> > > +		#iommu-cells = <0>;
> > 
> > I don't follow why translation being always enabled is relevant to the
> > example; that would seem to be independent from the binding.
> > 
> > Surely the key point is that with no way to distinguish devices, they
> > presumably share the same translations?
> 
> Both aspects are important I think. For #iommu-cells = <0> there is no
> way for the IOMMU driver to know how to enable translation for a given
> device. So it must be either always on or always off.

Sure. But "always on or off" is not the same as "always enabled", which
was what confused me.

> I guess one could say that this is implicit if all masters share the
> same translations. And I guess translations don't always have to be on
> or off technically. Let me try to rephrase this:
> 
> 		/*
> 		 * Masters are statically associated with this IOMMU and share
> 		 * the same address translations because the IOMMU does not
> 		 * have sufficient information to distinguish between masters.
> 		 *
> 		 * Consequently address translation is always on or off for
> 		 * all masters at any given point in time.
> 		 */
> 
> Does that sound better?

That addresses my concern, so yes.

Given these are minor and everyone wants this in now, I'm happy for
these to go through in a fixup patch later.

Cheers,
Mark.
