Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754344AbaIVPgg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 11:36:36 -0400
Received: from cantor2.suse.de ([195.135.220.15]:39698 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753973AbaIVPgd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 11:36:33 -0400
Date: Mon, 22 Sep 2014 17:36:28 +0200
From: Joerg Roedel <jroedel@suse.de>
To: Will Deacon <will.deacon@arm.com>
Cc: Joerg Roedel <joro@8bytes.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [PATCH 04/13 v2] iommu/arm-smmu: Convert to iommu_capable() API
 function function
Message-ID: <20140922153628.GA10438@suse.de>
References: <1409914384-21191-1-git-send-email-joro@8bytes.org>
 <1409914384-21191-5-git-send-email-joro@8bytes.org>
 <20140908165136.GW26030@arm.com>
 <20140917085312.GE2533@suse.de>
 <20140919164220.GI20773@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140919164220.GI20773@arm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Will,

On Fri, Sep 19, 2014 at 05:42:20PM +0100, Will Deacon wrote:
> However, I thought about this a bit more and the coherency isn't necessarily
> a global property of the SMMU. In reality, it is dependent on the IOTLBs in
> use by the domain, so it's not going to be possible to report true here in
> many cases.
> 
> That means we'd need a way to say `this device is dma coherent when its
> downstream IOMMU is enabled with IOMMU_CACHE mappings'. For the moment,
> people will probably just add `dma-coherent' to the endpoint and dma-mapping
> will request IOMMU_CACHE mappings regardless of the features advertised by
> the IOMMU. In that case, it might make more sense to return `true' here as
> we can always generated cacheable transactions from the SMMU. The
> dma-coherent property on the device would then indicate whether those
> transactions will snoop the CPU caches.

Okay, when the SMMU can always generate cachable transactions it is
surely fine to return true here. I'll change that before I add the
patches to my tree.


	Joerg

