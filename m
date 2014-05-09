Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757529AbaEIXtc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 19:49:32 -0400
Received: from mail-qc0-f172.google.com ([209.85.216.172]:57930 "EHLO
	mail-qc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751744AbaEIXta (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 19:49:30 -0400
MIME-Version: 1.0
In-Reply-To: <1399622268-16940-1-git-send-email-acourbot@nvidia.com>
References: <1399622268-16940-1-git-send-email-acourbot@nvidia.com>
Date: Sat, 10 May 2014 09:49:29 +1000
Message-ID: <CACAvsv7vB_xgnOESk_Oy0SmwF8kK+6gGP-+TCSNSiXzguCLB=g@mail.gmail.com>
Subject: Re: [Nouveau] [PATCH] drm/gk20a/fb: fix NULL dereference
From: Ben Skeggs <skeggsb@gmail.com>
To: Alexandre Courbot <acourbot@nvidia.com>
Cc: Ben Skeggs <bskeggs@redhat.com>,
        "nouveau@lists.freedesktop.org" <nouveau@lists.freedesktop.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 9, 2014 at 5:57 PM, Alexandre Courbot <acourbot@nvidia.com> wrote:
> gk20a_ram_put() can be called with a NULL nouveau_mem in case of error.
> Handle that case the way is it done in other RAM drivers.
Got it, thanks!

>
> Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
> ---
>  drivers/gpu/drm/nouveau/core/subdev/fb/ramgk20a.c | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/drivers/gpu/drm/nouveau/core/subdev/fb/ramgk20a.c b/drivers/gpu/drm/nouveau/core/subdev/fb/ramgk20a.c
> index 403c88f07b99..7effd1a63458 100644
> --- a/drivers/gpu/drm/nouveau/core/subdev/fb/ramgk20a.c
> +++ b/drivers/gpu/drm/nouveau/core/subdev/fb/ramgk20a.c
> @@ -36,6 +36,8 @@ gk20a_ram_put(struct nouveau_fb *pfb, struct nouveau_mem **pmem)
>         int i;
>
>         *pmem = NULL;
> +       if (unlikely(mem == NULL))
> +               return;
>
>         for (i = 0; i < mem->size; i++) {
>                 struct page *page;
> --
> 1.9.2
>
> _______________________________________________
> Nouveau mailing list
> Nouveau@lists.freedesktop.org
> http://lists.freedesktop.org/mailman/listinfo/nouveau
