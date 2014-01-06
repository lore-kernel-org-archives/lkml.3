Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755006AbaAFPOj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 10:14:39 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:35072 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751262AbaAFPOh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 10:14:37 -0500
Message-ID: <52CAC83F.3090903@canonical.com>
Date: Mon, 06 Jan 2014 16:14:07 +0100
From: Maarten Lankhorst <maarten.lankhorst@canonical.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Rashika Kheria <rashika.kheria@gmail.com>, linux-kernel@vger.kernel.org
CC: David Airlie <airlied@linux.ie>, Ben Skeggs <bskeggs@redhat.com>,
        dri-devel@lists.freedesktop.org, josh@joshtriplett.org
Subject: Re: [PATCH 15/85] drivers: gpu: Mark function as static in ctxnvd7.c
References: <b21c9d47bbb72f2134540b852c908a2080f1ed1d.1389018324.git.rashika.kheria@gmail.com> <ce2568f43c89753f7e0375c43c77aedbdae85bb3.1389018324.git.rashika.kheria@gmail.com>
In-Reply-To: <ce2568f43c89753f7e0375c43c77aedbdae85bb3.1389018324.git.rashika.kheria@gmail.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

op 06-01-14 16:11, Rashika Kheria schreef:
> Mark function nvd7_grctx_generate_main() as static in
> drm/nouveau/core/engine/graph/ctxnvd7.c because it is not used outside
> this file.
>
> This eliminates the following warning in
> drm/nouveau/core/engine/graph/ctxnvd7.c:
> drivers/gpu/drm/nouveau/core/engine/graph/ctxnvd7.c:215:1: warning: no previous prototype for ‘nvd7_grctx_generate_main’ [-Wmissing-prototypes]
>
> Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
> Reviewed-by: Josh Triplett <josh@joshtriplett.org>
> ---
>  .../gpu/drm/nouveau/core/engine/graph/ctxnvd7.c    |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/gpu/drm/nouveau/core/engine/graph/ctxnvd7.c b/drivers/gpu/drm/nouveau/core/engine/graph/ctxnvd7.c
> index c4740d5..0e126ce 100644
> --- a/drivers/gpu/drm/nouveau/core/engine/graph/ctxnvd7.c
> +++ b/drivers/gpu/drm/nouveau/core/engine/graph/ctxnvd7.c
> @@ -211,7 +211,7 @@ nvd7_grctx_generate_mods(struct nvc0_graph_priv *priv, struct nvc0_grctx *info)
>  	mmio_list(0x17e91c, 0x03060609, 0, 0); /* different from kepler */
>  }
>  
> -void
> +static void
>  nvd7_grctx_generate_main(struct nvc0_graph_priv *priv, struct nvc0_grctx *info)
>  {
>  	struct nvc0_grctx_oclass *oclass = (void *)nv_engine(priv)->cclass;
Acked-by: Maarten Lankhorst <maarten.lankhorst@canonical.com>

Building with -Wmissing-prototypes? Good luck fixing radeon! it's a mess. :(
