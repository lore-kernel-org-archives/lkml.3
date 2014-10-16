Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752751AbaJPTlP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 15:41:15 -0400
Received: from mout.gmx.net ([212.227.17.21]:51588 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751491AbaJPTlN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 15:41:13 -0400
Date: Thu, 16 Oct 2014 21:40:57 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
X-X-Sender: lyakh@axis700.grange
To: Vinod Koul <vinod.koul@intel.com>
cc: dmaengine@vger.kernel.org, Mauro Carvalho Chehab <m.chehab@samsung.com>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 03/12] [media] V4L2: mx3_camer: use dmaengine_pause()
 API
In-Reply-To: <1413042040-28222-3-git-send-email-vinod.koul@intel.com>
Message-ID: <Pine.LNX.4.64.1410162140390.16927@axis700.grange>
References: <1413041973-28146-1-git-send-email-vinod.koul@intel.com>
 <1413042040-28222-3-git-send-email-vinod.koul@intel.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V03:K0:50P4h3ziIgPLS9nnjmDkf2dCtsFLHRusGBaxAq0u933ZfnoxmLX
 RgYyrnw0iciyjpe3+WD1xe50qoEWSTAqFmulAf7w3s0NqxiJXarwJoqlu/E7zS59Ju3Z5ZJ
 6lau9rdzbqMKsJVhjM/Zgoq7Amzd1tJ71wr0qK1+hcg4mg/C9R9XnOXCQlwFQ9F3Df8x22c
 duDixdvPrHNCW+YTp9cJA==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 11 Oct 2014, Vinod Koul wrote:

> The drivers should use dmaengine_pause() API instead of
> accessing the device_control which will be deprecated soon
> 
> Signed-off-by: Vinod Koul <vinod.koul@intel.com>

Acked-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>

Thanks
Guennadi

> ---
>  drivers/media/platform/soc_camera/mx3_camera.c |    6 ++----
>  1 files changed, 2 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/media/platform/soc_camera/mx3_camera.c b/drivers/media/platform/soc_camera/mx3_camera.c
> index 83315df..7696a87 100644
> --- a/drivers/media/platform/soc_camera/mx3_camera.c
> +++ b/drivers/media/platform/soc_camera/mx3_camera.c
> @@ -415,10 +415,8 @@ static void mx3_stop_streaming(struct vb2_queue *q)
>  	struct mx3_camera_buffer *buf, *tmp;
>  	unsigned long flags;
>  
> -	if (ichan) {
> -		struct dma_chan *chan = &ichan->dma_chan;
> -		chan->device->device_control(chan, DMA_PAUSE, 0);
> -	}
> +	if (ichan)
> +		dmaengine_pause(&ichan->dma_chan);
>  
>  	spin_lock_irqsave(&mx3_cam->lock, flags);
>  
> -- 
> 1.7.0.4
> 
