Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753172AbaKZWAo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 17:00:44 -0500
Received: from galahad.ideasonboard.com ([185.26.127.97]:53910 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753058AbaKZWAm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 17:00:42 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Julia Lawall <Julia.Lawall@lip6.fr>
Cc: kernel-janitors@vger.kernel.org, David Airlie <airlied@linux.ie>,
        dri-devel@lists.freedesktop.org, linux-sh@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/5] drm/rcar-du: fix error return code
Date: Thu, 27 Nov 2014 00:01:07 +0200
Message-ID: <2892924.lmSyP4ZfXU@avalon>
User-Agent: KMail/4.12.5 (Linux/3.16.5-gentoo; KDE/4.12.5; x86_64; ; )
In-Reply-To: <1416748278-22881-5-git-send-email-Julia.Lawall@lip6.fr>
References: <1416748278-22881-1-git-send-email-Julia.Lawall@lip6.fr> <1416748278-22881-5-git-send-email-Julia.Lawall@lip6.fr>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Julia,

Thank you for the patch.

On Sunday 23 November 2014 14:11:17 Julia Lawall wrote:
> From: Julia Lawall <Julia.Lawall@lip6.fr>
> 
> Propagate the error code on failure.
> 
> A simplified version of the semantic match that finds this problem is as
> follows: (http://coccinelle.lip6.fr/)
> 
> // <smpl>
> @@
> identifier ret; expression e1,e2;
> @@
> (
> if (\(ret < 0\|ret != 0\))
>  { ... return ret; }
> 
> ret = 0
> )
> ... when != ret = e1
>     when != &ret
> *if(...)
> {
>   ... when != ret = e2
>       when forall
>  return ret;
> }
> // </smpl>
> 
> Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

I've applied the patch to my tree and sent a pull request.

> ---
>  drivers/gpu/drm/rcar-du/rcar_du_crtc.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/gpu/drm/rcar-du/rcar_du_crtc.c
> b/drivers/gpu/drm/rcar-du/rcar_du_crtc.c index 088bfd8..23cc910 100644
> --- a/drivers/gpu/drm/rcar-du/rcar_du_crtc.c
> +++ b/drivers/gpu/drm/rcar-du/rcar_du_crtc.c
> @@ -586,7 +586,7 @@ int rcar_du_crtc_create(struct rcar_du_group *rgrp,
> unsigned int index)
> 
>  	if (irq < 0) {
>  		dev_err(rcdu->dev, "no IRQ for CRTC %u\n", index);
> -		return ret;
> +		return irq;
>  	}
> 
>  	ret = devm_request_irq(rcdu->dev, irq, rcar_du_crtc_irq, irqflags,

-- 
Regards,

Laurent Pinchart

