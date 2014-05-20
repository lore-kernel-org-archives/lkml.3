Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752851AbaETKFT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 06:05:19 -0400
Received: from mout.kundenserver.de ([212.227.126.187]:57641 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750858AbaETKFQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 06:05:16 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Thierry Reding <thierry.reding@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, devicetree@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org,
        Stephen Warren <swarren@wwwdotorg.org>,
        Grant Grundler <grundler@chromium.org>, Joerg Roedel <joro@8bytes.org>,
        Will Deacon <will.deacon@arm.com>, linux-kernel@vger.kernel.org,
        Marc Zyngier <marc.zyngier@arm.com>, iommu@lists.linux-foundation.org,
        linux-tegra@vger.kernel.org, Cho KyongHo <pullip.cho@samsung.com>,
        Dave Martin <Dave.Martin@arm.com>
Subject: Re: [PATCH] devicetree: Add generic IOMMU device tree bindings
Date: Tue, 20 May 2014 12:04:54 +0200
Message-ID: <5759340.gycj7cP1t3@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20140519205945.GE30737@mithrandir>
References: <1400242998-437-1-git-send-email-thierry.reding@gmail.com> <14622654.QO8kH1AoTT@wuerfel> <20140519205945.GE30737@mithrandir>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:Wiq+iC/oM3L8Lc0n62mWwq53UQ/I7yxpZmNQJHB2SnV
 f2n1CCmmcWVecAh6clTYnzYbh40uQ8ILZpyd1ur9knrG4nzOCI
 Ybk/OHqJtcLAy4rn630TMhxMAfnUGW8eiLmtwe93+Rq4mapSyf
 uax9OehD1E/z53LDsskQTredHU48/hcklVUcqxo8E9D39kEpDL
 QudBgJpZylV12Xh15wa/jR+SWHLKpVZBAdWZJT0a6ezs0J8fUR
 FRAWtoup8B6TPONPYul3cH3Q/qs2bT6bTVwZyhwZr9AjYb99eg
 gs2p1yM6S5wiQbWihGNXN/vyQyrZ5A0an7BHcxa5HTVM6zr8cj
 qVBE1O8aC6sq7XfdeV8w=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 19 May 2014 22:59:46 Thierry Reding wrote:
> On Mon, May 19, 2014 at 08:34:07PM +0200, Arnd Bergmann wrote:
> > On Monday 19 May 2014 14:53:37 Thierry Reding wrote:
> > > On Mon, May 19, 2014 at 12:26:35PM +0200, Arnd Bergmann wrote:
> > > > On Friday 16 May 2014 14:23:18 Thierry Reding wrote:
> > > > > From: Thierry Reding <treding@nvidia.com>
> > > > > 
> > > > > This commit introduces a generic device tree binding for IOMMU devices.
> > > > > Only a very minimal subset is described here, but it is enough to cover
> > > > > the requirements of both the Exynos System MMU and Tegra SMMU as
> > > > > discussed here:
> > > > > 
> > > > >     https://lkml.org/lkml/2014/4/27/346
> > > > > 
> > > > > More advanced functionality such as the dma-ranges property can easily
> > > > > be added in a backwards-compatible way. In the absence of a dma-ranges
> > > > > property it should be safe to default to the whole address space.
> > > > > 
> > > > 
> > > > The basic binding looks fine, but I'd like it to be more explicit
> > > > about dma-ranges. Most importantly, what does "the whole address space"
> > > > mean?
> > > 
> > > The whole point was to leave out any mention of dma-ranges from the
> > > binding until we've figured out more of the puzzle.
> > > 
> > > So what I was trying to avoid was another lengthy discussion on the
> > > topic of dma-ranges. Oh well... =)
> > 
> > I think that can't work, because we need a way to specify the
> > ranges for some iommu drivers. We have to make sure we at least
> > don't prevent it from working.
> 
> That was precisely why I wanted to let this out of the binding for now
> so that we can actually focus on making existing hardware work rather
> than speculate about what we may or may not need.
> 
> If you think the current minimal binding will cause future use-cases to
> break, then we should change it to avoid that. What you're proposing is
> to make the binding more complex on the assumption that we'll get it
> right.
> 
> Wouldn't it be safer to keep things to the bare minimum necessary to
> represent hardware that we have access to and understand now, rather
> than speculating about what may be necessary at some point. I'd much
> prefer to add complexity on an as-needed basis and when we have a better
> understand of where we're headed.

I just want to think it through for the cases we know about. We don't
have to implement it all at once, but I think there is a danger in making
an important binding too simple or too complicated, both of which are
equally bad.

After giving the ranges stuff some more thought, I have come to the
conclusion that using #iommu-cells should work fine for almost
all cases, including windowed iommus, because the window is not
actually needed in the device, but only in the iommu, wihch is of course
free to interpret the arguments as addresses.
 
