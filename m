Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754628Ab3EMOrZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 10:47:25 -0400
Received: from mail-vc0-f173.google.com ([209.85.220.173]:54224 "EHLO
	mail-vc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752513Ab3EMOrY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 10:47:24 -0400
MIME-Version: 1.0
In-Reply-To: <20130513050051.GA32019@www.outflux.net>
References: <20130513050051.GA32019@www.outflux.net>
Date: Mon, 13 May 2013 10:47:23 -0400
Message-ID: <CADnq5_PUcuUHj_mzfGNxyo4RiqJnTBg1VdHBJObJVq9AejcJsQ@mail.gmail.com>
Subject: Re: [RESEND][PATCH] drm/radeon: check incoming cliprects pointer
From: Alex Deucher <alexdeucher@gmail.com>
To: Kees Cook <keescook@chromium.org>
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        David Howells <dhowells@redhat.com>, Dave Jones <davej@redhat.com>,
        Dave Airlie <airlied@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 13, 2013 at 1:00 AM, Kees Cook <keescook@chromium.org> wrote:
> The "boxes" parameter points into userspace memory. It should be verified
> like any other operation against user memory.
>
> Signed-off-by: Kees Cook <keescook@chromium.org>
> Cc: stable@vger.kernel.org

Thanks.  Applied.

Alex

> ---
>  drivers/gpu/drm/radeon/r300_cmdbuf.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/gpu/drm/radeon/r300_cmdbuf.c b/drivers/gpu/drm/radeon/r300_cmdbuf.c
> index 865e2c9..60170ea 100644
> --- a/drivers/gpu/drm/radeon/r300_cmdbuf.c
> +++ b/drivers/gpu/drm/radeon/r300_cmdbuf.c
> @@ -75,7 +75,7 @@ static int r300_emit_cliprects(drm_radeon_private_t *dev_priv,
>                 OUT_RING(CP_PACKET0(R300_RE_CLIPRECT_TL_0, nr * 2 - 1));
>
>                 for (i = 0; i < nr; ++i) {
> -                       if (DRM_COPY_FROM_USER_UNCHECKED
> +                       if (DRM_COPY_FROM_USER
>                             (&box, &cmdbuf->boxes[n + i], sizeof(box))) {
>                                 DRM_ERROR("copy cliprect faulted\n");
>                                 return -EFAULT;
> --
> 1.7.9.5
>
>
> --
> Kees Cook
> Chrome OS Security
> _______________________________________________
> dri-devel mailing list
> dri-devel@lists.freedesktop.org
> http://lists.freedesktop.org/mailman/listinfo/dri-devel
