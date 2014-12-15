Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751650AbaLOUEr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 15:04:47 -0500
Received: from galahad.ideasonboard.com ([185.26.127.97]:47423 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750764AbaLOUEp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 15:04:45 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Vinod Koul <vinod.koul@intel.com>
Cc: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        Simon Horman <horms+renesas@verge.net.au>,
        =?ISO-8859-1?Q?J=FCrg?= Billeter <j@bitron.ch>,
        Magnus Damm <damm+renesas@opensource.se>,
        Phil Edworthy <phil.edworthy@renesas.com>,
        linux-kernel@vger.kernel.org, linux-sh@vger.kernel.org,
        dmaengine@vger.kernel.org
Subject: Re: [PATCH] dmaengine: rcar-dmac: Handle hardware descriptor allocation failure
Date: Mon, 15 Dec 2014 22:04:45 +0200
Message-ID: <24462099.2yiDWKCQ5B@avalon>
User-Agent: KMail/4.14.3 (Linux/3.16.5-gentoo; KDE/4.14.3; x86_64; ; )
In-Reply-To: <20141215063834.GM16827@intel.com>
References: <1416924617-15939-1-git-send-email-j@bitron.ch> <2800395.CA9KFGZM72@avalon> <20141215063834.GM16827@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Vinod,

On Monday 15 December 2014 12:08:35 Vinod Koul wrote:
> On Fri, Dec 12, 2014 at 09:41:11PM +0200, Laurent Pinchart wrote:
> > On Thursday 11 December 2014 01:16:31 Kuninori Morimoto wrote:
> >>>> On Mon, Dec 08, 2014 at 11:20:44PM +0530, Vinod Koul wrote:
> >>>>> On Mon, Dec 08, 2014 at 07:40:15PM +0200, Laurent Pinchart wrote:
> >>>>>>>> [GIT PULL FOR v3.19] R-Car DMA engine driver
> >>>>>>>> http://www.spinics.net/lists/linux-sh/msg37764.html
> >>>>>>> 
> >>>>>>> And I dont seem to have this request in my Inbox :(
> >>>>>>> Yes I do see it in archieves, so not sure how this is not
> >>>>>>> present, not sure if the servers mangeled it!!
> >>>>>> 
> >>>>>> I haven't CC'ed you, I'll make sure to do so next time. The mail
> >>>>>> should still have reached you through the mailing list though (I
> >>>>>> assume you're subscribed to dmaengine@vger.kernel.org ;-)).
> >>>>> 
> >>>>> Yes I am, so should have reached me even though i wasnt cced
> >>>>> I do see email reaching me from list without me being in CC, but
> >>>>> then it wont hit my inbox and go to ML folder :)
> >>>>> So generally its a good practice to CC relvant folks, lots of
> >>>>> folks do ask that if ML is high volume
> >>>> 
> >>>> Hey Laurent,
> >>>> 
> >>>> I see that the oddity in commitlogs with change since artifacts
> >>>> after SOB, can you please fix that up
> >>> 
> >>> My bad. I've fixed the problem and pushed the result to the same
> >>> branch
> >>> 
> >>> 	git://linuxtv.org/pinchartl/fbdev.git dma/next
> >>> 
> >>> The only difference lies in the commit logs.
> >> 
> >> If my understanding was correct, we need to be based on Vinod's
> >> topic/slave_caps_device_control_fix
> > 
> > Vinod, could you please comment on that ? To which kernel version do you
> > plan to push this series ? Do I need to rebase it ?
> 
> Hi Laurent,
> 
> I did a quick at the series, looks fine mostly. I have already sent by pull
> request to linus earlier last week and its merged, so we need to merge it
> for next one. So yes we need to fix and test this for caps and control API
> fix. Can you do that and I will pull and put in my next for 3.20

That's very annoying given that I have users waiting for the driver to be 
merged, and that I've sent the pull request two weeks and a half ago.

I suppose I have no choice anyway. Please provide me with a v3.20 development 
branch on which I can rebase the patch set, I don't want to rebase it twice.

> One more thing I saw in driver "dmaengine: rcar-dmac: Add Renesas R-Car Gen2
> DMA Controller (DMAC) driver" is the CONFIG_ARCH_DMA_ADDR_T_64BIT code. Can
> you please explain a bit more on it, why do you need to modify addresses
> based on config option?

Because there's no need to write the upper bits (above 32) of the DMA 
addresses when the DMA address spans 32 bits only, and because there's no need 
to check for transfers that cross a 4GB boundary (that's a hardware 
limitation) when the DMA address space is 4GB in total.

-- 
Regards,

Laurent Pinchart

