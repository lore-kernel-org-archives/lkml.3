Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751162AbaGFKzh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jul 2014 06:55:37 -0400
Received: from mail-ie0-f178.google.com ([209.85.223.178]:58040 "EHLO
	mail-ie0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750906AbaGFKzg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jul 2014 06:55:36 -0400
MIME-Version: 1.0
In-Reply-To: <1404501435-22838-1-git-send-email-fabf@skynet.be>
References: <1404501435-22838-1-git-send-email-fabf@skynet.be>
Date: Sun, 6 Jul 2014 12:55:35 +0200
Message-ID: <CANq1E4SAJ+M3bQyiBAzXWY4wgukbjgRmXexAFJUQC6-Mi+0Ziw@mail.gmail.com>
Subject: Re: [PATCH 1/1] drm/omap: remove null test before kfree
From: David Herrmann <dh.herrmann@gmail.com>
To: Fabian Frederick <fabf@skynet.be>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        David Airlie <airlied@linux.ie>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

On Fri, Jul 4, 2014 at 9:17 PM, Fabian Frederick <fabf@skynet.be> wrote:
> Fix checkpatch warning:
> WARNING: kfree(NULL) is safe this check is probably not required
>
> Cc: David Airlie <airlied@linux.ie>
> Cc: David Herrmann <dh.herrmann@gmail.com>
> Cc: Tomi Valkeinen <tomi.valkeinen@ti.com>
> Cc: dri-devel@lists.freedesktop.org
> Signed-off-by: Fabian Frederick <fabf@skynet.be>

Reviewed-by: David Herrmann <dh.herrmann@gmail.com>

Thanks
David

> ---
>  drivers/gpu/drm/omapdrm/omap_gem.c | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
>
> diff --git a/drivers/gpu/drm/omapdrm/omap_gem.c b/drivers/gpu/drm/omapdrm/omap_gem.c
> index 95dbce2..be0c2e8 100644
> --- a/drivers/gpu/drm/omapdrm/omap_gem.c
> +++ b/drivers/gpu/drm/omapdrm/omap_gem.c
> @@ -1183,9 +1183,7 @@ int omap_gem_op_sync(struct drm_gem_object *obj, enum omap_gem_op op)
>                         }
>                 }
>                 spin_unlock(&sync_lock);
> -
> -               if (waiter)
> -                       kfree(waiter);
> +               kfree(waiter);
>         }
>         return ret;
>  }
> --
> 1.9.1
>
