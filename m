Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935113Ab3DHRKh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 13:10:37 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:54378 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762634Ab3DHRKg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 13:10:36 -0400
Date: Mon, 8 Apr 2013 18:09:56 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Peter Ujfalusi <peter.ujfalusi@ti.com>
Cc: Vinod Koul <vinod.koul@intel.com>, Dan Williams <djbw@fb.com>,
        Tony Lindgren <tony@atomide.com>,
        Jarkko Nikula <jarkko.nikula@bitmer.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Felipe Balbi <balbi@ti.com>, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Peter Meerwald <pmeerw@pmeerw.net>
Subject: Re: [RFC v2] dmaengine: omap-dma: Start DMA without delay for
	cyclic channels
Message-ID: <20130408170956.GX30923@n2100.arm.linux.org.uk>
References: <1364987862-14597-1-git-send-email-peter.ujfalusi@ti.com> <51626D88.8020809@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51626D88.8020809@ti.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 08, 2013 at 09:11:04AM +0200, Peter Ujfalusi wrote:
> Russell,
> 
> On 04/03/2013 01:17 PM, Peter Ujfalusi wrote:
> > cyclic DMA is only used by audio which needs DMA to be started without a
> > delay.
> > If the DMA for audio is started using the tasklet we experience random
> > channel switch (to be more precise: channel shift).
> > 
> > Reported-by: Peter Meerwald <pmeerw@pmeerw.net>
> > Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
> > ---
> > Hi Russell,
> > 
> > Instead of removing the tasklet we can identify the DMA channel used by audio
> > based on the cyclic flag of the channel.
> > I think this can be used as a short term solution to fix the audio channel shift
> > issue and later when we have the dynamic DMA channel allocation we can adjust
> > the code.
> 
> Could you, please look at this patch?

Now that I'm back from a short 4 day break, then yes, and the answer is
that it's fine.  Who's handling the patch?
