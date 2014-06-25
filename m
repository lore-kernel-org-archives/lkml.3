Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756304AbaFYJ5k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 05:57:40 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:34844 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753542AbaFYJ5h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 05:57:37 -0400
Date: Wed, 25 Jun 2014 10:57:36 +0100
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
Message-ID: <20140625095735.GI6153@arm.com>
References: <1400877218-4113-1-git-send-email-thierry.reding@gmail.com>
 <4839521.56FtveYIl6@wuerfel>
 <20140625093825.GH6153@arm.com>
 <130361958.xFghHXmZkz@wuerfel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <130361958.xFghHXmZkz@wuerfel>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 25, 2014 at 10:48:31AM +0100, Arnd Bergmann wrote:
> On Wednesday 25 June 2014 10:38:25 Will Deacon wrote:
> > On Wed, Jun 25, 2014 at 10:27:50AM +0100, Arnd Bergmann wrote:
> > > I think the situation is a bit different here: It's less about the corner
> > > cases for the SMMU, but about the question whether it makes more sense to
> > > have the kernel figure out the settings, or have them come from DT
> > > all the time.
> > 
> > But, as far as I can tell, this setting is basically `which bits are
> > constant among this set of IDs'.
> > 
> > > As I said, I can't tell which approach is best here, but it sounds to
> > > me we should either do dynamic configuration and get it right, or
> > > hardcode the configuration it all the time if we can't.
> > 
> > I disagree. If you have `sensible' StreamID allocations, doing this
> > dynamically should be straight-forward and gives the driver more flexibility
> > (e.g. we then have the option of combining SMR entries for different masters
> > if they are in the same domain). The dynamic approach also lends itself to
> > sanity-checking (it is IMPLEMENTATION DEFINED whether the SMMU detects SMR
> > aliases) and helps with virtualisation (forcing QEMU to generate these masks
> > in a device-tree for a guest using a virtual SMMU interface is very painful).
> 
> In which case do you think hardcoding is needed then? I'm still confused
> why you think we need both, as your arguments seem to all be in favor of
> dynamic configuration.

So far, I've been avoiding the hardcoding. However, you could potentially
build a system with a small number of SMRs (compared to the number of
StreamIDs) and allocate the StreamIDs in such a way that I think the dynamic
configuration would be NP complete if we require an optimal SMR allocation.

However:

  (1) I don't know of a system where this is the case
  (2) Not much work has been done on improving the dynamic allocator yet

which is why I'm still favouring dynamic configuration in the driver.

The other thing I forgot to mention earlier is that we need to support
device hotplug in the future, so some level of dynamic configuration
will always be required.

Will
