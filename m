Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755057AbaDKHkL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 03:40:11 -0400
Received: from mail-qa0-f53.google.com ([209.85.216.53]:37286 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754264AbaDKHkI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 03:40:08 -0400
MIME-Version: 1.0
In-Reply-To: <1397072012-9475-1-git-send-email-andreas.noever@gmail.com>
References: <1397072012-9475-1-git-send-email-andreas.noever@gmail.com>
Date: Fri, 11 Apr 2014 17:40:07 +1000
Message-ID: <CACAvsv7K9bDZsBF1XHESuXfX0syyW-mB8Jj-kQs8rteuh2q0cw@mail.gmail.com>
Subject: Re: [PATCH] drm/nouveau/bios: fix bug introduced in 457e77b2
From: Ben Skeggs <skeggsb@gmail.com>
To: Andreas Noever <andreas.noever@gmail.com>
Cc: "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ben Skeggs <bskeggs@redhat.com>, stable@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 10, 2014 at 5:33 AM, Andreas Noever
<andreas.noever@gmail.com> wrote:
> 457e77b2 effectively replaces (... & 0xffffff00) << 8 with (... >> 8) << 8.
> Which does not do the same and breaks boot on my machine.
>
> Restore the old behaviour and remove the unnecessary cast.
>
> Signed-off-by: Andreas Noever <andreas.noever@gmail.com>
Signed-off-by: Ben Skeggs <bskeggs@redhat.com>

> ---
>  drivers/gpu/drm/nouveau/core/subdev/bios/base.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/gpu/drm/nouveau/core/subdev/bios/base.c b/drivers/gpu/drm/nouveau/core/subdev/bios/base.c
> index e9df94f..2885b7c 100644
> --- a/drivers/gpu/drm/nouveau/core/subdev/bios/base.c
> +++ b/drivers/gpu/drm/nouveau/core/subdev/bios/base.c
> @@ -109,7 +109,7 @@ nouveau_bios_shadow_pramin(struct nouveau_bios *bios)
>                         return;
>                 }
>
> -               addr = (u64)(addr >> 8) << 8;
> +               addr = (addr >> 8) << 16;
>                 if (!addr) {
>                         addr  = (u64)nv_rd32(bios, 0x001700) << 16;
>                         addr += 0xf0000;
> --
> 1.9.1
>
> _______________________________________________
> dri-devel mailing list
> dri-devel@lists.freedesktop.org
> http://lists.freedesktop.org/mailman/listinfo/dri-devel
