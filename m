Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757489Ab3ETWns (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 18:43:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:27747 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757185Ab3ETWnr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 18:43:47 -0400
Message-ID: <1369089740.30114.1.camel@localhost>
Subject: Re: [PATCH] drm/nouveau/nv84: Fix HDMI audio regression
From: Ben Skeggs <bskeggs@redhat.com>
Reply-To: bskeggs@redhat.com
To: Alexander Stein <alexander.stein@informatik.tu-chemnitz.de>
Cc: David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Date: Tue, 21 May 2013 08:42:20 +1000
In-Reply-To: <1369070040-26148-1-git-send-email-alexander.stein@informatik.tu-chemnitz.de>
References: <1369070040-26148-1-git-send-email-alexander.stein@informatik.tu-chemnitz.de>
Organization: Red Hat
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-05-20 at 19:14 +0200, Alexander Stein wrote:
> Code refactoring in commit 8e9e3d2deacc460fbb8a4691140318f6e85e6891
> (drm/nv84/disp: move hdmi control into core) disabled HDMI audio on my
> nv84 by removing too much old code without adding it in the new one.
> This patch adds the missing code within the new code layout resulting in
> HDMI audio working again.
> It should work on any HDMI head, but due to lacking ahrdware I could
> only test the (1st) one.
I'm surprised it ever worked at all actually.  There's additional setup
before nva3 that should've been required, but I've never got around to
reverse-engineering properly.

I'll pick up this patch though if it makes it work for you.

Thanks,
Ben.

> It also might be possible that similar code is needed for nva3, which I
> can't test.
> 
> Signed-off-by: Alexander Stein <alexander.stein@informatik.tu-chemnitz.de>
> ---
> This patch should also be added to stable kernels.
> 
>  drivers/gpu/drm/nouveau/core/engine/disp/hdminv84.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/drivers/gpu/drm/nouveau/core/engine/disp/hdminv84.c b/drivers/gpu/drm/nouveau/core/engine/disp/hdminv84.c
> index 0d36bdc..7fdade6 100644
> --- a/drivers/gpu/drm/nouveau/core/engine/disp/hdminv84.c
> +++ b/drivers/gpu/drm/nouveau/core/engine/disp/hdminv84.c
> @@ -55,6 +55,10 @@ nv84_hdmi_ctrl(struct nv50_disp_priv *priv, int head, int or, u32 data)
>  	nv_wr32(priv, 0x616510 + hoff, 0x00000000);
>  	nv_mask(priv, 0x616500 + hoff, 0x00000001, 0x00000001);
>  
> +	nv_mask(priv, 0x6165d0 + hoff, 0x00070001, 0x00010001); /* SPARE, HW_CTS */
> +	nv_mask(priv, 0x616568 + hoff, 0x00010101, 0x00000000); /* ACR_CTRL, ?? */
> +	nv_mask(priv, 0x616578 + hoff, 0x80000000, 0x80000000); /* ACR_0441_ENABLE */
> +
>  	/* ??? */
>  	nv_mask(priv, 0x61733c, 0x00100000, 0x00100000); /* RESETF */
>  	nv_mask(priv, 0x61733c, 0x10000000, 0x10000000); /* LOOKUP_EN */


