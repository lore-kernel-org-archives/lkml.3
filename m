Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753049AbaHTT55 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 15:57:57 -0400
Received: from galahad.ideasonboard.com ([185.26.127.97]:45877 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751468AbaHTT54 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 15:57:56 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Philipp Zabel <p.zabel@pengutronix.de>
Cc: linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org, Grant Likely <grant.likely@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>, kernel@pengutronix.de
Subject: Re: [PATCH 4/8] of: Add for_each_endpoint_of_node helper macro
Date: Wed, 20 Aug 2014 21:58:35 +0200
Message-ID: <8667517.hS1cvPvpF8@avalon>
User-Agent: KMail/4.12.5 (Linux/3.14.14-gentoo; KDE/4.12.5; x86_64; ; )
In-Reply-To: <1408453366-1366-5-git-send-email-p.zabel@pengutronix.de>
References: <1408453366-1366-1-git-send-email-p.zabel@pengutronix.de> <1408453366-1366-5-git-send-email-p.zabel@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Philipp,

Thank you for the patch.

On Tuesday 19 August 2014 15:02:42 Philipp Zabel wrote:
> Note that while of_graph_get_next_endpoint decrements the reference count
> of the child node passed to it, of_node_put(child) still has to be called
> manually when breaking out of the loop.

I think this is important enough to be mentioned in a comment in of_graph.h.

> Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
> ---
>  include/linux/of_graph.h | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/include/linux/of_graph.h b/include/linux/of_graph.h
> index befef42..2890a4c 100644
> --- a/include/linux/of_graph.h
> +++ b/include/linux/of_graph.h
> @@ -26,6 +26,10 @@ struct of_endpoint {
>  	const struct device_node *local_node;
>  };
> 
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


