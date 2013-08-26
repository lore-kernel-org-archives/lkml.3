Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756575Ab3HZNQn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 09:16:43 -0400
Received: from perceval.ideasonboard.com ([95.142.166.194]:60945 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751602Ab3HZNQl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 09:16:41 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Richard Zhao <linuxzsc@gmail.com>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>
Cc: Stephen Warren <swarren@wwwdotorg.org>,
        "vinod.koul@intel.com" <vinod.koul@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Richard Zhao <rizhao@nvidia.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] DMA: let filter functions of of_dma_simple_xlate possible check of_node
Date: Mon, 26 Aug 2013 15:18 +0200
Message-ID: <2811939.DFy94j5OEx@avalon>
User-Agent: KMail/4.10.5 (Linux/3.8.13-gentoo; KDE/4.10.5; x86_64; ; )
In-Reply-To: <20130826125547.GA2733@richard-laptop>
References: <1375408800-11789-1-git-send-email-rizhao@nvidia.com> <1441310.1kjKG7uebg@avalon> <20130826125547.GA2733@richard-laptop>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Richard,

(Dropping Dan Williams from the CC list as his e-mail address doesn't seem to 
be valid anymore)

On Monday 26 August 2013 20:55:57 Richard Zhao wrote:
> On Mon, Aug 26, 2013 at 02:17:43PM +0200, Laurent Pinchart wrote:
> > On Friday 23 August 2013 09:57:43 Stephen Warren wrote:
> > > On 08/22/2013 07:29 PM, Richard Zhao wrote:
> > > > On Fri, Aug 23, 2013 at 04:18:27AM +0800, Stephen Warren wrote:
> > > >> On 08/21/2013 11:19 PM, Richard Zhao wrote:
> > > >>> On Fri, Aug 02, 2013 at 10:00:00AM +0800, Richard Zhao wrote:
> > > >>>> pass of_phandle_args dma_spec to dma_request_channel in
> > > >>>> of_dma_simple_xlate, so the filter function could access of_node in
> > > >>>> of_phandle_args.
> > > >>>> 
> > > >>>> It also remove restriction of #dma-cells has to be one.
> > > >>>> 
> > > >>>> Signed-off-by: Richard Zhao <rizhao@nvidia.com>
> > > >>>> ---
> > > >>>> 
> > > >>>>  drivers/dma/edma.c     |  7 +++++--
> > > >>>>  drivers/dma/of-dma.c   | 10 ++++------
> > > >>>>  drivers/dma/omap-dma.c |  6 ++++--
> > > >>>>  3 files changed, 13 insertions(+), 10 deletions(-)
> > > >>> 
> > > >>> Hi Vinod,
> > > >>> 
> > > >>> Can you please pick up this change?
> > > >>> 
> > > >>> Hi Stephen,
> > > >>> 
> > > >>> Can you please give a ack or reviewed-by etc?
> > > >> 
> > > >> Hmm. Looking at the patch, I'm not sure it's right.
> > > >> 
> > > >> This patch simply passes all the specfier args to the filter
> > > >> function, and the code to check the equality of the of_node to the
> > > >> filter args is still duplicated in each DMA driver. Instead, the DMA
> > > >> core should be implementing the equality check, and only even calling
> > > >> the driver-specific filter function for devices where the client's
> > > >> phandle matches the DMA providing device's of_node handle.
> > > > 
> > > > Filter function is called in dmaengine core code, independent of dt.
> > > 
> > > The core code can still check if a dmaengine's driver was instantiated
> > > from DT and take additional actions in that case.
> > > 
> > > > And the reason why the driver has to write its own filter function is
> > > > it has to store slave id there in its own way.
> > > 
> > > I'm not saying don't call the driver's filter function, but rather that
> > > the dmaengine core should perform the common checks before doing so.
> > 
> > And it looks to me like the common case could even get rid of the driver's
> > filter function:
> > 
> > https://lkml.org/lkml/2013/5/15/270
> > https://lkml.org/lkml/2013/3/25/250
> 
> For general case, the slave id is not staticly bind to a specific channel.

Certainly not in all cases, but I think it's common enough to deserve a 
specific helper function.

-- 
Regards,

Laurent Pinchart

