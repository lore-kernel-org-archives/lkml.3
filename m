Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753893AbaDUSDM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2014 14:03:12 -0400
Received: from mail-ob0-f170.google.com ([209.85.214.170]:33921 "EHLO
	mail-ob0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753189AbaDUSDE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2014 14:03:04 -0400
MIME-Version: 1.0
In-Reply-To: <1398060142-7937-8-git-send-email-acourbot@nvidia.com>
References: <1398060142-7937-1-git-send-email-acourbot@nvidia.com>
	<1398060142-7937-8-git-send-email-acourbot@nvidia.com>
Date: Mon, 21 Apr 2014 14:03:02 -0400
X-Google-Sender-Auth: lhSQgfjW7SeUkUpzGv_W997EXac
Message-ID: <CAKb7UviQ6s8wRqwLVnE_A0NOw=WcVdFXG_wWmnZypwuaW_hnuw@mail.gmail.com>
Subject: Re: [PATCH v2 07/10] drm/nouveau/graph: pad firmware code at load time
From: Ilia Mirkin <imirkin@alum.mit.edu>
To: Alexandre Courbot <acourbot@nvidia.com>
Cc: Ben Skeggs <bskeggs@redhat.com>, Alexandre Courbot <gnurou@gmail.com>,
        "nouveau@lists.freedesktop.org" <nouveau@lists.freedesktop.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 21, 2014 at 2:02 AM, Alexandre Courbot <acourbot@nvidia.com> wrote:
> Pad the microcode to a multiple of 0x40 bytes, otherwise firmware will

bytes or u32's? From the code, I'm guessing the latter. (Similar
concern about comment in the code.)

> fail to run from non-prepadded firmware files.
>
> Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
> Reviewed-by: Thierry Reding <treding@nvidia.com>
> ---
>  drivers/gpu/drm/nouveau/core/engine/graph/nvc0.c | 4 ++++
>  1 file changed, 4 insertions(+)
>
> diff --git a/drivers/gpu/drm/nouveau/core/engine/graph/nvc0.c b/drivers/gpu/drm/nouveau/core/engine/graph/nvc0.c
> index e5b75f189988..013475c62986 100644
> --- a/drivers/gpu/drm/nouveau/core/engine/graph/nvc0.c
> +++ b/drivers/gpu/drm/nouveau/core/engine/graph/nvc0.c
> @@ -894,6 +894,10 @@ nvc0_graph_init_fw(struct nvc0_graph_priv *priv, u32 fuc_base,
>                         nv_wr32(priv, fuc_base + 0x0188, i >> 6);
>                 nv_wr32(priv, fuc_base + 0x0184, code->data[i]);
>         }
> +
> +       /* code must be padded to 0x40 bytes */
> +       for (; i & 0x3f; i++)
> +               nv_wr32(priv, fuc_base + 0x0184, 0);
>  }
>
>  static void
> --
> 1.9.2
>
> _______________________________________________
> dri-devel mailing list
> dri-devel@lists.freedesktop.org
> http://lists.freedesktop.org/mailman/listinfo/dri-devel
