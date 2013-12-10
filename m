Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753289Ab3LJNUe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 08:20:34 -0500
Received: from mga11.intel.com ([192.55.52.93]:42418 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751498Ab3LJNUc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 08:20:32 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,865,1378882800"; 
   d="scan'208";a="441698600"
Date: Tue, 10 Dec 2013 17:51:59 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Dan Williams <dan.j.williams@intel.com>, andriy.shevchenko@intel.com,
        dmaengine@vger.kernel.org, linux-kernel@vger.kernel.org,
        Stephen Warren <swarren@nvidia.com>
Subject: Re: [PATCH V4] dma: add channel request API that supports deferred
 probe
Message-ID: <20131210122159.GJ29580@intel.com>
References: <1385485462-30376-1-git-send-email-swarren@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1385485462-30376-1-git-send-email-swarren@wwwdotorg.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 26, 2013 at 10:04:22AM -0700, Stephen Warren wrote:
> From: Stephen Warren <swarren@nvidia.com>
> 
> dma_request_slave_channel() simply returns NULL whenever DMA channel
> lookup fails. Lookup could fail for two distinct reasons:
> 
> a) No DMA specification exists for the channel name.
>    This includes situations where no DMA specifications exist at all, or
>    other general lookup problems.
> 
> b) A DMA specification does exist, yet the driver for that channel is not
>    yet registered.
> 
> Case (b) should trigger deferred probe in client drivers. However, since
> they have no way to differentiate the two situations, it cannot.
> 
> Implement new function dma_request_slave_channel_reason(), which performs
> identically to dma_request_slave_channel(), except that it returns an
> error-pointer rather than NULL, which allows callers to detect when
> deferred probe should occur.
> 
> Eventually, all drivers should be converted to this new API, the old API
> removed, and the new API renamed to the more desirable name. This patch
> doesn't convert the existing API and all drivers in one go, since some
> drivers call dma_request_slave_channel() then dma_request_channel() if
> that fails. That would require either modifying dma_request_channel() in
> the same way, or adding extra error-handling code to all affected
> drivers, and there are close to 100 drivers using the other API, rather
> than just the 15-20 or so that use dma_request_slave_channel(), which
> might be tenable in a single patch.
> 
> acpi_dma_request_slave_chan_by_name() doesn't currently implement
> deferred probe. It should, but this will be addressed later.
> 
> Acked-by: Dan Williams <dan.j.williams@intel.com>
> Signed-off-by: Stephen Warren <swarren@nvidia.com>
Applied, to topic/defer_probe, this wont be rebased so feel free to merge

--
~Vinod
