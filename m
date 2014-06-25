Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755843AbaFYKOQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 06:14:16 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:35299 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755666AbaFYKOL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 06:14:11 -0400
Date: Wed, 25 Jun 2014 11:14:09 +0100
From: Will Deacon <will.deacon@arm.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Olav Haugan <ohaugan@codeaurora.org>, Rob Herring <robherring2@gmail.com>,
        Mark Rutland <Mark.Rutland@arm.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        Pawel Moll <Pawel.Moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Grant Grundler <grundler@chromium.org>, Joerg Roedel <joro@8bytes.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Marc Zyngier <Marc.Zyngier@arm.com>,
        Linux IOMMU <iommu@lists.linux-foundation.org>,
        Rob Herring <robh+dt@kernel.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Kumar Gala <galak@codeaurora.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        Cho KyongHo <pullip.cho@samsung.com>,
        Dave P Martin <Dave.Martin@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Hiroshi Doyu <hdoyu@nvidia.com>
Subject: Re: [PATCH v2] devicetree: Add generic IOMMU device tree bindings
Message-ID: <20140625101409.GJ6153@arm.com>
References: <1400877218-4113-1-git-send-email-thierry.reding@gmail.com>
 <130361958.xFghHXmZkz@wuerfel>
 <20140625095735.GI6153@arm.com>
 <6589024.32Qh7fFhXo@wuerfel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6589024.32Qh7fFhXo@wuerfel>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 25, 2014 at 11:12:13AM +0100, Arnd Bergmann wrote:
> On Wednesday 25 June 2014 10:57:36 Will Deacon wrote:
> > So far, I've been avoiding the hardcoding. However, you could potentially
> > build a system with a small number of SMRs (compared to the number of
> > StreamIDs) and allocate the StreamIDs in such a way that I think the dynamic
> > configuration would be NP complete if we require an optimal SMR allocation.
> > 
> > However:
> > 
> >   (1) I don't know of a system where this is the case
> >   (2) Not much work has been done on improving the dynamic allocator yet
> > 
> > which is why I'm still favouring dynamic configuration in the driver.
> > 
> > The other thing I forgot to mention earlier is that we need to support
> > device hotplug in the future, so some level of dynamic configuration
> > will always be required.
> 
> Ok, got it. So we just hope that we can make dynamic configuration
> work all the time, but if it all fails, then we come up with a
> hardcoded configuration method.
> 
> I guess this could be done similarly to how we handle clocks on
> a lot of systems: generally these are dynamic, but you have the
> option to provide hints in the clock controller node about how
> you expect things to be configured.
> 
> For the SMMU that could mean that (if we get into the situation you
> describe), we add optional properties to the SMMU node itself
> describing how we expect the SMRs to be used.

That sounds good to me! Thanks for the discussion.

Will
