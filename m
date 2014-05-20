Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751864AbaETKJc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 06:09:32 -0400
Received: from mout.kundenserver.de ([212.227.17.10]:57002 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750808AbaETKJa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 06:09:30 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Thierry Reding <thierry.reding@gmail.com>
Cc: Dave Martin <Dave.Martin@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <Pawel.Moll@arm.com>,
        Mark Rutland <Mark.Rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Grant Grundler <grundler@chromium.org>, Joerg Roedel <joro@8bytes.org>,
        Will Deacon <Will.Deacon@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Marc Zyngier <Marc.Zyngier@arm.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        Cho KyongHo <pullip.cho@samsung.com>
Subject: Re: [PATCH] devicetree: Add generic IOMMU device tree bindings
Date: Tue, 20 May 2014 12:08:44 +0200
Message-ID: <5080348.QmhgfQRxZW@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20140519203232.GD30737@mithrandir>
References: <1400242998-437-1-git-send-email-thierry.reding@gmail.com> <20140519172113.GA13858@e103592.cambridge.arm.com> <20140519203232.GD30737@mithrandir>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:q4dZuctjBNW5MGRKka2ZDkDKlyCTvGH5+BTy/HNA4a3
 C+f+PTM8i8ckQ8GRlAfREzLYl1OfqeMFW5qdBdRB8AjLlpkALp
 uN3V4jinX4t9Crj6FhvBwgv43eGf5On2fYaIiq2qqA0Vl+t/a9
 fzxacLKrJGFjCLMzPvczaWlnWk8AReZ0S3ZpxmgsCUKCpF4doQ
 J/yOkVMVP9SE+A5RvyYIfp0kO694eWchleDxczLxblWQKwwAyq
 /XVI6SXSkxgcPC4Yjk6Dz1r7U78UDfnqIdTzDqAis3UoHdmgVO
 k1ZEweY9Lf2wn0UW9E26jt6yiD2ABJN7n+TAUf4jKdD0ZkN8P4
 oB1e/gBl2gZpMoRs7Pio=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 19 May 2014 22:32:33 Thierry Reding wrote:
> On Mon, May 19, 2014 at 06:22:31PM +0100, Dave Martin wrote:
> > On Mon, May 19, 2014 at 01:53:37PM +0100, Thierry Reding wrote:
> [...]
> > > My understanding here is mostly based on the OpenFirmware working group
> > > proposal for the dma-ranges property[0]. I'll give another example to
> > > try and clarify how I had imagined this to work:
> > > 
> > >     / {
> > >             #address-cells = <2>;
> > >             #size-cells = <2>;
> > > 
> > >             iommu {
> > >                     /*
> > >                      * This is somewhat unusual (or maybe not) in that we
> > >                      * need 2 cells to represent the size of an address
> > >                      * space that is 32 bits long.
> > >                      */
> > >                     #address-cells = <1>;
> > >                     #size-cells = <2>;
> > > 
> > >                     #iommu-cells = <1>;
> > >             };
> > > 
> > >             master {
> > >                     iommus = <&/iommu 42>;
> > 
> > Comparing this with the other discussion thread, we have a similar
> > concept here, in that the iommu is made a logical parent, however...
> > 
> > Firstly, there's an implicit assumption here that the only kind of
> > thing the master could possibly be connected to is an IOMMU, with
> > no non-trivial interconnect in between.  I'm not sure this is going
> > to scale to complex SoCs.
> 
> Here we go again. We're now in the very same bad spot that we've been in
> so many times before. There are at least two SoCs that we know do not
> require anything fancy, yet we're blocking adding support for those use
> cases because we think that at some point some IOMMU may require more
> than that. But at the same time it seems like we don't have enough data
> about what exactly that is, so we keep speculating. At this rate we're
> making it impossible to get a reasonable feature set supported upstream.
> 
> That's very frustrating.

I agree. While I just commented that I want to think through how this
would look for other IOMMUs, the generic case of all masters that Dave
wants is going overboard with the complexity and we'd be better off
deferring this to whenever someone needs it, which I assume is never.

> > If a range of Stream IDs may be issued (especially from something like
> > a PCIe RC where the stream ID may be a many-bit value), describing
> > the IDs individually may be impractical.
> 
> The IOMMU specifier is completely specific to the IOMMU. If an IOMMU has
> a need to represent the stream IDs as a range there's nothing keeping it
> from defining the specifier accordingly.

If we make the IOMMU address space look like the PCI address space, we
can have a simple representation for this in DT. For the code, I assume
that we will always have to treat PCI and platform devices differently.

	Arnd
