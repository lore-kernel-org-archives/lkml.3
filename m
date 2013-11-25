Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756906Ab3KYRjP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 12:39:15 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:63456 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754880Ab3KYRjM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 12:39:12 -0500
Date: Mon, 25 Nov 2013 17:39:00 +0000
From: Will Deacon <will.deacon@arm.com>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: "grant.likely@linaro.org" <grant.likely@linaro.org>,
        Hiroshi Doyu <hdoyu@nvidia.com>,
        "swarren@nvidia.com" <swarren@nvidia.com>,
        "thierry.reding@gmail.com" <thierry.reding@gmail.com>,
        "galak@codeaurora.org" <galak@codeaurora.org>,
        Mark Rutland <Mark.Rutland@arm.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        dave.martin@arm.com
Subject: Re: [PATCHv5 2/9] driver/core: populate devices in order for IOMMUs
Message-ID: <20131125173900.GB28201@mudshark.cambridge.arm.com>
References: <1384853593-32202-1-git-send-email-hdoyu@nvidia.com>
 <1384853593-32202-3-git-send-email-hdoyu@nvidia.com>
 <20131121131558.E5B82C40A2C@trevor.secretlab.ca>
 <528E5932.1070105@wwwdotorg.org>
 <20131122074111.155E2C40753@trevor.secretlab.ca>
 <528F95FE.7080406@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <528F95FE.7080406@wwwdotorg.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 22, 2013 at 05:35:58PM +0000, Stephen Warren wrote:
> On 11/22/2013 12:41 AM, Grant Likely wrote:
> > It seems more that IOMMU attachment is closer to being a property of the
> > bus rather than a property of the device itself. In that context it
> > would make more sense for the bus device to hold off child device
> > registration or probing until the IOMMU is available. That keeps the
> > logic out of both the core code and the individual device drivers.
> 
> The bus structure that DT and Linux know about is the register bus.
> There's no reason that devices have to emit their master transactions
> onto that same bus, or onto only that same bus.

Agreed. Dave (CC'd) and I actually had a lot of discussion around the DT bus
abstractions last week and we ended up with a binding that looked sane enough
to start a meaningful discussion in this area.

Dave -- care to post what we came up with? It certainly has a bunch of
overlap with the IOMMU problems being discussed here.

Will
