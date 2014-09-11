Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753524AbaIKJVc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 05:21:32 -0400
Received: from galahad.ideasonboard.com ([185.26.127.97]:34756 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752216AbaIKJVa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 05:21:30 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Philipp Zabel <p.zabel@pengutronix.de>
Cc: linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org, Grant Likely <grant.likely@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>, kernel@pengutronix.de
Subject: Re: [PATCH v2 3/8] of: Decrement refcount of previous endpoint in of_graph_get_next_endpoint
Date: Thu, 11 Sep 2014 12:21:33 +0300
Message-ID: <1826645.Jx4afrVREc@avalon>
User-Agent: KMail/4.12.5 (Linux/3.14.14-gentoo; KDE/4.12.5; x86_64; ; )
In-Reply-To: <1410346708-5125-4-git-send-email-p.zabel@pengutronix.de>
References: <1410346708-5125-1-git-send-email-p.zabel@pengutronix.de> <1410346708-5125-4-git-send-email-p.zabel@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Philipp,

Thank you for the patch.

On Wednesday 10 September 2014 12:58:23 Philipp Zabel wrote:
> Decrementing the reference count of the previous endpoint node allows to
> use the of_graph_get_next_endpoint function in a for_each_... style macro.
> Prior to this patch, all current users of this function that actually pass
> a non-NULL prev parameter should be changed to not decrement the passed
> prev argument's refcount themselves.
> 
> Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>

Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

> ---
>  drivers/of/base.c | 9 +--------
>  1 file changed, 1 insertion(+), 8 deletions(-)
> 
> diff --git a/drivers/of/base.c b/drivers/of/base.c
> index d8574ad..a49b5628 100644
> --- a/drivers/of/base.c
> +++ b/drivers/of/base.c
> @@ -2058,8 +2058,7 @@ EXPORT_SYMBOL(of_graph_parse_endpoint);
>   * @prev: previous endpoint node, or NULL to get first
>   *
>   * Return: An 'endpoint' node pointer with refcount incremented. Refcount
> - * of the passed @prev node is not decremented, the caller have to use
> - * of_node_put() on it when done.
> + * of the passed @prev node is decremented.
>   */
>  struct device_node *of_graph_get_next_endpoint(const struct device_node
> *parent, struct device_node *prev)
> @@ -2095,12 +2094,6 @@ struct device_node *of_graph_get_next_endpoint(const
> struct device_node *parent, if (WARN_ONCE(!port, "%s(): endpoint %s has no
> parent node\n",
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

-- 
Regards,

Laurent Pinchart

