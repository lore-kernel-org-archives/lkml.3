Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753544AbaILI2O (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 04:28:14 -0400
Received: from mail-ie0-f176.google.com ([209.85.223.176]:38777 "EHLO
	mail-ie0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752237AbaILI2L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 04:28:11 -0400
MIME-Version: 1.0
In-Reply-To: <20140911205354.GA2959@www.outflux.net>
References: <20140911205354.GA2959@www.outflux.net>
Date: Fri, 12 Sep 2014 10:28:11 +0200
Message-ID: <CANq1E4Q7mSFyj0chxjH1=wE+ZOL4_WKDwzkvm0GPGunYAfTmBQ@mail.gmail.com>
Subject: Re: [PATCH] drm/ttm: make sure format string cannot leak in
From: David Herrmann <dh.herrmann@gmail.com>
To: Kees Cook <keescook@chromium.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        David Airlie <airlied@linux.ie>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

On Thu, Sep 11, 2014 at 10:53 PM, Kees Cook <keescook@chromium.org> wrote:
> While zone->name is currently hard coded, the call to kobject_init_and_add()
> should follow the more defensive argument list usage (as already done in
> other places in ttm_memory.c) where "%s" is used instead of directly passing
> in a variable as a format string.
>
> Signed-off-by: Kees Cook <keescook@chromium.org>

Reviewed-by: David Herrmann <dh.herrmann@gmail.com>

Thanks
David

> ---
>  drivers/gpu/drm/ttm/ttm_memory.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/gpu/drm/ttm/ttm_memory.c b/drivers/gpu/drm/ttm/ttm_memory.c
> index fa53df487875..1e688b603e46 100644
> --- a/drivers/gpu/drm/ttm/ttm_memory.c
> +++ b/drivers/gpu/drm/ttm/ttm_memory.c
> @@ -300,7 +300,8 @@ static int ttm_mem_init_highmem_zone(struct ttm_mem_global *glob,
>         zone->glob = glob;
>         glob->zone_highmem = zone;
>         ret = kobject_init_and_add(
> -               &zone->kobj, &ttm_mem_zone_kobj_type, &glob->kobj, zone->name);
> +               &zone->kobj, &ttm_mem_zone_kobj_type, &glob->kobj, "%s",
> +               zone->name);
>         if (unlikely(ret != 0)) {
>                 kobject_put(&zone->kobj);
>                 return ret;
> --
> 1.9.1
>
>
> --
> Kees Cook
> Chrome OS Security
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