> > > > Finally, it makes no sense to use the dma-ranges property of the master's
> > > > parent bus, because that bus isn't actually involved in the translation.
> > > 
> > > My understanding here is mostly based on the OpenFirmware working group
> > > proposal for the dma-ranges property[0]. I'll give another example to
> > > try and clarify how I had imagined this to work:
> > > 
> > > 	/ {
> > > 		#address-cells = <2>;
> > > 		#size-cells = <2>;
> > > 
> > > 		iommu {
> > > 			/*
> > > 			 * This is somewhat unusual (or maybe not) in that we
> > > 			 * need 2 cells to represent the size of an address
> > > 			 * space that is 32 bits long.
> > > 			 */
> > > 			#address-cells = <1>;
> > > 			#size-cells = <2>;
> > 
> > You should never need #size-cells > #address-cells
> 
> That was always my impression as well. But how then do you represent the
> full 4 GiB address space in a 32-bit system? It starts at 0 and ends at
> 4 GiB - 1, which makes it 4 GiB large. That's:
> 
> 	<0 1 0>
> 
> With #address-cells = <1> and #size-cells = <1> the best you can do is:
> 
> 	<0 0xffffffff>
> 
> but that's not accurate.

I think we've done both in the past, either extended #size-cells or
taken 0xffffffff as a special token. Note that in your example,
the iommu actually needs #address-cells = <2> anyway.

> > > 			#iommu-cells = <1>;
> > > 		};
> > > 
> > > 		master {
> > > 			iommus = <&/iommu 42>;
> > > 			/*
> > > 			 * Map I/O addresses 0 - 4 GiB to physical addresses
> > > 			 * 2 GiB - 6 GiB.
> > > 			 */
> > > 			dma-ranges = <0x00000000 0 0x80000000 1 0>;
> > > 		};
> > > 	};
> > > 
> > > This is somewhat incompatible with [0] in that #address-cells used to
> > > parse the child address must be taken from the iommu node rather than
> > > the child node. But that seems to me to be the only reasonable thing
> > > to do, because after all the IOMMU creates a completely new address
> > > space for the master.
> > > 
> > > [0]: http://www.openfirmware.org/ofwg/proposals/Closed/Accepted/410-it.txt
> > 
> > I don't think you can have a dma-ranges without a #address-cells and
> > #size-cells property in the same node. In your example, I'd also expect
> > a child node below 'master' that then interprets the address space
> > made up by dma-ranges.
> 
> Okay, so what Dave and you have been saying strongly indicates that
> dma-ranges isn't the right thing to use here.

There are cases where I think we could use dma-ranges, but not in the
way you have it above. I'll get to that below.

> > As a comment on the numbers in your example, I don't expect to ever
> > see a 4GB IOMMU address space that doesn't start at an offset. Instead
> > I'd expect either addresses that encode a device ID, or those that
> > are just a subset of the parent address space, with non-overlapping
> > bus addresses for each master.
> 
> As I understand the Tegra SMMU allows each of the clients to be assigned
> a separate address space (4 GiB on earlier generations and 16 GiB on new
> generations) and all addresses in each address space can be mapped to
> arbitrary physical addresses.

Right, so this is not a windowed IOMMU, and you wouldn't need to encode
the address at all.

> > > > My preferred option would be to always put the address range into
> > > > the iommu descriptor, using the iommu's #address-cells.
> > > 
> > > That could become impossible to parse. I'm not sure if such hardware
> > > actually exists, but if for some reason we have to split the address
> > > range into two, then there's no longer any way to determine the size
> > > needed for the specifier.
> > > 
> > > On the other hand what you propose makes it easy to represent multiple
> > > master interfaces on a device. With a separate dma-ranges property how
> > > can you define which ranges apply to which of the master interfaces?
> > 
> > Well, you could have multiple links to the same IOMMU if you want to 
> > do that, and define that there must be at least one dma-ranges entry
> > for each IOMMU entry (although not necessarily the other way round,
> > you could have direct ranges in addition to translated ones.
> > 
> > > Then again if address ranges can't be broken up in the first place, then
> > > dma-ranges could be considered to be one entry per IOMMU in the iommus
> > > property.
> > 
> > Let me do another example, with the address merged into the iommu
> > references:
> > 
> > / {
> > 	#address-cells = <2>; // 64-bit address
> > 	#size-cells = <2>;
> > 
> > 	iommu@a {
> > 		#address-cells = <2>; // 1 cell ID, 1 cell address
> > 		#size-cells = <1>;
> > 
> > 		// no need for #iommu-cells
> > 	};
> > 
> > 
> > 	master@b {
> > 		iommus = <&/iommu@a // iommu
> > 			0x23  	     // ID
> > 			0x40000000   // window start
> > 			0x10000000>; //window size
> > 	};
> > };
> > 
> > A disadvantage of this model would be that for all ARM SMMU users, we'd
> > have to always list a 4GB address space, which is kind of redundant.
> 
> Isn't that the equivalent of the "whole address space" default that I
> mentioned in the commit message? Could this be handled with
> #address-cells = <1> and #size-cells = <0> in the iommu node? That way
> the only cell that needs to be specified in iommus would be the ID and
> the redundant address space could be simply omitted from DT since it
> would be implied by the compatible string.

Yes, that's right. After giving it some more thought, I agree that the
#size-cells case makes sense as an indicator for cases where the master
doesn't have to care about the address at all and no further translation
with dma-ranges is possible.

Back to my example with dma-ranges, the simplest case would an IOMMU
that has an ID per bus, with multiple masters sharing that ID:

/ {
	#address-cells = <1>;
	#size-cells = <1>;

	iommu {
		#address-cells = <2>; // ID, address
		#size-cells = <2>;
	};

	master@a {
		iommus = <& {/iommu} 0xa 0x0  0x1 0x0>; // 4GB ID '0xa'
	}

	bus1 {
		#address-cells = <1>;
		#size-cells = <1>;
		ranges;
		iommus = <& {/iommu} 0 0   0x100 0>; // all IDs
		dma-ranges = <0  0xb 0  1 0>; // child devices use ID '0xb'

		anothermaster {
			// no iommus link, implied by dma-ranges above
		};
	};
};

If you set #size-cells=<0>, you can't really do that but instead would
require an iommus property in each master, which is not a big concern
either.

The main advantage I think would be for IOMMUs that use the PCI b/d/f
numbers as IDs. These can have #address-cells=<3>, #size-cells=<2>
and have an empty dma-ranges property in the PCI host bridge node,
and interpret this as using the same encoding as the PCI BARs in
the ranges property.

	Arnd
