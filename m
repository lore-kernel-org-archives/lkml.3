Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755885Ab3L3OAA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Dec 2013 09:00:00 -0500
Received: from 8bytes.org ([85.214.48.195]:56623 "EHLO mail.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755713Ab3L3N75 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Dec 2013 08:59:57 -0500
Date: Mon, 30 Dec 2013 14:45:23 +0100
From: Joerg Roedel <joro@8bytes.org>
To: Hiroshi Doyu <hdoyu@nvidia.com>
Cc: Stephen Warren <swarren@wwwdotorg.org>, swarren@nvidia.com,
        will.deacon@arm.com, grant.likely@linaro.org, thierry.reding@gmail.com,
        robherring2@gmail.com, mark.rutland@arm.com,
        devicetree@vger.kernel.org, lorenzo.pieralisi@arm.com,
        linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
        galak@codeaurora.org, linux-tegra@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCHv7 05/12] iommu/core: add ops->{bound,unbind}_driver()
Message-ID: <20131230134522.GB2799@8bytes.org>
References: <1386835033-4701-1-git-send-email-hdoyu@nvidia.com>
 <1386835033-4701-6-git-send-email-hdoyu@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1386835033-4701-6-git-send-email-hdoyu@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Mon Dec 30 14:45:27 2013
X-DSPAM-Confidence: 0.9994
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 52c178f720866384153369
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 12, 2013 at 09:57:06AM +0200, Hiroshi Doyu wrote:
> ops->{bound,unbind}_driver() functions are called at
> BUS_NOTIFY_{BOUND,UNBIND}_DRIVER respectively.
> 
> This is necessary to control the device population order. IOMMU master
> devices depend on an IOMMU device instanciation. IOMMU master devices
> can be registered to an IOMMU only after it's successfully
> populated. This IOMMU registration is done via
> ops->bound_driver(). Currently this population can be deferred if
> depending IOMMU device hasn't yet been populated in driver core. This
> cannot be done via ops->add_device() since after add_device() device's
> population/instanciation can be still deferred via probe().

How about doing dependency checking in the add/remove_device callbacks
instead? When a device is about to be initialized where the IOMMU is not
set up yet, just setup the IOMMU first before initializing the device?


	Joerg


