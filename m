Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755557AbaCZEWv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2014 00:22:51 -0400
Received: from mail-qg0-f48.google.com ([209.85.192.48]:58283 "EHLO
	mail-qg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751597AbaCZEWt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2014 00:22:49 -0400
MIME-Version: 1.0
In-Reply-To: <1395650554-31925-10-git-send-email-acourbot@nvidia.com>
References: <1395650554-31925-1-git-send-email-acourbot@nvidia.com>
	<1395650554-31925-10-git-send-email-acourbot@nvidia.com>
Date: Wed, 26 Mar 2014 14:22:48 +1000
Message-ID: <CACAvsv6eCoWEU7ZNd5158-V3n=ZVo5O04CZa2EWE78e_tZEXPA@mail.gmail.com>
Subject: Re: [Nouveau] [PATCH 09/12] drm/nouveau/graph: pad firmware code at
 load time
From: Ben Skeggs <skeggsb@gmail.com>
To: Alexandre Courbot <acourbot@nvidia.com>
Cc: Ben Skeggs <bskeggs@redhat.com>,
        "nouveau@lists.freedesktop.org" <nouveau@lists.freedesktop.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 24, 2014 at 6:42 PM, Alexandre Courbot <acourbot@nvidia.com> wrote:
> Pad the microcode to a multiple of 0x40, otherwise firmware will fail to
> run from non-prepadded firmware files.
>
> Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
> ---
>  drivers/gpu/drm/nouveau/core/engine/graph/nvc0.c | 4 ++++
>  1 file changed, 4 insertions(+)
>
> diff --git a/drivers/gpu/drm/nouveau/core/engine/graph/nvc0.c b/drivers/gpu/drm/nouveau/core/engine/graph/nvc0.c
> index f997a18f5760..367e72daf8b1 100644
> --- a/drivers/gpu/drm/nouveau/core/engine/graph/nvc0.c
> +++ b/drivers/gpu/drm/nouveau/core/engine/graph/nvc0.c
> @@ -768,6 +768,10 @@ nvc0_graph_init_fw(struct nvc0_graph_priv *priv, u32 fuc_base,
>                         nv_wr32(priv, fuc_base + 0x0188, i >> 6);
>                 nv_wr32(priv, fuc_base + 0x0184, code->data[i]);
>         }
> +
> +       /* code must be padded to 0x40 */
> +       for (; i < (((code->size / 4) + 0x3f) & ~0x3f); i++)
"for (; i & 0x3f; i++)" would work just as well :)

> +               nv_wr32(priv, fuc_base + 0x0184, 0);
>  }
>
>  static void
> --
> 1.9.1
>
> _______________________________________________
> Nouveau mailing list
> Nouveau@lists.freedesktop.org
> http://lists.freedesktop.org/mailman/listinfo/nouveau
