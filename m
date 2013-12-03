Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754696Ab3LCRuj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 12:50:39 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:41907 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754158Ab3LCRuf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 12:50:35 -0500
Message-ID: <529E19E7.8090402@wwwdotorg.org>
Date: Tue, 03 Dec 2013 10:50:31 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Dan Williams <dan.j.williams@intel.com>, Vinod Koul <vinod.koul@intel.com>
CC: dmaengine@vger.kernel.org, linux-kernel@vger.kernel.org,
        Stephen Warren <swarren@nvidia.com>,
        Lars-Peter Clausen <lars@metafoo.de>
Subject: Re: [PATCH V4] dma: add dma_get_any_slave_channel(), for use in of_xlate()
References: <1385494851-22640-1-git-send-email-swarren@wwwdotorg.org>
In-Reply-To: <1385494851-22640-1-git-send-email-swarren@wwwdotorg.org>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/26/2013 12:40 PM, Stephen Warren wrote:
> From: Stephen Warren <swarren@nvidia.com>
> 
> mmp_pdma.c implements a custom of_xlate() function that is 95% identical
> to what Tegra will need. Create a function to implement the common part,
> so everyone doesn't just cut/paste the implementation.
> 
> Cc: Dan Williams <dan.j.williams@intel.com>
> Cc: Vinod Koul <vinod.koul@intel.com>
> Cc: Lars-Peter Clausen <lars@metafoo.de>
> Cc: dmaengine@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> Signed-off-by: Stephen Warren <swarren@nvidia.com>
> ---
> v3:
> * Re-implemented the common code as dma_get_any_slave_channel(), in
>   dmaengine.c. This allows it to mutex_lock(&dma_list_mutex), and hence
>   avoid the retry loop.
> * Rather than having the common code call out to a driver-provided
>   callback at the tail (which avoided drivers having to implement an
>   of_xlate function themselves), have drivers implement a custom
>   of_xlate() again, which mostly just calls the new
>   dma_get_any_slave_channel(), then does any extra custom work.
> 
> v2:
> * Squashed the conversion of mmp_pdma.c into the patch that added the
>   common implementation, so it's easier to see the whole conversion in
>   one go.
> 
> This patch is a dependency for a series that reworks many of the Tegra
> drivers.
> 
> As such, it needs to go into a topic branch on its own, based directly
> on 3.13-rc1. If the DMA maintainers ack the patches I'm happy to create
> this topic branch myself and send a pull request to the DMA tree. Or the
> patches can be applied to a topic branch by the DMA maintainers and I
> will merge their topic branch into the Tegra rework branch that I
> mentioned.
> 
> Note that this patch is independant from the "dma: add channel request
> API that supports deferred probe" which I just sent, so it could
> (should?) be a different topic branch.

Vinod, does this patch look OK to you? Are you able to stage it into a
topic branch that I can pull into the Tegra tree as a dependency?
