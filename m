Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754268AbbANTqV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 14:46:21 -0500
Received: from mail-ie0-f179.google.com ([209.85.223.179]:64085 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753186AbbANTqR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 14:46:17 -0500
MIME-Version: 1.0
X-Originating-IP: [130.216.30.134]
In-Reply-To: <1421125937-27394-1-git-send-email-linux@roeck-us.net>
References: <1421125937-27394-1-git-send-email-linux@roeck-us.net>
Date: Wed, 14 Jan 2015 20:46:16 +0100
X-Google-Sender-Auth: hM_SJBatMlG6uoc_AjlTLpf64uc
Message-ID: <CAKMK7uFbky9q5os_k8xu8vJE7vC0XMWPt9Q5ZDaqzSgd6Rh62Q@mail.gmail.com>
Subject: Re: [PATCH] next: drm/atomic: Use copy_from_user to copy 64 bit data
 from user space
From: Daniel Vetter <daniel@ffwll.ch>
To: Guenter Roeck <linux@roeck-us.net>
Cc: David Airlie <airlied@linux.ie>, linux-next <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        dri-devel <dri-devel@lists.freedesktop.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 12, 2015 at 09:12:17PM -0800, Guenter Roeck wrote:
> Copying 64 bit data from user space using get_user is not supported
> on all architectures, and may result in the following build error.
>
> ERROR: "__get_user_bad" [drivers/gpu/drm/drm.ko] undefined!
>
> Avoid the problem by using copy_from_user.
>
> Fixes: d34f20d6e2f2 ("drm: Atomic modeset ioctl")
> Cc: Rob Clark <robdclark@gmail.com>
> Signed-off-by: Guenter Roeck <linux@roeck-us.net>

Merged into my drm misc branch, thanks.
-Daniel

> ---
> Compile tested only.
>
>  drivers/gpu/drm/drm_atomic.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/gpu/drm/drm_atomic.c b/drivers/gpu/drm/drm_atomic.c
> index 1e38dfc..af3f3df 100644
> --- a/drivers/gpu/drm/drm_atomic.c
> +++ b/drivers/gpu/drm/drm_atomic.c
> @@ -1259,7 +1259,9 @@ retry:
>   goto fail;
>   }
>
> - if (get_user(prop_value, prop_values_ptr + copied_props)) {
> + if (copy_from_user(&prop_value,
> +   prop_values_ptr + copied_props,
> +   sizeof(prop_value))) {
>   ret = -EFAULT;
>   goto fail;
>   }
> --
> 2.1.0
>
> _______________________________________________
> dri-devel mailing list
> dri-devel@lists.freedesktop.org
> http://lists.freedesktop.org/mailman/listinfo/dri-devel

-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
