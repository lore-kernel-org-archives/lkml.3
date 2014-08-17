Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751807AbaHRCeH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Aug 2014 22:34:07 -0400
Received: from mail-yk0-f170.google.com ([209.85.160.170]:57426 "EHLO
	mail-yk0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751641AbaHRCeB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Aug 2014 22:34:01 -0400
From: Grant Likely <grant.likely@linaro.org>
Subject: Re: [PATCH 1/3] of: Add of_match_machine helper
To: Tuomas Tynkkynen <ttynkkynen@nvidia.com>, Rob Herring <robh+dt@kernel.org>
Cc: Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>, linux-pm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, linux-tegra@vger.kernel.org,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Tuomas Tynkkynen <ttynkkynen@nvidia.com>
In-Reply-To: <1407452515-2390-2-git-send-email-ttynkkynen@nvidia.com>
References: <1407452515-2390-1-git-send-email-ttynkkynen@nvidia.com>
	<1407452515-2390-2-git-send-email-ttynkkynen@nvidia.com>
Date: Sun, 17 Aug 2014 16:28:54 +0100
Message-Id: <20140817152854.5406BC40ADD@trevor.secretlab.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 8 Aug 2014 02:01:53 +0300, Tuomas Tynkkynen <ttynkkynen@nvidia.com> wrote:
> Add of_match_machine function to test the device tree root for an
> of_match array. This can be useful when testing SoC versions at runtime,
> for example.
> 
> Signed-off-by: Tuomas Tynkkynen <ttynkkynen@nvidia.com>
> ---
>  drivers/of/base.c  | 21 +++++++++++++++++++++
>  include/linux/of.h |  3 +++
>  2 files changed, 24 insertions(+)
> 
> diff --git a/drivers/of/base.c b/drivers/of/base.c
> index d8574ad..37798ea 100644
> --- a/drivers/of/base.c
> +++ b/drivers/of/base.c
> @@ -977,6 +977,27 @@ struct device_node *of_find_matching_node_and_match(struct device_node *from,
>  EXPORT_SYMBOL(of_find_matching_node_and_match);
>  
>  /**
> + * of_match_machine - Tell if root of device tree has a matching of_match struct
> + *	@matches:	array of of device match structures to search in
> + *
> + *	Returns the result of of_match_node for the root node.
> + */
> +const struct of_device_id *of_match_machine(const struct of_device_id *matches)
> +{
> +	const struct of_device_id *match;
> +	struct device_node *root;
> +
> +	root = of_find_node_by_path("/");
> +	if (!root)
> +		return NULL;
> +
> +	match = of_match_node(matches, root);
> +	of_node_put(root);
> +	return match;
> +}
> +EXPORT_SYMBOL(of_match_machine);

Too wordy...

	return of_match_node(matches, of_allnodes);

:-)

It could be a static inline, but I don't think it's even worth having a
helper. The callers could just open code the above.

g.
