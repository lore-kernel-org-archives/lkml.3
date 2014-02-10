Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752194AbaBJEZX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Feb 2014 23:25:23 -0500
Received: from mail-qa0-f48.google.com ([209.85.216.48]:40357 "EHLO
	mail-qa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751556AbaBJEZV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Feb 2014 23:25:21 -0500
MIME-Version: 1.0
In-Reply-To: <1391779377-10176-1-git-send-email-acourbot@nvidia.com>
References: <1391779377-10176-1-git-send-email-acourbot@nvidia.com>
Date: Mon, 10 Feb 2014 14:25:19 +1000
Message-ID: <CACAvsv5MQPOE+uBTXyMzjiQ514++LGKgOS7oObdRTT=VQLVRRw@mail.gmail.com>
Subject: Re: [PATCH] nouveau/drm/fifo: fix ENG_RUNLIST register address
From: Ben Skeggs <skeggsb@gmail.com>
To: Alexandre Courbot <acourbot@nvidia.com>
Cc: Ben Skeggs <bskeggs@redhat.com>,
        "nouveau@lists.freedesktop.org" <nouveau@lists.freedesktop.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 7, 2014 at 11:22 PM, Alexandre Courbot <acourbot@nvidia.com> wrote:
> Address of the ENG_RUNLIST register should be 0x002284 + (engine * 8),
> not 0x002284 + (engine * 4).
>
> Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
> ---
> Stumbled upon this one and I'm quite certain the offset was not correct.
> This is inconsequential for GK20A which only features one runlist, but
> other GPUs might run into troubles because of this. Not tested, just
> reported for your consideration.
I noticed this also while doing some other work I haven't committed
yet.  I'll push this patch ahead of that other work though.

Thanks,
Ben.

>
> FWIW, the Android GK20A driver uses the same offset calculation.
>
>  drivers/gpu/drm/nouveau/core/engine/fifo/nve0.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/gpu/drm/nouveau/core/engine/fifo/nve0.c b/drivers/gpu/drm/nouveau/core/engine/fifo/nve0.c
> index 99c9dee..dbc3ff6 100644
> --- a/drivers/gpu/drm/nouveau/core/engine/fifo/nve0.c
> +++ b/drivers/gpu/drm/nouveau/core/engine/fifo/nve0.c
> @@ -112,7 +112,7 @@ nve0_fifo_runlist_update(struct nve0_fifo_priv *priv, u32 engine)
>
>         nv_wr32(priv, 0x002270, cur->addr >> 12);
>         nv_wr32(priv, 0x002274, (engine << 20) | (p >> 3));
> -       if (!nv_wait(priv, 0x002284 + (engine * 4), 0x00100000, 0x00000000))
> +       if (!nv_wait(priv, 0x002284 + (engine * 8), 0x00100000, 0x00000000))
>                 nv_error(priv, "runlist %d update timeout\n", engine);
>         mutex_unlock(&nv_subdev(priv)->mutex);
>  }
> --
> 1.8.5.3
>
> _______________________________________________
> dri-devel mailing list
> dri-devel@lists.freedesktop.org
> http://lists.freedesktop.org/mailman/listinfo/dri-devel
