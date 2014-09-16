Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754495AbaIPN5D (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 09:57:03 -0400
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:58919 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754055AbaIPN5B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 09:57:01 -0400
Date: Tue, 16 Sep 2014 14:56:50 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Peter Ujfalusi <peter.ujfalusi@ti.com>
Cc: vinod.koul@intel.com, dan.j.williams@intel.com, dmaengine@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org
Subject: Re: [PATCH v2 2/2] dmaengine: omap-dma: Restore the CLINK_CTRL in
	resume path
Message-ID: <20140916135649.GF12379@n2100.arm.linux.org.uk>
References: <1410875629-1540-1-git-send-email-peter.ujfalusi@ti.com> <1410875629-1540-3-git-send-email-peter.ujfalusi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1410875629-1540-3-git-send-email-peter.ujfalusi@ti.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 16, 2014 at 04:53:49PM +0300, Peter Ujfalusi wrote:
> When the audio stream is paused or suspended we stop the sDMA and when it
> is unpaused/resumed we start the channel without reconfiguring it.
> The omap_dma_stop() clears the link configuration when we pause the dma, but
> it is not setting it back on start. This will result only one audio buffer
> to be played back and the DMA will stop, since the linking is disabled.
> We need to restore the CLINK_CTRL register in case of resume.
> 
> Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>

Both of these patches now look good, thanks.  For both:

Acked-by: Russell King <rmk+kernel@arm.linux.org.uk>

> ---
>  drivers/dma/omap-dma.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/drivers/dma/omap-dma.c b/drivers/dma/omap-dma.c
> index c01ea505ee7c..e0990c505889 100644
> --- a/drivers/dma/omap-dma.c
> +++ b/drivers/dma/omap-dma.c
> @@ -1019,6 +1019,9 @@ static int omap_dma_resume(struct omap_chan *c)
>  	if (c->paused) {
>  		mb();
>  
> +		/* Restore chanel link register */
> +		omap_dma_chan_write(c, CLNK_CTRL, c->desc->clnk_ctrl);
> +
>  		omap_dma_start(c, c->desc);
>  		c->paused = false;
>  	}
> -- 
> 2.1.0
> 

-- 
FTTC broadband for 0.8mile line: currently at 9.5Mbps down 400kbps up
according to speedtest.net.
