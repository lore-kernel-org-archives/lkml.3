Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761785Ab3DBVbf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 17:31:35 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:33004 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761127Ab3DBVbe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 17:31:34 -0400
Message-ID: <515B4E32.8080006@wwwdotorg.org>
Date: Tue, 02 Apr 2013 15:31:30 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Rhyland Klein <rklein@nvidia.com>
CC: Anton Vorontsov <cbou@mail.ru>, Grant Likely <grant.likely@secretlab.ca>,
        David Woodhouse <dwmw2@infradead.org>, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, linux-tegra@vger.kernel.org
Subject: Re: [PATCH V2 2/3] power: power_supply: Add core support for supplied_from
References: <1364852755-17425-1-git-send-email-rklein@nvidia.com> <1364852755-17425-3-git-send-email-rklein@nvidia.com>
In-Reply-To: <1364852755-17425-3-git-send-email-rklein@nvidia.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/01/2013 03:45 PM, Rhyland Klein wrote:
> This patch adds support for supplies to register a list of char *'s
> which represent the list of supplies which supply them. This is the
> opposite as the supplied_to list.

This patch resolves the concerns I had before, so,
Reviewed-by: Stephen Warren <swarren@nvidia.com>

> diff --git a/drivers/power/power_supply_core.c b/drivers/power/power_supply_core.c

> +static bool __power_supply_is_supplied_by(struct power_supply *supplier,
> +					 struct power_supply *supply)
> +{
> +	int i;
> +
> +	if (!supply->supplied_from && !supplier->supplied_to)
> +		return false;

Nit: that somewhat duplicates the if below, so perhaps could just be
removed?

> +	/* Support both supplied_to and supplied_from modes */
> +	if (supply->supplied_from) {
> +		if (!supplier->name)
> +			return false;

Likewise, I'm still not convinced these !name tests should be required.

However, there's no harm here I think, so it's fine.
