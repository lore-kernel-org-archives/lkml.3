Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751477AbaEYMFT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 May 2014 08:05:19 -0400
Received: from mail-ie0-f173.google.com ([209.85.223.173]:65387 "EHLO
	mail-ie0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751377AbaEYMFR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 May 2014 08:05:17 -0400
MIME-Version: 1.0
In-Reply-To: <1400817487-27179-2-git-send-email-acourbot@nvidia.com>
References: <1400817487-27179-1-git-send-email-acourbot@nvidia.com>
	<1400817487-27179-2-git-send-email-acourbot@nvidia.com>
Date: Sun, 25 May 2014 14:05:17 +0200
Message-ID: <CANq1E4TCLg_aEFx8FQOFk4N4DpNEJoQKPR5L4hXKsXf30J7V2A@mail.gmail.com>
Subject: Re: [PATCH RESEND] drm/ttm: remove declaration of ttm_tt_cache_flush
From: David Herrmann <dh.herrmann@gmail.com>
To: Alexandre Courbot <acourbot@nvidia.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Dave Airlie <airlied@gmail.com>, Alexandre Courbot <gnurou@gmail.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

On Fri, May 23, 2014 at 5:58 AM, Alexandre Courbot <acourbot@nvidia.com> wrote:
> ttm_tt_cache_flush's implementation was removed in 2009 by commit
> c9c97b8c, but its declaration has been hiding in ttm_bo_driver.h since
> then.
>
> It has been surviving in the dark for too long now ; give it the mercy
> blow.
>
> Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
> Reviewed-by: Thierry Reding <treding@nvidia.com>

Reviewed-by: David Herrmann <dh.herrmann@gmail.com>

Thanks
David

> ---
>  include/drm/ttm/ttm_bo_driver.h | 12 ------------
>  1 file changed, 12 deletions(-)
>
> diff --git a/include/drm/ttm/ttm_bo_driver.h b/include/drm/ttm/ttm_bo_driver.h
> index a5183da3ef92..e3f8c99a8a9d 100644
> --- a/include/drm/ttm/ttm_bo_driver.h
> +++ b/include/drm/ttm/ttm_bo_driver.h
> @@ -653,18 +653,6 @@ extern void ttm_tt_unbind(struct ttm_tt *ttm);
>  extern int ttm_tt_swapin(struct ttm_tt *ttm);
>
>  /**
> - * ttm_tt_cache_flush:
> - *
> - * @pages: An array of pointers to struct page:s to flush.
> - * @num_pages: Number of pages to flush.
> - *
> - * Flush the data of the indicated pages from the cpu caches.
> - * This is used when changing caching attributes of the pages from
> - * cache-coherent.
> - */
> -extern void ttm_tt_cache_flush(struct page *pages[], unsigned long num_pages);
> -
> -/**
>   * ttm_tt_set_placement_caching:
>   *
>   * @ttm A struct ttm_tt the backing pages of which will change caching policy.
> --
> 1.9.2
>
> _______________________________________________
> dri-devel mailing list
> dri-devel@lists.freedesktop.org
> http://lists.freedesktop.org/mailman/listinfo/dri-devel
