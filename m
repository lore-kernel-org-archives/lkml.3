Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752263AbaKGQL4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 11:11:56 -0500
Received: from bhuna.collabora.co.uk ([93.93.135.160]:44465 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752115AbaKGQLy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 11:11:54 -0500
Message-ID: <545CEF45.1000503@collabora.co.uk>
Date: Fri, 07 Nov 2014 17:11:49 +0100
From: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.0
MIME-Version: 1.0
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
CC: Mark Brown <broonie@kernel.org>, Kukjin Kim <kgene.kim@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>, Olof Johansson <olof@lixom.net>,
        Chris Zhong <zyw@rock-chips.com>,
        Abhilash Kesavan <kesavan.abhilash@gmail.com>,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: Re: [PATCH v5 3/5] regulator: of: Add regulator desc param to of_get_regulator_init_data()
References: <1415365205-27630-1-git-send-email-javier.martinez@collabora.co.uk> <1415365205-27630-4-git-send-email-javier.martinez@collabora.co.uk> <1415373792.31102.27.camel@AMDC1943>
In-Reply-To: <1415373792.31102.27.camel@AMDC1943>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Krzysztof,

On 11/07/2014 04:23 PM, Krzysztof Kozlowski wrote:
>>  
>>  static struct fan53555_platform_data *fan53555_parse_dt(struct device *dev,
>> -							struct device_node *np)
>> +						struct device_node *np,
>> +						struct regulator_desc *desc)
> 
> Not a const? Why not?
>

Right, I removed all your other mentions to the same issue but I'll double
check all the drivers to be sure that use const.
 
>>  {
>>  	struct fan53555_platform_data *pdata;
>>  	int ret;
>> @@ -312,7 +313,7 @@ static struct fan53555_platform_data *fan53555_parse_dt(struct device *dev,
>>  	if (!pdata)
>>  		return NULL;
>>  
>> -	pdata->regulator = of_get_regulator_init_data(dev, np);
>> +	pdata->regulator = of_get_regulator_init_data(dev, np, desc);
> 
> Desc would be always NULL here which is safe (check in patch 5/5) but if
> someone puts "regulator-initial-mode" in DTS then this will always print
> warning. Just wonder - is it actually what you wanted?
> 
> This applies also for tps51632 and tps62360.
>

In an early version of the series I just passed NULL for all drivers but
Mark said that is more future proof to pass the descriptor and I agree.

I guess I should just remove the warning and only show an error if the
descriptor is not NULL and also the map mode function is defined but
the callback returns an error.
 
> (...)
> 
> Rest looks fine.
>

Thanks a lot for the review.
 
> Krzysztof
> 
> 

Best regards,
Javier
