Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753467AbaFDN4E (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 09:56:04 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:50926 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752800AbaFDN4B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 09:56:01 -0400
Date: Wed, 4 Jun 2014 14:56:01 +0100
From: Will Deacon <will.deacon@arm.com>
To: Thierry Reding <thierry.reding@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Hiroshi Doyu <hdoyu@nvidia.com>,
        Rob Herring <robherring2@gmail.com>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <Pawel.Moll@arm.com>, Mark Rutland <Mark.Rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Cho KyongHo <pullip.cho@samsung.com>,
        Grant Grundler <grundler@chromium.org>,
        Dave P Martin <Dave.Martin@arm.com>,
        Marc Zyngier <Marc.Zyngier@arm.com>, Joerg Roedel <joro@8bytes.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Linux IOMMU <iommu@lists.linux-foundation.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] devicetree: Add generic IOMMU device tree bindings
Message-ID: <20140604135600.GD6644@arm.com>
References: <1400877218-4113-1-git-send-email-thierry.reding@gmail.com>
 <4545972.cM7IP1qTXQ@wuerfel>
 <87tx87rrp2.fsf@nvidia.com>
 <4462924.8iRbdkOPp7@wuerfel>
 <20140604134400.GE28484@ulmo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140604134400.GE28484@ulmo>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 04, 2014 at 02:44:03PM +0100, Thierry Reding wrote:
> On Fri, May 30, 2014 at 09:54:37PM +0200, Arnd Bergmann wrote:
> > On Friday 30 May 2014 22:29:13 Hiroshi Doyu wrote:
> > > The disadvantage of this is that this limits the max number of streamIDs
> > > to support. If # of streamID is increased later more than 64, this
> > > format cannot cover any more. You have to predict the max # of streamIDs
> > > in advance if steamID is statically assigned.
> > > 
> > 
> > Well, the iommu specific binding could allow a variable #address-cells.
> > That way, you just need to know the number of stream IDs for that instance
> > of the iommu.
> 
> That sounds fairly complicated to me. I don't see what that buys us over
> the clarity and simplicity that the above explicit notation gives us. Is
> it not more common for a device to have a single master rather than a
> whole bunch of them?

I've never seen a device upstream of an ARM SMMU with a single stream-id;
they always seem to have a whole bunch of them. Calxeda's SATA controller
had 10 IDs, for example, and a PL330 DMA controller tends to have at least
3.

Will
