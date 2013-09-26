Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756929Ab3IZMFT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 08:05:19 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:24306 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756837Ab3IZMFP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 08:05:15 -0400
X-AuditID: cbfec7f4-b7f0a6d000007b1b-b0-524422f93dbe
Message-id: <524422F5.6010802@samsung.com>
Date: Thu, 26 Sep 2013 14:05:09 +0200
From: Andrzej Hajda <a.hajda@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803
 Thunderbird/17.0.8
MIME-version: 1.0
To: Andrzej Hajda <a.hajda@samsung.com>
Cc: lee.jones@linaro.org, Rob Herring <rob.herring@calxeda.com>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ian.campbell@citrix.com>, Rob Landley <rob@landley.net>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Grant Likely <grant.likely@linaro.org>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Jonghwa Lee <jonghwa3.lee@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        "open list:OPEN FIRMWARE AND..." <devicetree@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 2/2] max77693: added device tree support
References: <1377104014-21910-1-git-send-email-a.hajda@samsung.com>
 <1377104014-21910-3-git-send-email-a.hajda@samsung.com>
In-reply-to: <1377104014-21910-3-git-send-email-a.hajda@samsung.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrGLMWRmVeSWpSXmKPExsVy+t/xq7o/lVyCDL4vZbe4te4cq8X8I0Di
	wJ8djBZvejtYLDrPPmG2ONv0ht3i/tejjBaXd81hs1h6/SKTxYTpa1ksDq84wGSx7uV0IOtN
	O6vF6W5Wi1cH21gc+D3WzFvD6LHg8xV2j9eTJzB6vFo9k9XjzrU9bB7zTgZ69G1ZxejxeZOc
	x8a5oQGcUVw2Kak5mWWpRfp2CVwZT+6cZS34zlGxdXFkA+Mk9i5GTg4JAROJkzMa2SBsMYkL
	99YD2VwcQgJLGSWW7T7KAuF8YpRY+GYxC0gVr4CWxLQvc5hBbBYBVYm1J88wgdhsApoSfzff
	BJskKhAhsXLJA1aIekGJH5PvgfWKCKhLzD55hxlkKLPAXhaJxZcXAp3BwSEsYC/RP9cSpEZI
	oFZiw+7NYPWcAi4SHzatBdvFLKAjsb91GhuELS+xec1b5gmMArOQrJiFpGwWkrIFjMyrGEVT
	S5MLipPScw31ihNzi0vz0vWS83M3MULi6ssOxsXHrA4xCnAwKvHwarI5BwmxJpYVV+YeYpTg
	YFYS4X0r6xIkxJuSWFmVWpQfX1Sak1p8iJGJg1OqgTGRN/dy/Lw7noGcRps5eiSSEibv+Pzx
	5vtrJRqOYpdPTT9o9CbA7Ma2B7+f5Vw7FfAsPsk4/IJAM/8v9oPdxXNVpNjnL3rsY979jYdZ
	7LxF/4a2c7IiJ37HMChzTJX+dEFf/xW3lvDrMn+haSo6T3KmJH26fDBBYrf733clPWIXvKR3
	9DNHmSqxFGckGmoxFxUnAgCy+3z5iQIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/21/2013 06:53 PM, Andrzej Hajda wrote:
> This patch adds only of_match_table.
> There are no device specific properties.
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
Ping.

Regards
Andrzej

