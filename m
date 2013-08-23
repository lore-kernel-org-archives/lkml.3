Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754746Ab3HWOOk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 10:14:40 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:65502 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753428Ab3HWOOj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 10:14:39 -0400
Date: Fri, 23 Aug 2013 15:14:33 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Andrzej Hajda <a.hajda@samsung.com>
Cc: "lee.jones@linaro.org" <lee.jones@linaro.org>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        Pawel Moll <Pawel.Moll@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ian.campbell@citrix.com>, Rob Landley <rob@landley.net>,
        Samuel Ortiz <sameo@linux.intel.com>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Jonghwa Lee <jonghwa3.lee@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        "open list:OPEN FIRMWARE AND..." <devicetree@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 2/2] max77693: added device tree support
Message-ID: <20130823141433.GI25856@e106331-lin.cambridge.arm.com>
References: <1377104014-21910-1-git-send-email-a.hajda@samsung.com>
 <1377104014-21910-3-git-send-email-a.hajda@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1377104014-21910-3-git-send-email-a.hajda@samsung.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 21, 2013 at 05:53:34PM +0100, Andrzej Hajda wrote:
> This patch adds only of_match_table.
> There are no device specific properties.

Could you clarify what functionality this enables and what it doesn't,
please?

This doesn't seem to enable support for the regulators described in the
binding [1] (which from the looks of it needs proof-reading and possibly
rework).

Are there any changes we might need in future to either support new
functionality or to generalise the binding. e.g. do we need a regulator
for the LED? 

Given the binding has never been supported, are we happy now that it
best represents the hardware, or are there avenues of improvement
*before* it becomes ABI?

Thanks,
Mark.

[1] Documentation/devicetree/bindings/mfd/max77693.txt

> 
> Signed-off-by: Andrzej Hajda <a.hajda@samsung.com>
> Reviewed-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> ---
>  drivers/mfd/max77693.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/drivers/mfd/max77693.c b/drivers/mfd/max77693.c
> index 27f5da3..e0b11a9 100644
> --- a/drivers/mfd/max77693.c
> +++ b/drivers/mfd/max77693.c
> @@ -225,11 +225,19 @@ static const struct dev_pm_ops max77693_pm = {
>  	.resume = max77693_resume,
>  };
>  
> +#ifdef CONFIG_OF
> +static struct of_device_id max77693_dt_match[] = {
> +	{.compatible = "maxim,max77693"},
> +	{},
> +};
> +#endif
> +
>  static struct i2c_driver max77693_i2c_driver = {
>  	.driver = {
>  		   .name = "max77693",
>  		   .owner = THIS_MODULE,
>  		   .pm = &max77693_pm,
> +		   .of_match_table = of_match_ptr(max77693_dt_match),
>  	},
>  	.probe = max77693_i2c_probe,
>  	.remove = max77693_i2c_remove,
> -- 
> 1.8.1.2
> 
> 
