Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752698AbaJGCUx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2014 22:20:53 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:22328 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752497AbaJGCUv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2014 22:20:51 -0400
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
X-AuditID: cbfee691-f79b86d000004a5a-3f-54334e016f94
Content-transfer-encoding: 8BIT
Message-id: <54334E00.9030403@samsung.com>
Date: Tue, 07 Oct 2014 11:20:48 +0900
From: jonghwa3.lee@samsung.com
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:11.0) Gecko/20120411
 Thunderbird/11.0.1
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Sebastian Reichel <sre@kernel.org>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Myungjoo Ham <myungjoo.ham@samsung.com>,
        Anton Vorontsov <anton@enomsg.org>,
        Chanwoo Choi <cw00.choi@samsung.com>, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] power: charger-manager: Avoid recursive thermal get_temp
 call
References: <1412611212-24803-1-git-send-email-k.kozlowski@samsung.com>
In-reply-to: <1412611212-24803-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrHIsWRmVeSWpSXmKPExsWyRsSkQJfRzzjE4OBEYYuDWzUtrn95zmox
	6cl7ZouJKyczW7x+YWhxedccNovPvUcYLW43rmCzOL27xIHTY0L/J0aPnbPusntsXqHlsWlV
	J5tH35ZVjB6fN8kFsEVx2aSk5mSWpRbp2yVwZTyafpe54L9sRdOJKawNjJckuhg5OSQETCQe
	3TrHCGGLSVy4t56ti5GLQ0hgKaNE197dbDBFC9t2MEIkFjFKTLrUxA6S4BUQlPgx+R5LFyMH
	B7OAvMSRS9kgYWYBdYlJ8xYxQ9S/ZpTYOWMHI0S9lsT1U8/AhrIIqEpsmbAdLM4mICfxtukb
	mC0qECZxdcJxFhBbRMBQ4uDu7Uwgg5gFNjFJrHs5BywhLBAisXvmJWYQW0jAXWLxphNgQzkF
	PCRufTwIdqmEwEt2ida9t9ghtglIfJt8COxSCQFZiU0HmCE+k5Q4uOIGywRGsVlI/pmF8M8s
	JP8sYGRexSiaWpBcUJyUXmSqV5yYW1yal66XnJ+7iREYjaf/PZu4g/H+AetDjAIcjEo8vCu0
	jEOEWBPLiitzDzGaAh0xkVlKNDkfGPN5JfGGxmZGFqYmpsZG5pZmSuK8OtI/g4UE0hNLUrNT
	UwtSi+KLSnNSiw8xMnFwSjUwupenXXW24Jkorm93yrvnUcnbu93W00Mkk9q5g26Glvx+sPf3
	zOmzo5dPspE23c/yaYtBSEWQTGiFsWie1pRlX7aYfj+wc7G3TbWw2Yee/OvfOTWzvZ5nKr/8
	y1y7RYLh582rVi5vlKLYzv3cwi/+Ivhvlt/sWutY84VpSpn/XurOiPO+se2WEktxRqKhFnNR
	cSIAVuWy4MECAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrBIsWRmVeSWpSXmKPExsVy+t9jAV1GP+MQg2V93BYHt2paXP/ynNVi
	0pP3zBYTV05mtnj9wtDi8q45bBafe48wWtxuXMFmcXp3iQOnx4T+T4weO2fdZffYvELLY9Oq
	TjaPvi2rGD0+b5ILYItqYLTJSE1MSS1SSM1Lzk/JzEu3VfIOjneONzUzMNQ1tLQwV1LIS8xN
	tVVy8QnQdcvMATpJSaEsMacUKBSQWFyspG+HaUJoiJuuBUxjhK5vSBBcj5EBGkhYw5jxaPpd
	5oL/shVNJ6awNjBekuhi5OSQEDCRWNi2gxHCFpO4cG89WxcjF4eQwCJGiUmXmthBErwCghI/
	Jt9j6WLk4GAWkJc4cikbJMwsoC4xad4iZoj614wSO2dADOIV0JK4fuoZG4jNIqAqsWXCdrA4
	m4CcxNumb2C2qECYxNUJx1lAbBEBQ4mDu7czgQxiFtjEJLHu5RywhLBAiMTumZeYQWwhAXeJ
	xZtOgA3lFPCQuPXxIOMERoFZSO6bhXDfLCT3LWBkXsUomlqQXFCclJ5rqFecmFtcmpeul5yf
	u4kRHOvPpHYwrmywOMQowMGoxMO7Qss4RIg1say4MvcQowQHs5IIL9dvoxAh3pTEyqrUovz4
	otKc1OJDjKZA301klhJNzgemobySeENjEzMjSyNzQwsjY3Mlcd4DrdaBQgLpiSWp2ampBalF
	MH1MHJxSDYw799x5LrxNwWdrx4pZX9W9zINM5DX+f73HLHr52f/fXlKPru1cudDxj/f5nvqe
	mRLnT0jn2TlcKtqnIe57wZL1woYu60wrwQl3o9apLtNY/PCcf7LW9twV+d/Zz7k/+pCjfHXz
	vnXeZ1hb67cWpvDNKnXyODjlp8W/4uN7V5+PiFPfbvbh5fdKJZbijERDLeai4kQAmryMwQsD	AAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
