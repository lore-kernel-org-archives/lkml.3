Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751690AbaAGQTi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 11:19:38 -0500
Received: from mail-ve0-f171.google.com ([209.85.128.171]:44579 "EHLO
	mail-ve0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751041AbaAGQTf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 11:19:35 -0500
MIME-Version: 1.0
In-Reply-To: <4218b28ed65d616abc33aaf6fcc2424a3b14b03b.1389018325.git.rashika.kheria@gmail.com>
References: <b21c9d47bbb72f2134540b852c908a2080f1ed1d.1389018324.git.rashika.kheria@gmail.com>
	<4218b28ed65d616abc33aaf6fcc2424a3b14b03b.1389018325.git.rashika.kheria@gmail.com>
Date: Tue, 7 Jan 2014 11:19:34 -0500
Message-ID: <CADnq5_PSH4rMN5AFYzgw3rz83=PC9hADP9HbFERoVrnSrMA0ww@mail.gmail.com>
Subject: Re: [PATCH 76/85] drivers: gpu: Move prototype declaration to header
 file radeon_drv.h from radeon_drv.c
From: Alex Deucher <alexdeucher@gmail.com>
To: Rashika Kheria <rashika.kheria@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Josh Triplett <josh@joshtriplett.org>,
        Maling list - DRI developers 
	<dri-devel@lists.freedesktop.org>,
        Alex Deucher <alexander.deucher@amd.com>,
        Dave Airlie <airlied@redhat.com>,
        =?ISO-8859-1?Q?Christian_K=F6nig?= <christian.koenig@amd.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 6, 2014 at 11:41 AM, Rashika Kheria
<rashika.kheria@gmail.com> wrote:
> Move prototype declaration of function radeon_kms_compat_ioctl() to
> header file drm/radeon/radeon_drv.h because it is used by more than one
> file.
>
> This eliminates the following warning in
> drivers/gpu/drm/radeon/radeon_ioc32.c:413:6: warning: no previous prototype for ‘radeon_kms_compat_ioctl’ [-Wmissing-prototypes]
>
> Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
> Reviewed-by: Josh Triplett <josh@joshtriplett.org>
> ---
>  drivers/gpu/drm/radeon/radeon_drv.c |    2 --
>  drivers/gpu/drm/radeon/radeon_drv.h |    3 ++-
>  2 files changed, 2 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/gpu/drm/radeon/radeon_drv.c b/drivers/gpu/drm/radeon/radeon_drv.c
> index 9f5ff28..7868d4e 100644
> --- a/drivers/gpu/drm/radeon/radeon_drv.c
> +++ b/drivers/gpu/drm/radeon/radeon_drv.c
> @@ -127,8 +127,6 @@ int radeon_gem_prime_pin(struct drm_gem_object *obj);
>  void radeon_gem_prime_unpin(struct drm_gem_object *obj);
>  void *radeon_gem_prime_vmap(struct drm_gem_object *obj);
>  void radeon_gem_prime_vunmap(struct drm_gem_object *obj, void *vaddr);
> -extern long radeon_kms_compat_ioctl(struct file *filp, unsigned int cmd,
> -                                   unsigned long arg);
>
>  #if defined(CONFIG_DEBUG_FS)
>  int radeon_debugfs_init(struct drm_minor *minor);
> diff --git a/drivers/gpu/drm/radeon/radeon_drv.h b/drivers/gpu/drm/radeon/radeon_drv.h
> index 00e0d44..7e1f2215 100644
> --- a/drivers/gpu/drm/radeon/radeon_drv.h
> +++ b/drivers/gpu/drm/radeon/radeon_drv.h
> @@ -425,7 +425,8 @@ extern int radeon_driver_open(struct drm_device *dev,
>                               struct drm_file *file_priv);
>  extern long radeon_compat_ioctl(struct file *filp, unsigned int cmd,
>                                 unsigned long arg);
> -
> +extern long radeon_kms_compat_ioctl(struct file *filp, unsigned int cmd,
> +                                   unsigned long arg);

This needs to be moved to the top of the file, outside of the
CONFIG_DRM_RADEON_UMS ifdef.

Alex

>  extern int radeon_master_create(struct drm_device *dev, struct drm_master *master);
>  extern void radeon_master_destroy(struct drm_device *dev, struct drm_master *master);
>  extern void radeon_cp_dispatch_flip(struct drm_device *dev, struct drm_master *master);
> --
> 1.7.9.5
>
> _______________________________________________
> dri-devel mailing list
> dri-devel@lists.freedesktop.org
> http://lists.freedesktop.org/mailman/listinfo/dri-devel
