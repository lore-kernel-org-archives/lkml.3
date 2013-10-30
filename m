Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752808Ab3J3HtI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 03:49:08 -0400
Received: from mail-ie0-f170.google.com ([209.85.223.170]:55329 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751470Ab3J3HtG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 03:49:06 -0400
MIME-Version: 1.0
In-Reply-To: <1380725919-1961-2-git-send-email-dh.herrmann@gmail.com>
References: <1380725919-1961-1-git-send-email-dh.herrmann@gmail.com>
	<1380725919-1961-2-git-send-email-dh.herrmann@gmail.com>
Date: Wed, 30 Oct 2013 08:49:05 +0100
Message-ID: <CANq1E4SRWsKf4uqF01Rju-uSNF-gj9zL9_+0zAqsgPMjv8Q3Uw@mail.gmail.com>
Subject: Re: [PATCH 2/2] simplefb: use write-combined remapping
From: David Herrmann <dh.herrmann@gmail.com>
To: Tomi Valkeinen <tomi.valkeinen@ti.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, Tom Gundersen <teg@jklm.no>,
        Alexandre Courbot <acourbot@nvidia.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        David Herrmann <dh.herrmann@gmail.com>,
        "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tomi

Ping?

Thanks
David

On Wed, Oct 2, 2013 at 4:58 PM, David Herrmann <dh.herrmann@gmail.com> wrote:
> Framebuffers shouldn't be cached and it is usually very uncommon to read
> them. Therefore, use ioremap_wc() to get significant speed improvements on
> systems which provide it. On all other systems it's aliased to
> ioremap_nocache() which is also fine.
>
> Reported-by: Tom Gundersen <teg@jklm.no>
> Signed-off-by: David Herrmann <dh.herrmann@gmail.com>
> Tested-by: Tom Gundersen <teg@jklm.no>
> Tested-by: Alexandre Courbot <acourbot@nvidia.com>
> Tested-by: Stephen Warren <swarren@wwwdotorg.org>
> ---
>  drivers/video/simplefb.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/video/simplefb.c b/drivers/video/simplefb.c
> index 74b016c..64db54a 100644
> --- a/drivers/video/simplefb.c
> +++ b/drivers/video/simplefb.c
> @@ -219,8 +219,8 @@ static int simplefb_probe(struct platform_device *pdev)
>
>         info->fbops = &simplefb_ops;
>         info->flags = FBINFO_DEFAULT | FBINFO_MISC_FIRMWARE;
> -       info->screen_base = ioremap(info->fix.smem_start,
> -                                   info->fix.smem_len);
> +       info->screen_base = ioremap_wc(info->fix.smem_start,
> +                                      info->fix.smem_len);
>         if (!info->screen_base) {
>                 framebuffer_release(info);
>                 return -ENODEV;
> --
> 1.8.4
>
