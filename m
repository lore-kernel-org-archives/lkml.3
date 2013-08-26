Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752447Ab3HZOtV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 10:49:21 -0400
Received: from mail-pd0-f176.google.com ([209.85.192.176]:42084 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751857Ab3HZOtU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 10:49:20 -0400
Date: Mon, 26 Aug 2013 22:49:05 +0800
From: Richard Zhao <linuxzsc@gmail.com>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Richard Zhao <rizhao@nvidia.com>,
        "vinod.koul@intel.com" <vinod.koul@intel.com>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "djbw@fb.com" <djbw@fb.com>
Subject: Re: [PATCH] DMA: let filter functions of of_dma_simple_xlate
 possible check of_node
Message-ID: <20130826144901.GB2733@richard-laptop>
References: <1375408800-11789-1-git-send-email-rizhao@nvidia.com>
 <20130822051904.GA2685@rizhao-lap>
 <52167213.6090604@wwwdotorg.org>
 <20130823012911.GB17925@rizhao-lap>
 <52178677.6090001@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52178677.6090001@wwwdotorg.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 23, 2013 at 09:57:43AM -0600, Stephen Warren wrote:
> On 08/22/2013 07:29 PM, Richard Zhao wrote:
> > On Fri, Aug 23, 2013 at 04:18:27AM +0800, Stephen Warren wrote:
> >> On 08/21/2013 11:19 PM, Richard Zhao wrote:
> >>> On Fri, Aug 02, 2013 at 10:00:00AM +0800, Richard Zhao wrote:
> >>>> pass of_phandle_args dma_spec to dma_request_channel in of_dma_simple_xlate,
> >>>> so the filter function could access of_node in of_phandle_args.
> >>>>
> >>>> It also remove restriction of #dma-cells has to be one.
> >>>>
> >>>> Signed-off-by: Richard Zhao <rizhao@nvidia.com>
> >>>> ---
> >>>>  drivers/dma/edma.c     |  7 +++++--
> >>>>  drivers/dma/of-dma.c   | 10 ++++------
> >>>>  drivers/dma/omap-dma.c |  6 ++++--
> >>>>  3 files changed, 13 insertions(+), 10 deletions(-)
> >>>>
> >>>
> >>> Hi Vinod,
> >>>
> >>> Can you please pick up this change?
> >>>
> >>> Hi Stephen,
> >>>
> >>> Can you please give a ack or reviewed-by etc?
> >>
> >> Hmm. Looking at the patch, I'm not sure it's right.
> >>
> >> This patch simply passes all the specfier args to the filter function,
> >> and the code to check the equality of the of_node to the filter args is
> >> still duplicated in each DMA driver. Instead, the DMA core should be
> >> implementing the equality check, and only even calling the
> >> driver-specific filter function for devices where the client's phandle
> >> matches the DMA providing device's of_node handle.
> > 
> > Filter function is called in dmaengine core code, independent of dt.
> 
> The core code can still check if a dmaengine's driver was instantiated
> from DT and take additional actions in that case.

>From perspective of core code, the filter function is not attached to
any dma driver. So it doesn't care whether dt dma driver is instantiated.
I'm not sure I've got your point. Can you please write pieces of code if
possible?
The goal of this patch is to use least changes to add check of dt node.

Thanks
Richard
> 
> > And the reason why the driver has to write its own filter function is
> > it has to store slave id there in its own way.
> 
> I'm not saying don't call the driver's filter function, but rather that
> the dmaengine core should perform the common checks before doing so.
> 
