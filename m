Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754365Ab3KUNjX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 08:39:23 -0500
Received: from hqemgate14.nvidia.com ([216.228.121.143]:16198 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752807Ab3KUNjU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 08:39:20 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Thu, 21 Nov 2013 05:37:15 -0800
Date: Thu, 21 Nov 2013 15:38:45 +0200
From: Hiroshi Doyu <hdoyu@nvidia.com>
To: "will.deacon@arm.com" <will.deacon@arm.com>,
        Grant Likely <grant.likely@linaro.org>
CC: Stephen Warren <swarren@wwwdotorg.org>,
        Stephen Warren <swarren@nvidia.com>,
        "thierry.reding@gmail.com" <thierry.reding@gmail.com>,
        "galak@codeaurora.org" <galak@codeaurora.org>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "lorenzo.pieralisi@arm.com" <lorenzo.pieralisi@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHv5 4/9] iommu/tegra: smmu: register device to iommu
 dynamically
Message-ID: <20131121153845.e37c01b2f384883e3611790a@nvidia.com>
In-Reply-To: <20131121132322.EFDD1C40A2C@trevor.secretlab.ca>
References: <1384853593-32202-1-git-send-email-hdoyu@nvidia.com>
	<1384853593-32202-5-git-send-email-hdoyu@nvidia.com>	<528BDAAA.4000203@
 wwwdotorg.org>	<20131121132322.EFDD1C40A2C@trevor.secretlab.ca>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 21 Nov 2013 14:23:22 +0100
Grant Likely <grant.likely@linaro.org> wrote:

> > > +static int smmu_iommu_add_device(struct device *dev)
> > > +{
> > > +	int err = -EPROBE_DEFER;
> > > +	u32 swgroups = dev->platform_data;
> > > +	struct dma_iommu_mapping *map = NULL;
> > > +
> > > +	if (test_bit(TEGRA_SWGROUP_PPCS, swgroups))
> > > +		map = smmu_handle->map[SYSTEM_PROTECTED];
> > > +	else
> > > +		map = smmu_handle->map[SYSTEM_DEFAULT];
> > > +
> > > +	if (map)
> > > +		err = arm_iommu_attach_device(dev, map);
> > > +	else
> > > +		return -EPROBE_DEFER;
> > 
> > Given that patch 2 exists, if this test fails, then surely the
> > appropriate error code is some fatal error, not -EPROBE_DEFER; any
> > deferrals should have happened long before this point.
> 
> Will need to be revisited. Patching into the core really_probe() like
> patch #2 does is a really bad approach which would mean that returning
> EPROBE_DEFER is appropriate here.

I'm going to send PATCHv6, where it's a little bit easier to discuss
further since some code are cleaned up with feedback.

We once discussed to make use of bus_notifier instead of embedding a
hook in really_probe(). This would require some change where
bus_notifer return code needs to be used to postpone device
population.
