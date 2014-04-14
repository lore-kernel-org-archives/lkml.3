Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754846AbaDNNkh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 09:40:37 -0400
Received: from mga02.intel.com ([134.134.136.20]:22410 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754260AbaDNNke (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 09:40:34 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,857,1389772800"; 
   d="scan'208";a="520456627"
Message-ID: <1397482830.11914.126.camel@smile.fi.intel.com>
Subject: Re: [PATCH v3 4/8] DMA: Freescale: add fsl_dma_free_descriptor() to
 reduce code duplication
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Hongbo Zhang <hongbo.zhang@freescale.com>
Cc: vkoul@infradead.org, dan.j.williams@intel.com, dmaengine@vger.kernel.org,
        scottwood@freescale.com, leo.li@freescale.com,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Date: Mon, 14 Apr 2014 16:40:30 +0300
In-Reply-To: <5347A46B.30206@freescale.com>
References: <1397113805-24171-1-git-send-email-hongbo.zhang@freescale.com>
	 <1397113805-24171-5-git-send-email-hongbo.zhang@freescale.com>
	 <1397129361.11914.96.camel@smile.fi.intel.com>
	 <5347A46B.30206@freescale.com>
Organization: Intel Finland Oy
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5-2+b3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-04-11 at 16:14 +0800, Hongbo Zhang wrote:
> On 04/10/2014 07:29 PM, Andy Shevchenko wrote:
> > On Thu, 2014-04-10 at 15:10 +0800, hongbo.zhang@freescale.com wrote:

[]

> >> @@ -819,8 +826,7 @@ static void fsldma_cleanup_descriptor(struct fsldma_chan *chan,
> >>   	dma_run_dependencies(txd);
> >>   
> >>   	dma_descriptor_unmap(txd);
> >> -	chan_dbg(chan, "LD %p free\n", desc);
> >> -	dma_pool_free(chan->desc_pool, desc, txd->phys);
> >> +	fsl_dma_free_descriptor(chan, desc);
> > Here is no list_del() call since it's been called in dma_do_tasklet().
> > What will be the result of double list_del() against the same node?
> 
> Not clear with your point.
> This patch is only introducing a common fsl_dma_free_descriptor() to 
> reduce code duplication. And later in the patch 6/8 the 
> fsldma_cleanup_descriptor() is replaced by fsldma_cleanup_descriptorS().

In the last case you could have a broken kernel which will fails on
double list_del(). I think it's better to leave this one untouched and
you may remove it later.

Or move this patch after you have removed that lines.

-- 
Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Intel Finland Oy

