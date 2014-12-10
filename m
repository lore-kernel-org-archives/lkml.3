Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932464AbaLJQIe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 11:08:34 -0500
Received: from galahad.ideasonboard.com ([185.26.127.97]:41816 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932167AbaLJQIb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 11:08:31 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Vinod Koul <vinod.koul@intel.com>,
        Simon Horman <horms+renesas@verge.net.au>
Cc: =?ISO-8859-1?Q?J=FCrg?= Billeter <j@bitron.ch>,
        Magnus Damm <damm+renesas@opensource.se>,
        Phil Edworthy <phil.edworthy@renesas.com>,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        linux-kernel@vger.kernel.org, linux-sh@vger.kernel.org,
        dmaengine@vger.kernel.org
Subject: Re: [PATCH] dmaengine: rcar-dmac: Handle hardware descriptor allocation failure
Date: Wed, 10 Dec 2014 18:09:17 +0200
Message-ID: <2735456.CKbC358ZrM@avalon>
User-Agent: KMail/4.12.5 (Linux/3.16.5-gentoo; KDE/4.12.5; x86_64; ; )
In-Reply-To: <20141209063912.GZ16827@intel.com>
References: <1416924617-15939-1-git-send-email-j@bitron.ch> <20141208175044.GT16827@intel.com> <20141209063912.GZ16827@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Vinod,

On Tuesday 09 December 2014 12:09:12 Vinod Koul wrote:
> On Mon, Dec 08, 2014 at 11:20:44PM +0530, Vinod Koul wrote:
> > On Mon, Dec 08, 2014 at 07:40:15PM +0200, Laurent Pinchart wrote:
> > > > > [GIT PULL FOR v3.19] R-Car DMA engine driver
> > > > > http://www.spinics.net/lists/linux-sh/msg37764.html
> > > > 
> > > > And I dont seem to have this request in my Inbox :(
> > > > Yes I do see it in archieves, so not sure how this is not present, not
> > > > sure if the servers mangeled it!!
> > > 
> > > I haven't CC'ed you, I'll make sure to do so next time. The mail should
> > > still have reached you through the mailing list though (I assume you're
> > > subscribed to dmaengine@vger.kernel.org ;-)).
> > 
> > Yes I am, so should have reached me even though i wasnt cced
> > I do see email reaching me from list without me being in CC, but then it
> > wont hit my inbox and go to ML folder :)
> > So generally its a good practice to CC relvant folks, lots of folks do ask
> > that if ML is high volume
> 
> Hey Laurent,
> 
> I see that the oddity in commitlogs with change since artifacts after SOB,
> can you please fix that up

My bad. I've fixed the problem and pushed the result to the same branch

	git://linuxtv.org/pinchartl/fbdev.git dma/next

The only difference lies in the commit logs.

> 	commit 43dc9ba2b51ccb9124bf6fed614c5053500592a6
> 	Author: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
> 	Date:   Sat Jul 19 00:05:14 2014 +0200
> 
> 	    dmaengine: rcar-dmac: Cache hardware descriptors memory
> 
> 	    Unlike DMA transfers descriptors that are preallocated and cached,
> 	    memory used to store hardware descriptors is allocated and freed with
> 	    the DMA coherent allocation API for every transfer. Besides degrading
> 	    performances, this creates a CMA stress test that seems to cause
> issues. Running dmatest with the noverify option produces
> 
> 	    [   50.066539] alloc_contig_range test_pages_isolated(6b845, 6b846)
> failed [   50.235180] alloc_contig_range test_pages_isolated(6b848, 6b84e)
> failed [   52.964584] alloc_contig_range test_pages_isolated(6b847, 6b848)
> failed [   54.127113] alloc_contig_range test_pages_isolated(6b843, 6b844)
> failed [   56.270253] alloc_contig_range test_pages_isolated(6b84c, 6b850)
> failed
> 
> 	    The root cause needs to be fixed, but in the meantime, as a 
workaround
> 	    and a performance improvement, cache hardware descriptors.
> 
> 	    Signed-off-by: Laurent Pinchart
> <laurent.pinchart+renesas@ideasonboard.com> Tested-by: Wolfram Sang
> <wsa+renesas@sang-engineering.com>
> 
> 	    ---
> 
> 	    Changes since v2:
> 
> 	    - Typo fixes
> 	    - Align allocated hwdesc size to page size
> 	    - Ignore allocated hwdesc memory when the transfer doesn't use 
hwdescs
> 
> 	commit feb2e9f12b1a4a871b1d3eb2e2f44255510a79d3
> 	Author: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
> 	Date:   Wed Jul 16 23:15:48 2014 +0200
> 
> 	    dmaengine: rcar-dmac: Implement support for hardware descriptor lists
> 
> 	    The DMAC supports hardware-based auto-configuration from descriptor
> 	    lists. This reduces the number of interrupts required for processing 
a
> 	    DMA transfer. Support that mode in the driver.
> 
> 	    Signed-off-by: Laurent Pinchart
> <laurent.pinchart+renesas@ideasonboard.com> Tested-by: Wolfram Sang
> <wsa+renesas@sang-engineering.com>
> 
> 	    ---
> 
> 	    Changes since v2:
> 
> 	    - Typo fixes
> 	    - Use GFP_NOWAIT to allocate hardware descriptors
> 	    - Clear descriptor stage end interrupt when halting the channel
> 
> and many more...

-- 
Regards,

Laurent Pinchart

