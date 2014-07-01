Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932363AbaGAUeq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 16:34:46 -0400
Received: from mail-ie0-f169.google.com ([209.85.223.169]:51505 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754676AbaGAUeo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 16:34:44 -0400
MIME-Version: 1.0
In-Reply-To: <1404241323-15156-1-git-send-email-fabf@skynet.be>
References: <1404241323-15156-1-git-send-email-fabf@skynet.be>
Date: Tue, 1 Jul 2014 22:34:44 +0200
Message-ID: <CANq1E4SDa5hK1QoW-7U64Jwu6RzFxazkXFx6ex26+Y3ihGnZHg@mail.gmail.com>
Subject: Re: [PATCH 1/1] drm/bochs: replace ALIGN(PAGE_SIZE) by PAGE_ALIGN
From: David Herrmann <dh.herrmann@gmail.com>
To: Fabian Frederick <fabf@skynet.be>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        David Airlie <airlied@linux.ie>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

On Tue, Jul 1, 2014 at 9:02 PM, Fabian Frederick <fabf@skynet.be> wrote:
> use mm.h definition
>
> Cc: David Airlie <airlied@linux.ie>
> Cc: David Herrmann <dh.herrmann@gmail.com>
> Cc: dri-devel@lists.freedesktop.org
> Signed-off-by: Fabian Frederick <fabf@skynet.be>

Hm, this is defined in mm.h and we include it via drmP.h, which is
weird, but ok.

Reviewed-by: David Herrmann <dh.herrmann@gmail.com>

Thanks
David

> ---
>  drivers/gpu/drm/bochs/bochs_mm.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/gpu/drm/bochs/bochs_mm.c b/drivers/gpu/drm/bochs/bochs_mm.c
> index b9a695d..1728a1b 100644
> --- a/drivers/gpu/drm/bochs/bochs_mm.c
> +++ b/drivers/gpu/drm/bochs/bochs_mm.c
> @@ -387,7 +387,7 @@ int bochs_gem_create(struct drm_device *dev, u32 size, bool iskernel,
>
>         *obj = NULL;
>
> -       size = ALIGN(size, PAGE_SIZE);
> +       size = PAGE_ALIGN(size);
>         if (size == 0)
>                 return -EINVAL;
>
> --
> 1.9.1
>
