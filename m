Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753779AbaIKJWW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 05:22:22 -0400
Received: from galahad.ideasonboard.com ([185.26.127.97]:34767 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753727AbaIKJWT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 05:22:19 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Philipp Zabel <p.zabel@pengutronix.de>
Cc: linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org, Grant Likely <grant.likely@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>, kernel@pengutronix.de
Subject: Re: [PATCH v2 4/8] of: Add for_each_endpoint_of_node helper macro
Date: Thu, 11 Sep 2014 12:22:22 +0300
Message-ID: <2552532.QoKjg31Y3s@avalon>
User-Agent: KMail/4.12.5 (Linux/3.14.14-gentoo; KDE/4.12.5; x86_64; ; )
In-Reply-To: <1410346708-5125-5-git-send-email-p.zabel@pengutronix.de>
References: <1410346708-5125-1-git-send-email-p.zabel@pengutronix.de> <1410346708-5125-5-git-send-email-p.zabel@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Philipp,

Thank you for the patch.

On Wednesday 10 September 2014 12:58:24 Philipp Zabel wrote:
> Note that while of_graph_get_next_endpoint decrements the reference count
> of the child node passed to it, of_node_put(child) still has to be called
> manually when breaking out of the loop.
> 
> Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>

Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

> ---
> Changes since v1:
>  - Added a comment about the child node reference count when breaking out
>    of the loop
> ---
>  include/linux/of_graph.h | 11 +++++++++++
>  1 file changed, 11 insertions(+)
> 
> diff --git a/include/linux/of_graph.h b/include/linux/of_graph.h
> index befef42..e43442e 100644
> --- a/include/linux/of_graph.h
> +++ b/include/linux/of_graph.h
> @@ -26,6 +26,17 @@ struct of_endpoint {
>  	const struct device_node *local_node;
>  };
> 
> +/**
> + * for_each_endpoint_of_node - iterate over every endpoint in a device node
> + * @parent: parent device node containing ports and endpoints
> + * @child: loop variable pointing to the current endpoint node
> + *
> + * When breaking out of the loop, of_node_put(child) has to be called
> manually. + */
> +#define for_each_endpoint_of_node(parent, child) \
> +	for (child = of_graph_get_next_endpoint(parent, NULL); child != NULL; \
> +	     child = of_graph_get_next_endpoint(parent, child))
> +
>  #ifdef CONFIG_OF
>  int of_graph_parse_endpoint(const struct device_node *node,
>  				struct of_endpoint *endpoint);

-- 
Regards,

Laurent Pinchart

