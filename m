Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756307AbaFRXYh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 19:24:37 -0400
Received: from mx3-phx2.redhat.com ([209.132.183.24]:60985 "EHLO
	mx3-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752960AbaFRXYg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 19:24:36 -0400
Date: Wed, 18 Jun 2014 19:24:30 -0400 (EDT)
From: Ben Skeggs <bskeggs@redhat.com>
To: Heinrich Schuchardt <xypron.glpk@gmx.de>
Cc: David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Message-ID: <1687970626.38938809.1403133870580.JavaMail.zimbra@redhat.com>
In-Reply-To: <1403121467-27309-1-git-send-email-xypron.glpk@gmx.de>
References: <1403121467-27309-1-git-send-email-xypron.glpk@gmx.de>
Subject: Re: [PATCH] drm/nouveau: avoid memory leak
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.5.82.11]
X-Mailer: Zimbra 8.0.6_GA_5922 (ZimbraWebClient - GC35 (Linux)/8.0.6_GA_5922)
Thread-Topic: drm/nouveau: avoid memory leak
Thread-Index: Tas2l8ZD5RV+xooA2uuIsHcdMgEPbQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

----- Original Message -----
> From: "Heinrich Schuchardt" <xypron.glpk@gmx.de>
> To: "David Airlie" <airlied@linux.ie>
> Cc: "Ben Skeggs" <bskeggs@redhat.com>, dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org, "Heinrich
> Schuchardt" <xypron.glpk@gmx.de>
> Sent: Thursday, 19 June, 2014 5:57:47 AM
> Subject: [PATCH] drm/nouveau: avoid memory leak
> 
> If ttm_dma_tt_init fails memory is leaked.
No, it's not.  TTM calls the destroy function itself on failure.

Thanks,
Ben.
> 
> Signed-off-by: Heinrich Schuchardt <xypron.glpk@gmx.de>
> ---
>  drivers/gpu/drm/nouveau/nouveau_sgdma.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/gpu/drm/nouveau/nouveau_sgdma.c
> b/drivers/gpu/drm/nouveau/nouveau_sgdma.c
> index a4d22e5..23d880b 100644
> --- a/drivers/gpu/drm/nouveau/nouveau_sgdma.c
> +++ b/drivers/gpu/drm/nouveau/nouveau_sgdma.c
> @@ -109,7 +109,9 @@ nouveau_sgdma_create_ttm(struct ttm_bo_device *bdev,
>  	else
>  		nvbe->ttm.ttm.func = &nv50_sgdma_backend;
>  
> -	if (ttm_dma_tt_init(&nvbe->ttm, bdev, size, page_flags, dummy_read_page))
> +	if (ttm_dma_tt_init(&nvbe->ttm, bdev, size, page_flags, dummy_read_page)) {
> +		kfree(nvbe);
>  		return NULL;
> +	}
>  	return &nvbe->ttm.ttm;
>  }
> --
> 2.0.0
> 
> 
