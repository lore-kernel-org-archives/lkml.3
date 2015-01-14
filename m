Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754532AbbANVns (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 16:43:48 -0500
Received: from mail-qc0-f175.google.com ([209.85.216.175]:57150 "EHLO
	mail-qc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752018AbbANVnr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 16:43:47 -0500
MIME-Version: 1.0
In-Reply-To: <1420982239-16892-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
References: <1420982239-16892-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
Date: Wed, 14 Jan 2015 16:43:46 -0500
Message-ID: <CADnq5_O0eJmMD+c4QqsfNh4gG+K5nqHjnY6V0r-qyS++-1OOwQ@mail.gmail.com>
Subject: Re: [PATCH] gpu: drm: radeon: radeon_object: Remove unused function
From: Alex Deucher <alexdeucher@gmail.com>
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Cc: Alex Deucher <alexander.deucher@amd.com>,
        =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Maling list - DRI developers 
	<dri-devel@lists.freedesktop.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 11, 2015 at 8:17 AM, Rickard Strandqvist
<rickard_strandqvist@spectrumdigital.se> wrote:
> Remove the function radeon_bo_fbdev_mmap() that is not used anywhere.
>
> This was partially found by using a static code analysis program called cppcheck.
>
> Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>

Applied.  thanks!

Alex

> ---
>  drivers/gpu/drm/radeon/radeon_object.c |    6 ------
>  drivers/gpu/drm/radeon/radeon_object.h |    2 --
>  2 files changed, 8 deletions(-)
>
> diff --git a/drivers/gpu/drm/radeon/radeon_object.c b/drivers/gpu/drm/radeon/radeon_object.c
> index 99a960a..4f2515f 100644
> --- a/drivers/gpu/drm/radeon/radeon_object.c
> +++ b/drivers/gpu/drm/radeon/radeon_object.c
> @@ -542,12 +542,6 @@ int radeon_bo_list_validate(struct radeon_device *rdev,
>         return 0;
>  }
>
> -int radeon_bo_fbdev_mmap(struct radeon_bo *bo,
> -                            struct vm_area_struct *vma)
> -{
> -       return ttm_fbdev_mmap(vma, &bo->tbo);
> -}
> -
>  int radeon_bo_get_surface_reg(struct radeon_bo *bo)
>  {
>         struct radeon_device *rdev = bo->rdev;
> diff --git a/drivers/gpu/drm/radeon/radeon_object.h b/drivers/gpu/drm/radeon/radeon_object.h
> index 1b8ec79..1cf3cd9 100644
> --- a/drivers/gpu/drm/radeon/radeon_object.h
> +++ b/drivers/gpu/drm/radeon/radeon_object.h
> @@ -143,8 +143,6 @@ extern void radeon_bo_fini(struct radeon_device *rdev);
>  extern int radeon_bo_list_validate(struct radeon_device *rdev,
>                                    struct ww_acquire_ctx *ticket,
>                                    struct list_head *head, int ring);
> -extern int radeon_bo_fbdev_mmap(struct radeon_bo *bo,
> -                               struct vm_area_struct *vma);
>  extern int radeon_bo_set_tiling_flags(struct radeon_bo *bo,
>                                 u32 tiling_flags, u32 pitch);
>  extern void radeon_bo_get_tiling_flags(struct radeon_bo *bo,
> --
> 1.7.10.4
>
> _______________________________________________
> dri-devel mailing list
> dri-devel@lists.freedesktop.org
> http://lists.freedesktop.org/mailman/listinfo/dri-devel
