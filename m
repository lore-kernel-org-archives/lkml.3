Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752912AbaHURKm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 13:10:42 -0400
Received: from mail-ie0-f179.google.com ([209.85.223.179]:61818 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752192AbaHURKk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 13:10:40 -0400
MIME-Version: 1.0
In-Reply-To: <1400789466-11156-1-git-send-email-manuel.schoelling@gmx.de>
References: <1400789466-11156-1-git-send-email-manuel.schoelling@gmx.de>
Date: Thu, 21 Aug 2014 10:10:39 -0700
Message-ID: <CAPcyv4gnMVHd6R=WuN84TLxrAgsBAq8u9_PcmpgD8QECZMZAQw@mail.gmail.com>
Subject: Re: [PATCH] ioat: Use time_before()
From: Dan Williams <dan.j.williams@intel.com>
To: =?UTF-8?Q?Manuel_Sch=C3=B6lling?= <manuel.schoelling@gmx.de>
Cc: Vinod Koul <vinod.koul@intel.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        "dmaengine@vger.kernel.org" <dmaengine@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 22, 2014 at 1:11 PM, Manuel Schölling
<manuel.schoelling@gmx.de> wrote:
> To be future-proof and for better readability the time comparisons are modified
> to use time_before() instead of plain, error-prone math.
>
> Signed-off-by: Manuel Schölling <manuel.schoelling@gmx.de>
> ---
>  drivers/dma/ioat/dma_v2.c |    3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/dma/ioat/dma_v2.c b/drivers/dma/ioat/dma_v2.c
> index 8d10580..fdd60c7 100644
> --- a/drivers/dma/ioat/dma_v2.c
> +++ b/drivers/dma/ioat/dma_v2.c
> @@ -735,7 +735,8 @@ int ioat2_check_space_lock(struct ioat2_dma_chan *ioat, int num_descs)
>          * called under bh_disabled so we need to trigger the timer
>          * event directly
>          */
> -       if (jiffies > chan->timer.expires && timer_pending(&chan->timer)) {
> +       if (time_before(chan->timer.expires, jiffies)
> +           && timer_pending(&chan->timer)) {
>                 struct ioatdma_device *device = chan->device;

Thanks, let's use time_is_before_jiffies() for this cleanup... I'll
fix up and apply.
