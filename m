Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751856AbaKCKTR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 05:19:17 -0500
Received: from mailout4.w2.samsung.com ([211.189.100.14]:58820 "EHLO
	usmailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751495AbaKCKTP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 05:19:15 -0500
X-AuditID: cbfec372-b7f666d000001846-b1-545756a2b757
Date: Mon, 03 Nov 2014 08:19:07 -0200
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: Philipp Zabel <p.zabel@pengutronix.de>
Cc: Grant Likely <grant.likely@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>, kernel@pengutronix.de
Subject: Re: [PATCH v5 1/6] of: Decrement refcount of previous endpoint in
 of_graph_get_next_endpoint
Message-id: <20141103081907.46326b87.m.chehab@samsung.com>
In-reply-to: <1412013819-29181-2-git-send-email-p.zabel@pengutronix.de>
References: <1412013819-29181-1-git-send-email-p.zabel@pengutronix.de>
 <1412013819-29181-2-git-send-email-p.zabel@pengutronix.de>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; x86_64-redhat-linux-gnu)
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrFLMWRmVeSWpSXmKPExsVy+t/hIN1FYeEhBsv/iljsOfOL3eL9xnlM
	Fgf+7GC0aF68ns1i1dSdLBadE5ewW1zeNYfNomfDVlaLu/dOsFhs/vCSzYHLo6W5h83j3r7D
	LB4fPsZ5zO6Yyepx59oeNo/9c9ewe/T/NfD4vEkugCOKyyYlNSezLLVI3y6BK6PxnH3BJ9mK
	y3POMTYwPhbvYuTkkBAwkTh/Zw0ThC0mceHeerYuRi4OIYEljBJflu5nhHAamCS+zr3EDlLF
	IqAq8WHmCTCbTcBI4lVjCyuILSKgJfH0yj2wbmaBJ0wSJzc2gI0VFkiXeLJiJ5jNK2AlMfH7
	IjYQm1PAXeLwj052iA3NjBJbn54EmsQBdIezxPzP2RD1ghI/Jt9jAbGZgRZs3tbECmHLS2xe
	85Z5AqPALCRls5CUzUJStoCReRWjaGlxckFxUnquoV5xYm5xaV66XnJ+7iZGSHwU7WB8tsHq
	EKMAB6MSD2/lvrAQIdbEsuLK3EOMEhzMSiK8cf7hIUK8KYmVValF+fFFpTmpxYcYmTg4pRoY
	eTxPHTD44hqwIvr+3y0ft4rlhMR9unJsctoXHd5tc/Wbdy3NNr3t77h9/p81f9cJWIYtEGp/
	YaB2WY3PQ+Ko2MxslvuPciZ/PXOpfPnvA+YbCqIuabzpcnn4cf3Lv63r2e8u1y9658rEmf3i
	VmPTNL2dPhFvJmz9WfvE3LdU6sMlNfumpLqOU0osxRmJhlrMRcWJAI87n5ttAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Mon, 29 Sep 2014 20:03:34 +0200
Philipp Zabel <p.zabel@pengutronix.de> escreveu:

> Decrementing the reference count of the previous endpoint node allows to
> use the of_graph_get_next_endpoint function in a for_each_... style macro.
> All current users of this function that pass a non-NULL prev parameter
> (that is, soc_camera and imx-drm) are changed to not decrement the passed
> prev argument's refcount themselves.
> 
> Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>

Feel free to merge it via Grant's tree.

Acked-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

> ---
> Changes since v4:
>  - Folded patches 1-3 into this one
> ---
>  drivers/media/platform/soc_camera/soc_camera.c |  3 ++-
>  drivers/of/base.c                              |  9 +--------
>  drivers/staging/imx-drm/imx-drm-core.c         | 12 ++----------
>  3 files changed, 5 insertions(+), 19 deletions(-)
> 
> diff --git a/drivers/media/platform/soc_camera/soc_camera.c b/drivers/media/platform/soc_camera/soc_camera.c
> index f4308fe..619b2d4 100644
> --- a/drivers/media/platform/soc_camera/soc_camera.c
> +++ b/drivers/media/platform/soc_camera/soc_camera.c
> @@ -1696,7 +1696,6 @@ static void scan_of_host(struct soc_camera_host *ici)
>  		if (!i)
>  			soc_of_bind(ici, epn, ren->parent);
>  
> -		of_node_put(epn);
>  		of_node_put(ren);
>  
>  		if (i) {
> @@ -1704,6 +1703,8 @@ static void scan_of_host(struct soc_camera_host *ici)
>  			break;
>  		}
>  	}
> +
> +	of_node_put(epn);
>  }
>  
>  #else
> diff --git a/drivers/of/base.c b/drivers/of/base.c
> index 293ed4b..f7a9aa8 100644
> --- a/drivers/of/base.c
> +++ b/drivers/of/base.c
> @@ -2070,8 +2070,7 @@ EXPORT_SYMBOL(of_graph_parse_endpoint);
>   * @prev: previous endpoint node, or NULL to get first
>   *
>   * Return: An 'endpoint' node pointer with refcount incremented. Refcount
> - * of the passed @prev node is not decremented, the caller have to use
> - * of_node_put() on it when done.
> + * of the passed @prev node is decremented.
>   */
>  struct device_node *of_graph_get_next_endpoint(const struct device_node *parent,
>  					struct device_node *prev)
> @@ -2107,12 +2106,6 @@ struct device_node *of_graph_get_next_endpoint(const struct device_node *parent,
>  		if (WARN_ONCE(!port, "%s(): endpoint %s has no parent node\n",
>  			      __func__, prev->full_name))
>  			return NULL;
> -
> -		/*
> -		 * Avoid dropping prev node refcount to 0 when getting the next
> -		 * child below.
> -		 */
> -		of_node_get(prev);
>  	}
>  
>  	while (1) {
> diff --git a/drivers/staging/imx-drm/imx-drm-core.c b/drivers/staging/imx-drm/imx-drm-core.c
> index 6b22106..12303b3 100644
> --- a/drivers/staging/imx-drm/imx-drm-core.c
> +++ b/drivers/staging/imx-drm/imx-drm-core.c
> @@ -434,14 +434,6 @@ static uint32_t imx_drm_find_crtc_mask(struct imx_drm_device *imxdrm,
>  	return 0;
>  }
>  
> -static struct device_node *imx_drm_of_get_next_endpoint(
> -		const struct device_node *parent, struct device_node *prev)
> -{
> -	struct device_node *node = of_graph_get_next_endpoint(parent, prev);
> -	of_node_put(prev);
> -	return node;
> -}
> -
>  int imx_drm_encoder_parse_of(struct drm_device *drm,
>  	struct drm_encoder *encoder, struct device_node *np)
>  {
> @@ -453,7 +445,7 @@ int imx_drm_encoder_parse_of(struct drm_device *drm,
>  	for (i = 0; ; i++) {
>  		u32 mask;
>  
> -		ep = imx_drm_of_get_next_endpoint(np, ep);
> +		ep = of_graph_get_next_endpoint(np, ep);
>  		if (!ep)
>  			break;
>  
> @@ -502,7 +494,7 @@ int imx_drm_encoder_get_mux_id(struct device_node *node,
>  		return -EINVAL;
>  
>  	do {
> -		ep = imx_drm_of_get_next_endpoint(node, ep);
> +		ep = of_graph_get_next_endpoint(node, ep);
>  		if (!ep)
>  			break;
>  
