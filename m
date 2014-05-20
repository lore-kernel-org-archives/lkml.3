Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751448AbaETXUV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 19:20:21 -0400
Received: from mail-ig0-f181.google.com ([209.85.213.181]:36260 "EHLO
	mail-ig0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751072AbaETXUU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 19:20:20 -0400
Date: Tue, 20 May 2014 17:20:16 -0600
From: Bjorn Helgaas <bhelgaas@google.com>
To: Gioh Kim <gioh.kim@lge.com>
Cc: Sumit Semwal <sumit.semwal@linaro.org>,
        Randy Dunlap <rdunlap@infradead.org>, linux-media@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, gunho.lee@lge.com
Subject: Re: [PATCH] Documentation/dma-buf-sharing.txt: update API
 descriptions
Message-ID: <20140520232016.GB24638@google.com>
References: <1400024983-21891-1-git-send-email-gioh.kim@lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1400024983-21891-1-git-send-email-gioh.kim@lge.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 14, 2014 at 08:49:43AM +0900, Gioh Kim wrote:
> Update some descriptions for API arguments and descriptions.
> 
> Signed-off-by: Gioh Kim <gioh.kim@lge.com>

I applied this to my "dma-api" branch for v3.16, thanks!

> ---
>  Documentation/dma-buf-sharing.txt |   14 ++++++++------
>  1 file changed, 8 insertions(+), 6 deletions(-)
> 
> diff --git a/Documentation/dma-buf-sharing.txt b/Documentation/dma-buf-sharing.txt
> index 505e711..aadd901 100644
> --- a/Documentation/dma-buf-sharing.txt
> +++ b/Documentation/dma-buf-sharing.txt
> @@ -56,10 +56,10 @@ The dma_buf buffer sharing API usage contains the following steps:
>  				     size_t size, int flags,
>  				     const char *exp_name)
>  
> -   If this succeeds, dma_buf_export allocates a dma_buf structure, and returns a
> -   pointer to the same. It also associates an anonymous file with this buffer,
> -   so it can be exported. On failure to allocate the dma_buf object, it returns
> -   NULL.
> +   If this succeeds, dma_buf_export_named allocates a dma_buf structure, and
> +   returns a pointer to the same. It also associates an anonymous file with this
> +   buffer, so it can be exported. On failure to allocate the dma_buf object,
> +   it returns NULL.
>  
>     'exp_name' is the name of exporter - to facilitate information while
>     debugging.
> @@ -76,7 +76,7 @@ The dma_buf buffer sharing API usage contains the following steps:
>     drivers and/or processes.
>  
>     Interface:
> -      int dma_buf_fd(struct dma_buf *dmabuf)
> +      int dma_buf_fd(struct dma_buf *dmabuf, int flags)
>  
>     This API installs an fd for the anonymous file associated with this buffer;
>     returns either 'fd', or error.
> @@ -157,7 +157,9 @@ to request use of buffer for allocation.
>     "dma_buf->ops->" indirection from the users of this interface.
>  
>     In struct dma_buf_ops, unmap_dma_buf is defined as
> -      void (*unmap_dma_buf)(struct dma_buf_attachment *, struct sg_table *);
> +      void (*unmap_dma_buf)(struct dma_buf_attachment *,
> +                            struct sg_table *,
> +                            enum dma_data_direction);
>  
>     unmap_dma_buf signifies the end-of-DMA for the attachment provided. Like
>     map_dma_buf, this API also must be implemented by the exporter.
> -- 
> 1.7.9.5
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
