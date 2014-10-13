Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755392AbaJMCr3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Oct 2014 22:47:29 -0400
Received: from mail-vc0-f176.google.com ([209.85.220.176]:50401 "EHLO
	mail-vc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752982AbaJMCrY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Oct 2014 22:47:24 -0400
MIME-Version: 1.0
In-Reply-To: <1413042040-28222-1-git-send-email-vinod.koul@intel.com>
References: <1413041973-28146-1-git-send-email-vinod.koul@intel.com>
	<1413042040-28222-1-git-send-email-vinod.koul@intel.com>
Date: Mon, 13 Oct 2014 08:17:23 +0530
X-Google-Sender-Auth: EOSW1nrA2NZz3ZxgZRTkjCMrMxk
Message-ID: <CAOh2x=m4hFd9PYnZ5Umdznov0kaUitUdcMcDD+21bwJxJSy9zQ@mail.gmail.com>
Subject: Re: [PATCH 01/12] pata_arasan_cf: use dmaengine_terminate_all() API
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Vinod Koul <vinod.koul@intel.com>
Cc: dmaengine@vger.kernel.org, Tejun Heo <tj@kernel.org>,
        "...)" <linux-ide@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 11, 2014 at 9:10 PM, Vinod Koul <vinod.koul@intel.com> wrote:
> The drivers should use dmaengine_terminate_all() API instead of accessing
> the device_control which will be deprecated soon
>
> Signed-off-by: Vinod Koul <vinod.koul@intel.com>
> ---
>  drivers/ata/pata_arasan_cf.c |    5 ++---
>  1 files changed, 2 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/ata/pata_arasan_cf.c b/drivers/ata/pata_arasan_cf.c
> index 4edb1a8..38216b9 100644
> --- a/drivers/ata/pata_arasan_cf.c
> +++ b/drivers/ata/pata_arasan_cf.c
> @@ -420,7 +420,7 @@ dma_xfer(struct arasan_cf_dev *acdev, dma_addr_t src, dma_addr_t dest, u32 len)
>
>         /* Wait for DMA to complete */
>         if (!wait_for_completion_timeout(&acdev->dma_completion, TIMEOUT)) {
> -               chan->device->device_control(chan, DMA_TERMINATE_ALL, 0);
> +               dmaengine_terminate_all(chan);
>                 dev_err(acdev->host->dev, "wait_for_completion_timeout\n");
>                 return -ETIMEDOUT;
>         }
> @@ -928,8 +928,7 @@ static int arasan_cf_suspend(struct device *dev)
>         struct arasan_cf_dev *acdev = host->ports[0]->private_data;
>
>         if (acdev->dma_chan)
> -               acdev->dma_chan->device->device_control(acdev->dma_chan,
> -                               DMA_TERMINATE_ALL, 0);
> +               dmaengine_terminate_all(acdev->dma_chan);
>
>         cf_exit(acdev);
>         return ata_host_suspend(host, PMSG_SUSPEND);

Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
