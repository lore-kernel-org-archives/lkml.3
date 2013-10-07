Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753531Ab3JGWfh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 18:35:37 -0400
Received: from mx4-phx2.redhat.com ([209.132.183.25]:60633 "EHLO
	mx4-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751885Ab3JGWfe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 18:35:34 -0400
Date: Mon, 7 Oct 2013 18:35:29 -0400 (EDT)
From: Ben Skeggs <bskeggs@redhat.com>
To: "Geyslan G. Bem" <geyslan@gmail.com>
Cc: airlied@linux.ie, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, kernel-br@googlegroups.com
Message-ID: <184520834.2485938.1381185329449.JavaMail.root@redhat.com>
In-Reply-To: <1381184066-10684-1-git-send-email-geyslan@gmail.com>
References: <1381184066-10684-1-git-send-email-geyslan@gmail.com>
Subject: Re: [PATCH] drm: nouveau: fix nvbe leakage
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.5.82.12]
X-Mailer: Zimbra 8.0.3_GA_5664 (ZimbraWebClient - GC30 (Linux)/8.0.3_GA_5664)
Thread-Topic: nouveau: fix nvbe leakage
Thread-Index: oupux8cuag6WQQoHVNwmJaNjFliotA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

----- Original Message -----
> From: "Geyslan G. Bem" <geyslan@gmail.com>
> To: airlied@linux.ie, bskeggs@redhat.com, dri-devel@lists.freedesktop.org
> Cc: linux-kernel@vger.kernel.org, kernel-br@googlegroups.com, "Geyslan G. Bem" <geyslan@gmail.com>
> Sent: Tuesday, 8 October, 2013 8:14:26 AM
> Subject: [PATCH] drm: nouveau: fix nvbe leakage
> 
> Free memory allocated to nvbe when returning NULL.
> 
> Signed-off-by: Geyslan G. Bem <geyslan@gmail.com>
NACK.  ttm_dma_tt_init() calls the destructor if it fails, which frees the memory.

Ben.

> ---
>  drivers/gpu/drm/nouveau/nouveau_sgdma.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/drivers/gpu/drm/nouveau/nouveau_sgdma.c
> b/drivers/gpu/drm/nouveau/nouveau_sgdma.c
> index 0843ebc..af8b66d 100644
> --- a/drivers/gpu/drm/nouveau/nouveau_sgdma.c
> +++ b/drivers/gpu/drm/nouveau/nouveau_sgdma.c
> @@ -105,6 +105,9 @@ nouveau_sgdma_create_ttm(struct ttm_bo_device *bdev,
>  		nvbe->ttm.ttm.func = &nv50_sgdma_backend;
>  
>  	if (ttm_dma_tt_init(&nvbe->ttm, bdev, size, page_flags, dummy_read_page))
> +	{
> +		kfree(nvbe);
>  		return NULL;
> +	}
>  	return &nvbe->ttm.ttm;
>  }
> --
> 1.8.4
> 
> 
