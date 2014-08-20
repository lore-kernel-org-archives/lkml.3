Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752973AbaHTURH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 16:17:07 -0400
Received: from galahad.ideasonboard.com ([185.26.127.97]:45903 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752594AbaHTURE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 16:17:04 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Philipp Zabel <p.zabel@pengutronix.de>
Cc: linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org, Grant Likely <grant.likely@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>, kernel@pengutronix.de
Subject: Re: [PATCH 6/8] drm: use for_each_endpoint_of_node macro in drm_of_find_possible_crtcs
Date: Wed, 20 Aug 2014 22:17:46 +0200
Message-ID: <35240162.ybqbYegqRc@avalon>
User-Agent: KMail/4.12.5 (Linux/3.14.14-gentoo; KDE/4.12.5; x86_64; ; )
In-Reply-To: <1408453366-1366-7-git-send-email-p.zabel@pengutronix.de>
References: <1408453366-1366-1-git-send-email-p.zabel@pengutronix.de> <1408453366-1366-7-git-send-email-p.zabel@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Philipp,

Thank you for the patch.

On Tuesday 19 August 2014 15:02:44 Philipp Zabel wrote:
> Using the for_each_... macro should make the code a bit shorter and
> easier to read.
> 
> Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>

Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

> ---
>  drivers/gpu/drm/drm_of.c | 8 ++------
>  1 file changed, 2 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/gpu/drm/drm_of.c b/drivers/gpu/drm/drm_of.c
> index 16150a0..024fa77 100644
> --- a/drivers/gpu/drm/drm_of.c
> +++ b/drivers/gpu/drm/drm_of.c
> @@ -46,11 +46,7 @@ uint32_t drm_of_find_possible_crtcs(struct drm_device
> *dev, struct device_node *remote_port, *ep = NULL;
>  	uint32_t possible_crtcs = 0;
> 
> -	do {
> -		ep = of_graph_get_next_endpoint(port, ep);
> -		if (!ep)
> -			break;
> -
> +	for_each_endpoint_of_node(port, ep) {
>  		remote_port = of_graph_get_remote_port(ep);
>  		if (!remote_port) {
>  			of_node_put(ep);
> @@ -60,7 +56,7 @@ uint32_t drm_of_find_possible_crtcs(struct drm_device
> *dev, possible_crtcs |= drm_crtc_port_mask(dev, remote_port);
> 
>  		of_node_put(remote_port);
> -	} while (1);
> +	}
> 
>  	return possible_crtcs;
>  }

-- 
Regards,

Laurent Pinchart

