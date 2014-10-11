Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752492AbaJKRTm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Oct 2014 13:19:42 -0400
Received: from galahad.ideasonboard.com ([185.26.127.97]:60239 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751785AbaJKRTk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Oct 2014 13:19:40 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Vinod Koul <vinod.koul@intel.com>
Cc: dmaengine@vger.kernel.org, David Woodhouse <dwmw2@infradead.org>,
        Brian Norris <computersforpeace@gmail.com>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Jingoo Han <jg1.han@samsung.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 05/12] mtd: sh_flctl: use dmaengine_terminate_all() API
Date: Sat, 11 Oct 2014 20:19:50 +0300
Message-ID: <4775968.otKQDIzYx4@avalon>
User-Agent: KMail/4.12.5 (Linux/3.14.14-gentoo; KDE/4.12.5; x86_64; ; )
In-Reply-To: <1413042040-28222-5-git-send-email-vinod.koul@intel.com>
References: <1413041973-28146-1-git-send-email-vinod.koul@intel.com> <1413042040-28222-5-git-send-email-vinod.koul@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 11 October 2014 21:10:33 Vinod Koul wrote:
> The drivers should use dmaengine_terminate_all() API instead of
> accessing the device_control which will be deprecated soon
> 
> Signed-off-by: Vinod Koul <vinod.koul@intel.com>

Acked-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>

> ---
>  drivers/mtd/nand/sh_flctl.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/mtd/nand/sh_flctl.c b/drivers/mtd/nand/sh_flctl.c
> index c067023..0ed7c60 100644
> --- a/drivers/mtd/nand/sh_flctl.c
> +++ b/drivers/mtd/nand/sh_flctl.c
> @@ -395,7 +395,7 @@ static int flctl_dma_fifo0_transfer(struct sh_flctl
> *flctl, unsigned long *buf, msecs_to_jiffies(3000));
> 
>  	if (ret <= 0) {
> -		chan->device->device_control(chan, DMA_TERMINATE_ALL, 0);
> +		dmaengine_terminate_all(chan);
>  		dev_err(&flctl->pdev->dev, "wait_for_completion_timeout\n");
>  	}

-- 
Regards,

Laurent Pinchart

