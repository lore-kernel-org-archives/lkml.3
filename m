Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752908AbaEBQ66 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2014 12:58:58 -0400
Received: from mga03.intel.com ([143.182.124.21]:11746 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752485AbaEBQ65 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2014 12:58:57 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,973,1389772800"; 
   d="scan'208";a="426869158"
Date: Fri, 2 May 2014 22:16:04 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: hongbo.zhang@freescale.com
Cc: vkoul@infradead.org, dan.j.williams@intel.com, dmaengine@vger.kernel.org,
        scottwood@freescale.com, leo.li@freescale.com,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 8/8] DMA: Freescale: add suspend resume functions
 for DMA driver
Message-ID: <20140502164604.GB32284@intel.com>
References: <1397809071-5353-1-git-send-email-hongbo.zhang@freescale.com>
 <1397809071-5353-9-git-send-email-hongbo.zhang@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1397809071-5353-9-git-send-email-hongbo.zhang@freescale.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 18, 2014 at 04:17:51PM +0800, hongbo.zhang@freescale.com wrote:
> From: Hongbo Zhang <hongbo.zhang@freescale.com>
> 
> This patch adds suspend resume functions for Freescale DMA driver.
> .prepare callback is used to stop further descriptors from being added into the
> pending queue, and also issue pending queues into execution if there is any.
> .suspend callback makes sure all the pending jobs are cleaned up and all the
> channels are idle, and save the mode registers.
> .resume callback re-initializes the channels by restore the mode registers.
> 

> +
> +static const struct dev_pm_ops fsldma_pm_ops = {
> +	.prepare	= fsldma_prepare,
> +	.suspend	= fsldma_suspend,
> +	.resume		= fsldma_resume,
> +};
I think this is not correct. We discussed this sometime back on list. The
DMAengine drivers should use late resume and early suspend to ensure they get
suspended after clients (who should use normal ones) and resume before them

-- 
~Vinod