On 2014년 10월 07일 01:00, Krzysztof Kozlowski wrote:

> The charger manager supports POWER_SUPPLY_PROP_TEMP property and acts
> as a thermal zone if any of these conditions match:
> 1. Fuel gauge used by charger manager supports POWER_SUPPLY_PROP_TEMP.
> 2. 'cm-thermal-zone' property is present in DTS (then it will supersede
>    the fuel gauge temperature property).
> 
> However in case 1 (fuel gauge reports temperature and 'cm-thermal-zone'
> is not set) the charger manager forwards its get_temp calls to fuel
> gauge thermal zone.
> 
> This leads to reporting by lockdep a false positive deadlock for thermal
> zone's mutex because of nested calls to thermal_zone_get_temp(). This is
> false positive because these are different mutexes: one for charger
> manager thermal zone and second for fuel gauge thermal zone.
> 


Yes, this happens because power_supply_subsystem automatically creates
thermal_zone when POWER_SUPPLY_PROP_TEMP is available at the time of
power_supply registering. And as you point out, it makes duplicate thermal_zone
when some power_supply references other power_supply's. I hope it would become
to be a selectable option or change the manner of charger-manager itself (if the
charger-manager is only one who references other power_supply's temperature
sensing ability).

Anyway, the code looks fine to me.

Acked-by : Jonghwa Lee <jonghwa3.lee@samsung.com>

Thanks,
Jonghwa.

> Get rid of false lockdep alert and recursive call by accessing fuel gauge
> temperature through power supply property instead of thermal zone API.
> 

> Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> ---
>  drivers/power/charger-manager.c       | 21 +++++++++++----------
>  include/linux/power/charger-manager.h |  2 --
>  2 files changed, 11 insertions(+), 12 deletions(-)
> 
> diff --git a/drivers/power/charger-manager.c b/drivers/power/charger-manager.c
> index c1ed3c99c059..871fb91429c8 100644
> --- a/drivers/power/charger-manager.c
> +++ b/drivers/power/charger-manager.c
> @@ -559,16 +559,18 @@ static int cm_get_battery_temperature(struct charger_manager *cm,
>  	if (!cm->desc->measure_battery_temp)
>  		return -ENODEV;
>  
> -#ifdef CONFIG_THERMAL
> -	ret = thermal_zone_get_temp(cm->tzd_batt, (unsigned long *)temp);
> -	if (!ret)
> -		/* Calibrate temperature unit */
> -		*temp /= 100;
> -#else
> -	ret = cm->fuel_gauge->get_property(cm->fuel_gauge,
> +	if (IS_ENABLED(CONFIG_THERMAL) && cm->tzd_batt) {
> +		ret = thermal_zone_get_temp(cm->tzd_batt, (unsigned long *)temp);
> +		if (!ret)
> +			/* Calibrate temperature unit */
> +			*temp /= 100;
> +	} else {
> +		/* No external thermometer or no CONFIG_THERMAL */
> +		ret = cm->fuel_gauge->get_property(cm->fuel_gauge,
>  				POWER_SUPPLY_PROP_TEMP,
>  				(union power_supply_propval *)temp);
> -#endif
> +	}
> +
>  	return ret;
>  }
>  
> @@ -1501,9 +1503,8 @@ static int cm_init_thermal_data(struct charger_manager *cm)
>  		cm->charger_psy.num_properties++;
>  		cm->desc->measure_battery_temp = true;
>  	}
> -#ifdef CONFIG_THERMAL
> -	cm->tzd_batt = cm->fuel_gauge->tzd;
>  
> +#ifdef CONFIG_THERMAL
>  	if (ret && desc->thermal_zone) {
>  		cm->tzd_batt =
>  			thermal_zone_get_zone_by_name(desc->thermal_zone);
> diff --git a/include/linux/power/charger-manager.h b/include/linux/power/charger-manager.h
> index 07e7945a1ff2..743ed6d472c6 100644
> --- a/include/linux/power/charger-manager.h
> +++ b/include/linux/power/charger-manager.h
> @@ -256,9 +256,7 @@ struct charger_manager {
>  	struct power_supply *fuel_gauge;
>  	struct power_supply **charger_stat;
>  
> -#ifdef CONFIG_THERMAL
>  	struct thermal_zone_device *tzd_batt;
> -#endif
>  	bool charger_enabled;
>  
>  	unsigned long fullbatt_vchk_jiffies_at;


