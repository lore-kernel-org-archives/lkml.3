Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752888AbaCGALJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 19:11:09 -0500
Received: from perceval.ideasonboard.com ([95.142.166.194]:48871 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751296AbaCGALH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 19:11:07 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Philipp Zabel <p.zabel@pengutronix.de>
Cc: Grant Likely <grant.likely@linaro.org>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Rob Herring <robh+dt@kernel.org>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: Re: [PATCH v6 4/8] of: Reduce indentation in of_graph_get_next_endpoint
Date: Fri, 07 Mar 2014 01:12:37 +0100
Message-ID: <31687163.hgTkcLrn0Z@avalon>
User-Agent: KMail/4.11.5 (Linux/3.10.25-gentoo; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1394011242-16783-5-git-send-email-p.zabel@pengutronix.de>
References: <1394011242-16783-1-git-send-email-p.zabel@pengutronix.de> <1394011242-16783-5-git-send-email-p.zabel@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Philipp,

Thank you for the patch.

I've submitted a fix for the of_graph_get_next_endpoint() function, but it 
hasn't been applied yet due to the patch series that contained it needing more 
work.

The patch is available at https://patchwork.linuxtv.org/patch/21946/. I can 
rebase it on top of this series, but I still wanted to let you know about it 
in case you would like to integrate it.

On Wednesday 05 March 2014 10:20:38 Philipp Zabel wrote:
> A 'return endpoint;' at the end of the (!prev) case allows to
> reduce the indentation level of the (prev) case.
> 
> Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
> ---
>  drivers/of/base.c | 42 ++++++++++++++++++++++--------------------
>  1 file changed, 22 insertions(+), 20 deletions(-)
> 
> diff --git a/drivers/of/base.c b/drivers/of/base.c
> index b5e690b..a8e47d3 100644
> --- a/drivers/of/base.c
> +++ b/drivers/of/base.c
> @@ -2026,32 +2026,34 @@ struct device_node *of_graph_get_next_endpoint(const
> struct device_node *parent, pr_err("%s(): no endpoint nodes specified for
> %s\n",
>  			       __func__, parent->full_name);
>  		of_node_put(node);
> -	} else {
> -		port = of_get_parent(prev);
> -		if (WARN_ONCE(!port, "%s(): endpoint %s has no parent node\n",
> -			      __func__, prev->full_name))
> -			return NULL;
> 
> -		/* Avoid dropping prev node refcount to 0. */
> -		of_node_get(prev);
> -		endpoint = of_get_next_child(port, prev);
> -		if (endpoint) {
> -			of_node_put(port);
> -			return endpoint;
> -		}
> +		return endpoint;
> +	}
> 
> -		/* No more endpoints under this port, try the next one. */
> -		do {
> -			port = of_get_next_child(parent, port);
> -			if (!port)
> -				return NULL;
> -		} while (of_node_cmp(port->name, "port"));
> +	port = of_get_parent(prev);
> +	if (WARN_ONCE(!port, "%s(): endpoint %s has no parent node\n",
> +		      __func__, prev->full_name))
> +		return NULL;
> 
> -		/* Pick up the first endpoint in this port. */
> -		endpoint = of_get_next_child(port, NULL);
> +	/* Avoid dropping prev node refcount to 0. */
> +	of_node_get(prev);
> +	endpoint = of_get_next_child(port, prev);
> +	if (endpoint) {
>  		of_node_put(port);
> +		return endpoint;
>  	}
> 
> +	/* No more endpoints under this port, try the next one. */
> +	do {
> +		port = of_get_next_child(parent, port);
> +		if (!port)
> +			return NULL;
> +	} while (of_node_cmp(port->name, "port"));
> +
> +	/* Pick up the first endpoint in this port. */
> +	endpoint = of_get_next_child(port, NULL);
> +	of_node_put(port);
> +
>  	return endpoint;
>  }
>  EXPORT_SYMBOL(of_graph_get_next_endpoint);

-- 
Regards,

Laurent Pinchart

