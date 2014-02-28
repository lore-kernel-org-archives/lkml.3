Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752786AbaB1VJe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 16:09:34 -0500
Received: from mail-ee0-f41.google.com ([74.125.83.41]:36681 "EHLO
	mail-ee0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751711AbaB1VJa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 16:09:30 -0500
Message-ID: <5310FB05.4000307@gmail.com>
Date: Fri, 28 Feb 2014 22:09:25 +0100
From: Sylwester Nawrocki <snjw23@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:11.0) Gecko/20120412 Thunderbird/11.0.1
MIME-Version: 1.0
To: Philipp Zabel <p.zabel@pengutronix.de>
CC: Grant Likely <grant.likely@linaro.org>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Rob Herring <robh+dt@kernel.org>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: Re: [PATCH v5 3/7] of: Warn if of_graph_get_next_endpoint is called
 with the root node
References: <1393522540-22887-1-git-send-email-p.zabel@pengutronix.de> <1393522540-22887-4-git-send-email-p.zabel@pengutronix.de>
In-Reply-To: <1393522540-22887-4-git-send-email-p.zabel@pengutronix.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/27/2014 06:35 PM, Philipp Zabel wrote:
> If of_graph_get_next_endpoint is given a parentless node instead of an
> endpoint node, it is clearly a bug.
>
> Signed-off-by: Philipp Zabel<p.zabel@pengutronix.de>
> ---
>   drivers/of/base.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/of/base.c b/drivers/of/base.c
> index b2f223f..6e650cf 100644
> --- a/drivers/of/base.c
> +++ b/drivers/of/base.c
> @@ -2028,8 +2028,8 @@ struct device_node *of_graph_get_next_endpoint(const struct device_node *parent,
>   		of_node_put(node);
>   	} else {
>   		port = of_get_parent(prev);
> -		if (!port)
> -			/* Hm, has someone given us the root node ?... */
> +		if (WARN_ONCE(!port, "%s(): endpoint has no parent node\n",
> +			      __func__))

Perhaps we can add more information to this error log, e.g.

		if (WARN_ONCE(!port, "%s(): endpoint %s has no parent node\n",
			      __func__, prev->full_name))
?
>   			return NULL;
>
>   		/* Avoid dropping prev node refcount to 0. */
