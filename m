Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757578Ab3CUHLr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 03:11:47 -0400
Received: from mga02.intel.com ([134.134.136.20]:61161 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753151Ab3CUHLp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 03:11:45 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,884,1355126400"; 
   d="scan'208";a="282606005"
Date: Thu, 21 Mar 2013 12:16:43 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Matt Porter <mporter@ti.com>
Cc: Chris Ball <cjb@laptop.org>, Dan Williams <djbw@fb.com>,
        Sekhar Nori <nsekhar@ti.com>, Grant Likely <grant.likely@secretlab.ca>,
        Linux DaVinci Kernel List 
	<davinci-linux-open-source@linux.davincidsp.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux MMC List <linux-mmc@vger.kernel.org>
Subject: Re: [PATCH v4 0/3] dmaengine: add slave sg transfer limits api
Message-ID: <20130321064643.GG10326@intel.com>
References: <1362599767-11292-1-git-send-email-mporter@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1362599767-11292-1-git-send-email-mporter@ti.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 06, 2013 at 02:56:04PM -0500, Matt Porter wrote:
> Changes since v3:
> 	- Change api name to dma_get_slave_sg_limits() to avoid
> 	  confusion with h/w caps which are static.
> 
> Changes since v2:
> 	- Change to a separate slave sg specific api. Drop the
> 	  generic per-channel capabilities api that is not used.
> 
> Changes since v1:
> 	- Use the existing dma_transaction_type enums instead of
> 	  adding the mostly duplicated dmaengine_apis enums
> 
> This series adds a new dmaengine api, dma_get_slave_sg_limits(), which
> may be used by a client driver to get slave SG transfer limits for a
> particular channel. At this time, these include the max number of
> segments and max length of a segment that a channel can handle for a
> SG transfer.
Looks fine, should be ready for merge once we fix the API.
Also I was under the impression that you will add another API to calculate the
limits, the stuff which you were doing in caps API earlier.

--
~Vinod
> 
> Along with the API implementation, this series implements the backend
> device_slave_sg_limits() in the EDMA DMA Engine driver and converts the
> davinci_mmc driver to use dma_get_slave_sg_limits() to replace hardcoded
> limits.
> 
> This is tested on the AM1808-EVM.
> 
> Matt Porter (3):
>   dmaengine: add dma_get_slave_sg_limits()
>   dma: edma: add device_slave_sg_limits() support
>   mmc: davinci: get SG segment limits with dma_get_slave_sg_limits()
> 
>  drivers/dma/edma.c                        |   17 +++++++++++++
>  drivers/mmc/host/davinci_mmc.c            |   37 ++++++++-------------------
>  include/linux/dmaengine.h                 |   39 +++++++++++++++++++++++++++++
>  include/linux/platform_data/mmc-davinci.h |    3 ---
>  4 files changed, 66 insertions(+), 30 deletions(-)
> 
> -- 
> 1.7.9.5
> 
