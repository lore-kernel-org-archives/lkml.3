Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751798Ab3LKN1t (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 08:27:49 -0500
Received: from mail-ee0-f44.google.com ([74.125.83.44]:46672 "EHLO
	mail-ee0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751489Ab3LKN1f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 08:27:35 -0500
From: Grant Likely <grant.likely@linaro.org>
Subject: Re: [PATCHv6+ 01/13] of: introduce of_property_for_earch_phandle_with_args()
To: Hiroshi Doyu <hdoyu@nvidia.com>
Cc: "thierry.reding@gmail.com" <thierry.reding@gmail.com>,
        "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        "robherring2@gmail.com" <robherring2@gmail.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        Stephen Warren <swarren@nvidia.com>,
        "will.deacon@arm.com" <will.deacon@arm.com>,
        Hiroshi Doyu <hdoyu@nvidia.com>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "lorenzo.pieralisi@arm.com" <lorenzo.pieralisi@arm.com>,
        "galak@codeaurora.org" <galak@codeaurora.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <20131121.191720.1487772262083864095.hdoyu@nvidia.com>
References: <1385041249-7705-1-git-send-email-hdoyu@nvidia.com>< 1385041249-7705-2-git-send-email-hdoyu@nvidia.com> <20131121.191720. 1487772262083864095.hdoyu@nvidia.com>
Date: Wed, 11 Dec 2013 13:27:28 +0000
Message-Id: <20131211132729.0857CC4061A@trevor.secretlab.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 21 Nov 2013 18:17:20 +0100, Hiroshi Doyu <hdoyu@nvidia.com> wrote:
> Iterating over a property containing a list of phandles with arguments
> is a common operation for device drivers. This patch adds a new
> of_property_for_each_phandle_with_args() macro to make the iteration
> simpler.
> 
> Signed-off-by: Hiroshi Doyu <hdoyu@nvidia.com>
Acked-by: Grant Likely <grant.likely@linaro.org>

This patch can be merged with the rest of the series.

g.

> ---
> v6+:
> Use the description, which Grant Likely proposed, to be full enough
> that a future reader can figure out why a patch was written.
>   http://lists.linuxfoundation.org/pipermail/iommu/2013-November/007062.html
> 
> v5:
> New patch for v5.
> ---
>  include/linux/of.h | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/include/linux/of.h b/include/linux/of.h
> index 276c546..131fef5 100644
> --- a/include/linux/of.h
> +++ b/include/linux/of.h
> @@ -613,6 +613,9 @@ static inline int of_property_read_u32(const struct device_node *np,
>  		s;						\
>  		s = of_prop_next_string(prop, s))
>  
> +#define of_property_for_each_phandle_with_args(np, list, cells, i, args) \
> +	for (i = 0; !of_parse_phandle_with_args(np, list, cells, i, args); i++)
> +
>  #if defined(CONFIG_PROC_FS) && defined(CONFIG_PROC_DEVICETREE)
>  extern void proc_device_tree_add_node(struct device_node *, struct proc_dir_entry *);
>  extern void proc_device_tree_add_prop(struct proc_dir_entry *pde, struct property *prop);
> -- 
> 1.8.1.5

