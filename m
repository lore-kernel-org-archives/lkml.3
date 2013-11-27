Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757290Ab3K0Ti5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 14:38:57 -0500
Received: from mail-bk0-f42.google.com ([209.85.214.42]:45384 "EHLO
	mail-bk0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757055Ab3K0Tiu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 14:38:50 -0500
MIME-Version: 1.0
In-Reply-To: <1385528004-19423-1-git-send-email-olof@lixom.net>
References: <1385528004-19423-1-git-send-email-olof@lixom.net>
Date: Wed, 27 Nov 2013 11:38:48 -0800
Message-ID: <CAPcyv4js+Hq+b8g1i65NE8iK-BnXjG9Bi3PuPpWXRss19-Z9Jg@mail.gmail.com>
Subject: Re: [PATCH] dmaengine: pl08x: fix conversioin for generic unmap data
From: Dan Williams <dan.j.williams@intel.com>
To: Olof Johansson <olof@lixom.net>
Cc: Vinod Koul <vinod.koul@intel.com>,
        "dmaengine@vger.kernel.org" <dmaengine@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks, Olof I'll push this shortly.  I'll add your acked-by to this
one from Russell.

https://patchwork.kernel.org/patch/3241941/

--
Dan

On Tue, Nov 26, 2013 at 8:53 PM, Olof Johansson <olof@lixom.net> wrote:
> commit d38a8c622a1b ('dmaengine: prepare for generic 'unmap' data')
> added a generic unmap call but used the wrong argument for it. Fix it.
>
> Fixes: d38a8c622a1b ('dmaengine: prepare for generic 'unmap' data')
> Signed-off-by: Olof Johansson <olof@lixom.net>
> ---
>
> I can't actually tell what the intent of d38a8cc622a1b and how mappings
> are expected to be managed, but it's obviously passing the wrong thing
> in here so it seems like the appropriate fix.
>
>  drivers/dma/amba-pl08x.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/dma/amba-pl08x.c b/drivers/dma/amba-pl08x.c
> index 16a2aa28f856..ec4ee5c1fe9d 100644
> --- a/drivers/dma/amba-pl08x.c
> +++ b/drivers/dma/amba-pl08x.c
> @@ -1169,7 +1169,7 @@ static void pl08x_desc_free(struct virt_dma_desc *vd)
>         struct pl08x_txd *txd = to_pl08x_txd(&vd->tx);
>         struct pl08x_dma_chan *plchan = to_pl08x_chan(vd->tx.chan);
>
> -       dma_descriptor_unmap(txd);
> +       dma_descriptor_unmap(&vd->tx);
>         if (!txd->done)
>                 pl08x_release_mux(plchan);
>
> --
> 1.8.4.1.601.g02b3b1d
>
