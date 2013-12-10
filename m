Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751938Ab3LJCYI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 21:24:08 -0500
Received: from perceval.ideasonboard.com ([95.142.166.194]:60477 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750787Ab3LJCYF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 21:24:05 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: "ethan.zhao" <ethan.kernel@gmail.com>
Cc: linux-kernel@vger.kernel.org, Wei Yongjun <weiyj.lk@gmail.com>,
        dri-devel@lists.freedesktop.org
Subject: Re: [PATCH] r_du_lvdsenc.c : Check return value of devm_ioremap_resource with IS_ERR
Date: Tue, 10 Dec 2013 03:24:13 +0100
Message-ID: <1623649.XDp4FCPInj@avalon>
User-Agent: KMail/4.10.5 (Linux/3.10.17-gentoo; KDE/4.10.5; x86_64; ; )
In-Reply-To: <1386470506-553-1-git-send-email-ethan.kernel@gmail.com>
References: <1386470506-553-1-git-send-email-ethan.kernel@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ethan,

Thank you for the patch.

On Sunday 08 December 2013 10:41:46 ethan.zhao wrote:
> function devm_ioremap_resource() doesn't return NULL, should check its
> return value with helper IS_ERR().
> 
> Signed-off-by: ethan.zhao <ethan.kernel@gmail.com>

This issue has already been addressed by a patch sent to the dri-devel mailing 
list by Wei Yongjun (https://lkml.org/lkml/2013/8/22/637).

I've asked for a v2 to be submitted but haven't received any reply. I'll fix 
the problem myself and send the patch now.

> ---
>  drivers/gpu/drm/rcar-du/rcar_du_lvdsenc.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/gpu/drm/rcar-du/rcar_du_lvdsenc.c
> b/drivers/gpu/drm/rcar-du/rcar_du_lvdsenc.c index a0f6a17..93190ab 100644
> --- a/drivers/gpu/drm/rcar-du/rcar_du_lvdsenc.c
> +++ b/drivers/gpu/drm/rcar-du/rcar_du_lvdsenc.c
> @@ -151,7 +151,7 @@ static int rcar_du_lvdsenc_get_resources(struct
> rcar_du_lvdsenc *lvds, }
> 
>  	lvds->mmio = devm_ioremap_resource(&pdev->dev, mem);
> -	if (lvds->mmio == NULL) {
> +	if (IS_ERR(lvds->mmio)) {
>  		dev_err(&pdev->dev, "failed to remap memory resource for %s\n",
>  			name);
>  		return -ENOMEM;

-- 
Regards,

Laurent Pinchart

