Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754322AbaF3PDZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 11:03:25 -0400
Received: from fw-tnat.cambridge.arm.com ([217.140.96.21]:54441 "EHLO
	cam-smtp0.cambridge.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754224AbaF3PDX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 11:03:23 -0400
From: Punit Agrawal <punit.agrawal@arm.com>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: Eduardo Valentin <edubezval@gmail.com>, Zhang Rui <rui.zhang@intel.com>,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org
Subject: Re: [PATCH] thermal: Add braces around suspect code
References: <1403134328-4668-1-git-send-email-sboyd@codeaurora.org>
Date: Mon, 30 Jun 2014 16:03:12 +0100
In-Reply-To: <1403134328-4668-1-git-send-email-sboyd@codeaurora.org> (Stephen
	Boyd's message of "Wed, 18 Jun 2014 16:32:08 -0700")
Message-ID: <9hhionibftb.fsf@arm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Boyd <sboyd@codeaurora.org> writes:

> It looks like this code is missing braces, otherwise the if
> statement shouldn't have been indented. Fix it.
>
> Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
> ---
>  drivers/thermal/of-thermal.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/thermal/of-thermal.c b/drivers/thermal/of-thermal.c
> index 04b1be7fa018..a95ee2889b19 100644
> --- a/drivers/thermal/of-thermal.c
> +++ b/drivers/thermal/of-thermal.c
> @@ -712,11 +712,12 @@ thermal_of_build_thermal_zone(struct device_node *np)
>  	}
>  
>  	i = 0;
> -	for_each_child_of_node(child, gchild)
> +	for_each_child_of_node(child, gchild) {
>  		ret = thermal_of_populate_bind_params(gchild, &tz->tbps[i++],
>  						      tz->trips, tz->ntrips);
>  		if (ret)
>  			goto free_tbps;
> +	}
>  
>  finish:
>  	of_node_put(child);

Looks good to me.

Reviewed-by: Punit Agrawal <punit.agrawal@arm.com>
