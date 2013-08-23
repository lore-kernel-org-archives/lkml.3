Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753872Ab3HWB3P (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 21:29:15 -0400
Received: from hqemgate16.nvidia.com ([216.228.121.65]:17894 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753108Ab3HWB3O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 21:29:14 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Thu, 22 Aug 2013 18:29:13 -0700
Date: Fri, 23 Aug 2013 09:29:11 +0800
From: Richard Zhao <rizhao@nvidia.com>
To: Stephen Warren <swarren@wwwdotorg.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "vinod.koul@intel.com" <vinod.koul@intel.com>,
        "djbw@fb.com" <djbw@fb.com>
Subject: Re: [PATCH] DMA: let filter functions of of_dma_simple_xlate
 possible check of_node
Message-ID: <20130823012911.GB17925@rizhao-lap>
References: <1375408800-11789-1-git-send-email-rizhao@nvidia.com>
 <20130822051904.GA2685@rizhao-lap>
 <52167213.6090604@wwwdotorg.org>
MIME-Version: 1.0
In-Reply-To: <52167213.6090604@wwwdotorg.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 23, 2013 at 04:18:27AM +0800, Stephen Warren wrote:
> On 08/21/2013 11:19 PM, Richard Zhao wrote:
> > On Fri, Aug 02, 2013 at 10:00:00AM +0800, Richard Zhao wrote:
> >> pass of_phandle_args dma_spec to dma_request_channel in of_dma_simple_xlate,
> >> so the filter function could access of_node in of_phandle_args.
> >>
> >> It also remove restriction of #dma-cells has to be one.
> >>
> >> Signed-off-by: Richard Zhao <rizhao@nvidia.com>
> >> ---
> >>  drivers/dma/edma.c     |  7 +++++--
> >>  drivers/dma/of-dma.c   | 10 ++++------
> >>  drivers/dma/omap-dma.c |  6 ++++--
> >>  3 files changed, 13 insertions(+), 10 deletions(-)
> >>
> > 
> > Hi Vinod,
> > 
> > Can you please pick up this change?
> > 
> > Hi Stephen,
> > 
> > Can you please give a ack or reviewed-by etc?
> 
> Hmm. Looking at the patch, I'm not sure it's right.
> 
> This patch simply passes all the specfier args to the filter function,
> and the code to check the equality of the of_node to the filter args is
> still duplicated in each DMA driver. Instead, the DMA core should be
> implementing the equality check, and only even calling the
> driver-specific filter function for devices where the client's phandle
> matches the DMA providing device's of_node handle.

Filter function is called in dmaengine core code, independent of dt.
And the reason why the driver has to write its own filter function is
it has to store slave id there in its own way.

Thanks
Richard
