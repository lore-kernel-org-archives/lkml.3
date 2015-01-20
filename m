Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753040AbbATNvZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 08:51:25 -0500
Received: from mail-ie0-f169.google.com ([209.85.223.169]:52122 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752294AbbATNvY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 08:51:24 -0500
MIME-Version: 1.0
In-Reply-To: <1421750935-4023-3-git-send-email-thierry.reding@gmail.com>
References: <1421750935-4023-1-git-send-email-thierry.reding@gmail.com>
	<1421750935-4023-3-git-send-email-thierry.reding@gmail.com>
Date: Tue, 20 Jan 2015 08:51:15 -0500
Message-ID: <CAF6AEGvObX_YBvw7f+SytnBokpdQopom-sWGoxaPG2k+g1YjTA@mail.gmail.com>
Subject: Re: [PATCH 02/36] drm/plane: Make ->atomic_update() mandatory
From: Rob Clark <robdclark@gmail.com>
To: Thierry Reding <thierry.reding@gmail.com>
Cc: "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 20, 2015 at 5:48 AM, Thierry Reding
<thierry.reding@gmail.com> wrote:
> From: Thierry Reding <treding@nvidia.com>
>
> There is no use-case where it would be useful for drivers not to
> implement this function and the transitional plane helpers already
> require drivers to provide an implementation.
>
> Signed-off-by: Thierry Reding <treding@nvidia.com>
> ---
>  drivers/gpu/drm/drm_atomic_helper.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/gpu/drm/drm_atomic_helper.c b/drivers/gpu/drm/drm_atomic_helper.c
> index d467185f7942..010661f23035 100644
> --- a/drivers/gpu/drm/drm_atomic_helper.c
> +++ b/drivers/gpu/drm/drm_atomic_helper.c
> @@ -1108,7 +1108,7 @@ void drm_atomic_helper_commit_planes(struct drm_device *dev,
>
>                 funcs = plane->helper_private;
>
> -               if (!funcs || !funcs->atomic_update)
> +               if (!funcs)

maybe WARN_ON() here.. or drm_universal_plane_init(), or somewhere,
for missing mandatory fxns would be a nice thing to avoid explosions
under console_lock for first modeset?

BR,
-R

>                         continue;
>
>                 old_plane_state = old_state->plane_states[i];
> --
> 2.1.3
>
> _______________________________________________
> dri-devel mailing list
> dri-devel@lists.freedesktop.org
> http://lists.freedesktop.org/mailman/listinfo/dri-devel
