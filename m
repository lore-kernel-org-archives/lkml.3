Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934645Ab3BTC05 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 21:26:57 -0500
Received: from mail-ie0-f172.google.com ([209.85.223.172]:59355 "EHLO
	mail-ie0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934614Ab3BTC0z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 21:26:55 -0500
MIME-Version: 1.0
In-Reply-To: <1360635933-5818-1-git-send-email-tomoya.rohm@gmail.com>
References: <1360635933-5818-1-git-send-email-tomoya.rohm@gmail.com>
Date: Wed, 20 Feb 2013 11:26:54 +0900
Message-ID: <CANKRQnhp_+mKnezqWZ2OZxecpac-N0EpmKuV8p285LC3jSEw2w@mail.gmail.com>
Subject: Re: [PATCH] pch_dma: Use GFP_ATOMIC because called from interrupt context
From: Tomoya MORINAGA <tomoya.rohm@gmail.com>
To: Vinod Koul <vinod.koul@intel.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

Could you review this patch ?
8 days have passed...

thanks,
tomoya

On Tue, Feb 12, 2013 at 11:25 AM, Tomoya MORINAGA <tomoya.rohm@gmail.com> wrote:
> pdc_desc_get() is called from pd_prep_slave_sg, and the function is
> called from interrupt context(e.g. Uart driver "pch_uart.c").
> In fact, I saw kernel error message.
> So, GFP_ATOMIC must be used not GFP_NOIO.
>
> Signed-off-by: Tomoya MORINAGA <tomoya.rohm@gmail.com>
> ---
>  drivers/dma/pch_dma.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/dma/pch_dma.c b/drivers/dma/pch_dma.c
> index 987ab5c..d5cbd44 100644
> --- a/drivers/dma/pch_dma.c
> +++ b/drivers/dma/pch_dma.c
> @@ -476,7 +476,7 @@ static struct pch_dma_desc *pdc_desc_get(struct pch_dma_chan *pd_chan)
>         dev_dbg(chan2dev(&pd_chan->chan), "scanned %d descriptors\n", i);
>
>         if (!ret) {
> -               ret = pdc_alloc_desc(&pd_chan->chan, GFP_NOIO);
> +               ret = pdc_alloc_desc(&pd_chan->chan, GFP_ATOMIC);
>                 if (ret) {
>                         spin_lock(&pd_chan->lock);
>                         pd_chan->descs_allocated++;
> --
> 1.7.4.4

-- 
ROHM Co., Ltd.
tomoya
