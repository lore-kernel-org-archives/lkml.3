Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753073AbaE2Wd5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 18:33:57 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:36941 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751543AbaE2Wdz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 18:33:55 -0400
Message-ID: <5387B5A4.6090403@ti.com>
Date: Thu, 29 May 2014 17:33:08 -0500
From: Nishanth Menon <nm@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Viresh Kumar <viresh.kumar@linaro.org>, <rjw@rjwysocki.net>
CC: <linaro-kernel@lists.linaro.org>, <linux-pm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <arvind.chauhan@arm.com>,
        <inderpal.s@samsung.com>, <chander.kashyap@linaro.org>, <pavel@ucw.cz>,
        <len.brown@intel.com>, <sudeep.holla@arm.com>
Subject: Re: [PATCH V4 3/8] opp: Enhance debug messages in of_init_opp_table()
References: <cover.1401191054.git.viresh.kumar@linaro.org> <2a9d8e2954166e47d7cdcf9c540dea572b080e7b.1401191054.git.viresh.kumar@linaro.org>
In-Reply-To: <2a9d8e2954166e47d7cdcf9c540dea572b080e7b.1401191054.git.viresh.kumar@linaro.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/27/2014 06:50 AM, Viresh Kumar wrote:
> Enhance print messages for debugging purposes. Add a dev_err() whenever we fail
> to initialize OPP table due to some error in the table present in dts and add a
> dev_dbg() for success case.
> 
> Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
> ---
>  drivers/base/power/opp.c | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/base/power/opp.c b/drivers/base/power/opp.c
> index 2b615b9..ed5d580 100644
> --- a/drivers/base/power/opp.c
> +++ b/drivers/base/power/opp.c
> @@ -628,8 +628,11 @@ int of_init_opp_table(struct device *dev)
>  	prop = of_find_property(dev->of_node, "operating-points", NULL);
>  	if (!prop)
>  		return -ENODEV;
> -	if (!prop->value)
> +	if (!prop->value) {
> +		dev_err(dev, "%s: failed to init OPP: prop->value is NULL\n",
> +			__func__);
>  		return -ENODATA;
> +	}
>  
>  	/*
>  	 * Each OPP is a set of tuples consisting of frequency and
> @@ -653,6 +656,8 @@ int of_init_opp_table(struct device *dev)
>  	}
>  
>  	of_node_put(dev->of_node);
> +
> +	dev_dbg(dev, "%s: successfully created OPP table\n", __func__);
>  	return 0;
>  }
>  EXPORT_SYMBOL_GPL(of_init_opp_table);
> 
With the same $subject comment as patch #1:
Acked-by: Nishanth Menon <nm@ti.com>

-- 
Regards,
Nishanth Menon
