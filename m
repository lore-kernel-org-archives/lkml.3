Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755181Ab3LRRVA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 12:21:00 -0500
Received: from mga11.intel.com ([192.55.52.93]:35056 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753949Ab3LRRU5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 12:20:57 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,508,1384329600"; 
   d="scan'208";a="452111323"
Date: Wed, 18 Dec 2013 21:50:36 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Linus Walleij <linus.walleij@linaro.org>,
        Dan Williams <dan.j.williams@intel.com>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Alban Bedel <alban.bedel@avionic-design.de>,
        Tomasz Figa <tomasz.figa@gmail.com>
Subject: Re: [PATCH 1/2] dma: pl08x: fix descriptor unmapping
Message-ID: <20131218162036.GK16227@intel.com>
References: <1386976567-31343-1-git-send-email-linus.walleij@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1386976567-31343-1-git-send-email-linus.walleij@linaro.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 14, 2013 at 12:16:07AM +0100, Linus Walleij wrote:
> The descriptor unmapping code introduced in commit
> d38a8c622a1b3 "dmaengine: prepare for generic 'unmap' data"
> accidentally affects a local struct rather than the
> async TX descriptor, resulting in this compile error:
> 
>   CC      drivers/dma/amba-pl08x.o
> drivers/dma/amba-pl08x.c: In function ‘pl08x_desc_free’:
> drivers/dma/amba-pl08x.c:1172:2: warning: passing argument 1 of
> ‘dma_descriptor_unmap’ from incompatible pointer type [enabled by default]
> In file included from linux/include/linux/amba/pl08x.h:21:0,
>                  from linux/drivers/dma/amba-pl08x.c:79:
> linux/include/linux/dmaengine.h:476:20: note: expected
> ‘struct dma_async_tx_descriptor *’ but argument is of type ‘struct pl08x_txd *’
> 
> Cc: stable@vger.kernel.org
I am going to apply this and send thru fixes. But I dont think stable tag is apt
here. IIRC d38a8c622a1b3 was merged in last merge window, so as long this gets
sent in current -rc's we should be fine

Dropping stable, pls do yell if you feel otherwise.

--
~Vinod
> Cc: Dan Williams <dan.j.williams@intel.com>
> Cc: Alban Bedel <alban.bedel@avionic-design.de>
> Cc: Tomasz Figa <tomasz.figa@gmail.com>
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
> ---
>  drivers/dma/amba-pl08x.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/dma/amba-pl08x.c b/drivers/dma/amba-pl08x.c
> index 16a2aa28f856..ec4ee5c1fe9d 100644
> --- a/drivers/dma/amba-pl08x.c
> +++ b/drivers/dma/amba-pl08x.c
> @@ -1169,7 +1169,7 @@ static void pl08x_desc_free(struct virt_dma_desc *vd)
>  	struct pl08x_txd *txd = to_pl08x_txd(&vd->tx);
>  	struct pl08x_dma_chan *plchan = to_pl08x_chan(vd->tx.chan);
>  
> -	dma_descriptor_unmap(txd);
> +	dma_descriptor_unmap(&vd->tx);
>  	if (!txd->done)
>  		pl08x_release_mux(plchan);
>  
> -- 
> 1.8.3.1
> 

-- 
