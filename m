Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757003Ab3AOVPK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 16:15:10 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:45996 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756731Ab3AOVPE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 16:15:04 -0500
Message-ID: <50F5C6CF.50800@ti.com>
Date: Tue, 15 Jan 2013 15:14:55 -0600
From: Rob Clark <rob@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Cong Ding <dinggnu@gmail.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Seung-Woo Kim <sw0312.kim@samsung.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        YAMANE Toshiaki <yamanetoshi@gmail.com>, <devel@driverdev.osuosl.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] staging: omapdrm/omap_gem_dmabuf.c: fix memory leakage
References: <1358279214-4820-1-git-send-email-dinggnu@gmail.com>
In-Reply-To: <1358279214-4820-1-git-send-email-dinggnu@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/15/2013 01:46 PM, Cong Ding wrote:
> There is a memory leakage in variable sg if it goes to error.
>
> Signed-off-by: Cong Ding <dinggnu@gmail.com>

Signed-off-by: Rob Clark <rob@ti.com>

> ---
>   drivers/staging/omapdrm/omap_gem_dmabuf.c |    6 +++---
>   1 file changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/staging/omapdrm/omap_gem_dmabuf.c b/drivers/staging/omapdrm/omap_gem_dmabuf.c
> index b6c5b5c..a3236ab 100644
> --- a/drivers/staging/omapdrm/omap_gem_dmabuf.c
> +++ b/drivers/staging/omapdrm/omap_gem_dmabuf.c
> @@ -53,10 +53,10 @@ static struct sg_table *omap_gem_map_dma_buf(
>   	/* this should be after _get_paddr() to ensure we have pages attached */
>   	omap_gem_dma_sync(obj, dir);
>   
> -out:
> -	if (ret)
> -		return ERR_PTR(ret);
>   	return sg;
> +out:
> +	kfree(sg);
> +	return ERR_PTR(ret);
>   }
>   
>   static void omap_gem_unmap_dma_buf(struct dma_buf_attachment *attachment,

