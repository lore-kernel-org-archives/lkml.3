Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753766AbbANVoy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 16:44:54 -0500
Received: from mail-qa0-f44.google.com ([209.85.216.44]:52881 "EHLO
	mail-qa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751975AbbANVox (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 16:44:53 -0500
MIME-Version: 1.0
In-Reply-To: <1421175723-6893-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
References: <1421175723-6893-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
Date: Wed, 14 Jan 2015 16:44:52 -0500
Message-ID: <CADnq5_O=bgffFv6xNxFMvgEOz+oMhiuN3=a9Zj-+7SnYr-FRWg@mail.gmail.com>
Subject: Re: [PATCH] drm/radeon/radeon_fb: Remove unused function
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

On Tue, Jan 13, 2015 at 2:02 PM, Rickard Strandqvist
<rickard_strandqvist@spectrumdigital.se> wrote:
> Remove the function radeon_fbdev_total_size() that is not used anywhere.
>
> This was partially found by using a static code analysis program called cppcheck.
>
> Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>

Applied.  thanks!

Alex

> ---
>  drivers/gpu/drm/radeon/radeon_fb.c   |   10 ----------
>  drivers/gpu/drm/radeon/radeon_mode.h |    1 -
>  2 files changed, 11 deletions(-)
>
> diff --git a/drivers/gpu/drm/radeon/radeon_fb.c b/drivers/gpu/drm/radeon/radeon_fb.c
> index 0ea1db8..76adbdb 100644
> --- a/drivers/gpu/drm/radeon/radeon_fb.c
> +++ b/drivers/gpu/drm/radeon/radeon_fb.c
> @@ -389,16 +389,6 @@ void radeon_fbdev_set_suspend(struct radeon_device *rdev, int state)
>         fb_set_suspend(rdev->mode_info.rfbdev->helper.fbdev, state);
>  }
>
> -int radeon_fbdev_total_size(struct radeon_device *rdev)
> -{
> -       struct radeon_bo *robj;
> -       int size = 0;
> -
> -       robj = gem_to_radeon_bo(rdev->mode_info.rfbdev->rfb.obj);
> -       size += radeon_bo_size(robj);
> -       return size;
> -}
> -
>  bool radeon_fbdev_robj_is_fb(struct radeon_device *rdev, struct radeon_bo *robj)
>  {
>         if (robj == gem_to_radeon_bo(rdev->mode_info.rfbdev->rfb.obj))
> diff --git a/drivers/gpu/drm/radeon/radeon_mode.h b/drivers/gpu/drm/radeon/radeon_mode.h
> index 04db2fd..ec2014a 100644
> --- a/drivers/gpu/drm/radeon/radeon_mode.h
> +++ b/drivers/gpu/drm/radeon/radeon_mode.h
> @@ -915,7 +915,6 @@ void dce8_program_fmt(struct drm_encoder *encoder);
>  int radeon_fbdev_init(struct radeon_device *rdev);
>  void radeon_fbdev_fini(struct radeon_device *rdev);
>  void radeon_fbdev_set_suspend(struct radeon_device *rdev, int state);
> -int radeon_fbdev_total_size(struct radeon_device *rdev);
>  bool radeon_fbdev_robj_is_fb(struct radeon_device *rdev, struct radeon_bo *robj);
>
>  void radeon_fb_output_poll_changed(struct radeon_device *rdev);
> --
> 1.7.10.4
>
> _______________________________________________
> dri-devel mailing list
> dri-devel@lists.freedesktop.org
> http://lists.freedesktop.org/mailman/listinfo/dri-devel
