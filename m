Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752337AbaIEX3k (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 19:29:40 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:49358 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751959AbaIEX3i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 19:29:38 -0400
Message-ID: <540A4760.8060105@codeaurora.org>
Date: Fri, 05 Sep 2014 16:29:36 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Stanimir Varbanov <svarbanov@mm-sol.com>,
        Grant Likely <grant.likely@linaro.org>
CC: linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        Rob Herring <robherring2@gmail.com>,
        Rob Herring <rob.herring@linaro.org>, Arnd Bergmann <arnd@arndb.de>,
        Lee Jones <lee.jones@linaro.org>
Subject: Re: [PATCH] RFC: add function for localbus address
References: <20140729234522.E9FF1C40738@trevor.secretlab.ca> <1409672700-21697-1-git-send-email-svarbanov@mm-sol.com>
In-Reply-To: <1409672700-21697-1-git-send-email-svarbanov@mm-sol.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/02/14 08:45, Stanimir Varbanov wrote:
> Hi Grant,
>
> I came down to this. Could you review? Is that
> implementation closer to the suggestion made by you.

I like this patch (but I'm biased because I want it to exist). Feel free
to add my Tested-by.


> ---
>  drivers/of/address.c       |   49 ++++++++++++++++++++++++++++++++++++++++++++
>  drivers/of/platform.c      |   20 ++++++++++++++---
>  include/linux/of_address.h |   19 +++++++++++++++++
>  3 files changed, 84 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/of/address.c b/drivers/of/address.c
> index e371825..86c2166 100644
> --- a/drivers/of/address.c
> +++ b/drivers/of/address.c
> @@ -601,6 +601,32 @@ const __be32 *of_get_address(struct device_node *dev, int index, u64 *size,
>  }
>  EXPORT_SYMBOL(of_get_address);
>  
> +const __be32 *of_get_localbus_address(struct device_node *np, int index,
> +				      u64 *size)
> +{
> +	struct device_node *root, *parent;
> +	const __be32 *ranges, *prop = NULL;
> +
> +	parent = of_get_parent(np);
> +	if (!parent)
> +		return NULL;
> +
> +	root = of_find_node_by_path("/");
> +
> +	if (parent == root) {
> +		of_node_put(parent);
> +		return NULL;
> +	}

I don't get this part though. Perhaps it needs a comment to say why we
don't allow the node to live in the root.

> +
> +	ranges = of_get_property(parent, "ranges", NULL);
> +	of_node_put(parent);
> +
> +	if (!ranges)
> +		prop = of_get_address(np, index, size, NULL);
> +
> +	return prop;
> +}
> +
>

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

