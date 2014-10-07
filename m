Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753276AbaJGKS7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 06:18:59 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:8218 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751447AbaJGKS4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 06:18:56 -0400
X-AuditID: cbfee68f-f791c6d000004834-7b-5433be0effcd
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 8BIT
Message-id: <5433BE0D.6000306@samsung.com>
Date: Tue, 07 Oct 2014 19:18:53 +0900
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
 <54334E00.9030403@samsung.com> <1412665994.11780.3.camel@AMDC1943>
In-reply-to: <1412665994.11780.3.camel@AMDC1943>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrJIsWRmVeSWpSXmKPExsWyRsSkSJdvn3GIQdtvLYuDWzUtrn95zmox
	6cl7ZouJKyczW7x+YWhxedccNovPvUcYLW43rmCzOL27xIHTY0L/J0aPnbPusntsXqHlsWlV
	J5tH35ZVjB6fN8kFsEVx2aSk5mSWpRbp2yVwZdxev5Sl4JBmxeYZa5gaGJuUuhg5OSQETCR+
	vn3GBGGLSVy4t56ti5GLQ0hgKaNE98KrLDBFJzc9YIdITGeUaJp8jQ0kwSsgKPFj8j2wImYB
	dYlJ8xYxQ9giEpMP/ICytSWWLXzNDNH8mlHiyM3TrBDNWhKzVh1iBLFZBFQlNrWtABvEJiAn
	8bbpG1hcVCBM4uqE42BxEQFDiYO7tzOBDGIW2MQkse7lHLCEsECIxO6Zl6A29DBKvJt5CCzB
	KWAgMe3aXEaQhITAI3aJpp57UOsEJL5NBiniAErISmw6wAzxp6TEwRU3WCYwis9C8t0sJN/N
	QvLdLCTfLWBkWcUomlqQXFCclF5krFecmFtcmpeul5yfu4kRGMOn/z3r38F494D1IUYBDkYl
	Ht4VWsYhQqyJZcWVuYcYTYEumsgsJZqcD0wUeSXxhsZmRhamJqbGRuaWZkrivAulfgYLCaQn
	lqRmp6YWpBbFF5XmpBYfYmTi4JRqYFwtu1FX+2H4vdOPYqZsdV88+aXnQxsh3ajJXRNUj3ML
	v53yVM/J6MYMi80yHqe+LZZ4t+X474LJTm/e1P2Ok9+v15th/VPl1Y85OdVlWze6Vjkxfz+c
	wbXsdvLr7PJtNur+9w9vy+GLeiLT8/IVw2elyqNmYlp91+I4RK53Z/zI4jmhprTQ6bMSS3FG
	oqEWc1FxIgDJEZu53AIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrJIsWRmVeSWpSXmKPExsVy+t9jQV2+fcYhBheXKFsc3Kppcf3Lc1aL
	SU/eM1tMXDmZ2eL1C0OLy7vmsFl87j3CaHG7cQWbxendJQ6cHhP6PzF67Jx1l91j8wotj02r
	Otk8+rasYvT4vEkugC2qgdEmIzUxJbVIITUvOT8lMy/dVsk7ON453tTMwFDX0NLCXEkhLzE3
	1VbJxSdA1y0zB+gkJYWyxJxSoFBAYnGxkr4dpgmhIW66FjCNEbq+IUFwPUYGaCBhDWNGx/dJ
	7AVdmhVzF/SxNzCeUuxi5OSQEDCROLnpATuELSZx4d56ti5GLg4hgemMEk2Tr7GBJHgFBCV+
	TL7H0sXIwcEsIC9x5FI2SJhZQF1i0rxFzBD1rxkljtw8zQpRryUxa9UhRhCbRUBVYlPbChYQ
	m01ATuJt0zewuKhAmMTVCcfB4iIChhIHd29nAhnELLCJSWLdyzlgCWGBEIndMy9BbehhlHg3
	8xBYglPAQGLatbmMExgFZiE5cBbCgbOQHLiAkXkVo2hqQXJBcVJ6rpFecWJucWleul5yfu4m
	RnC0P5PewbiqweIQowAHoxIP7wot4xAh1sSy4srcQ4wSHMxKIry+O4FCvCmJlVWpRfnxRaU5
	qcWHGE2B3pvILCWanA9MRHkl8YbGJmZGlkbmhhZGxuZK4rwHW60DhQTSE0tSs1NTC1KLYPqY
	ODilGhg3rv591O279N2ln6f3nFFTyTj75cL7I/2JmxdzJM2aGbCrw9jjtdWUhkAFfoVT83Z3
	lPkdyvXOstMqXub+eKfcJ9tsxdgLEpzL2tcoLtjP/W5VVdRe8+wTspxfvu+NPL0neId4qs/m
	KyFqzzj4dCx0wha3Cfop3V7ZsTeLh8/Zjf8cQ9G0fcuVWIozEg21mIuKEwHsh8thDAMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014년 10월 07일 16:13, Krzysztof Kozlowski wrote:

> 
> On wto, 2014-10-07 at 11:20 +0900, jonghwa3.lee@samsung.com wrote:
>> Hi,
>> On 2014년 10월 07일 01:00, Krzysztof Kozlowski wrote:
>>
>>> The charger manager supports POWER_SUPPLY_PROP_TEMP property and acts
>>> as a thermal zone if any of these conditions match:
>>> 1. Fuel gauge used by charger manager supports POWER_SUPPLY_PROP_TEMP.
>>> 2. 'cm-thermal-zone' property is present in DTS (then it will supersede
>>>    the fuel gauge temperature property).
>>>
>>> However in case 1 (fuel gauge reports temperature and 'cm-thermal-zone'
>>> is not set) the charger manager forwards its get_temp calls to fuel
>>> gauge thermal zone.
>>>
>>> This leads to reporting by lockdep a false positive deadlock for thermal
>>> zone's mutex because of nested calls to thermal_zone_get_temp(). This is
>>> false positive because these are different mutexes: one for charger
>>> manager thermal zone and second for fuel gauge thermal zone.
>>>
>>
>>
>> Yes, this happens because power_supply_subsystem automatically creates
>> thermal_zone when POWER_SUPPLY_PROP_TEMP is available at the time of
>> power_supply registering. And as you point out, it makes duplicate thermal_zone
>> when some power_supply references other power_supply's. I hope it would become
>> to be a selectable option or change the manner of charger-manager itself (if the
>> charger-manager is only one who references other power_supply's temperature
>> sensing ability).
>>
>> Anyway, the code looks fine to me.
>>
>> Acked-by : Jonghwa Lee <jonghwa3.lee@samsung.com>
> 
> Thank you for looking at patch. However later I started to wonder
> whether my fix is sufficient. For the case when fuel gauge is used as
> source of temperature it is. But for the case when external sensor is
> used it is not - still there will be recursive call and false positive
> from lockdep.
> 
> Also minor fix is needed in my patch - s/IS_ENABLED/config_enabled/.
> 
> I can send a v2 fixing this but first question - what about second
> recursive issue (when external sensor is used instead of fuel gauge)?
> 


Yes, you're right, it still had problem for external temperature sensor case.
How about we change the core not to make duplicate thermal zone if it already
existed. It's not the common case, but it looks worthy.

like as below,

static int psy_register_thermal(struct power_supply *psy)
{
...
+	if (psy->tzd)
+		return 0;
...

We also needs some modification at charger-manager driver, however we can avoid
recursive call problem with this way :)

Thanks,
Jonghwa

> Best regards,
> Krzysztof
> 
> 
>>
>> Thanks,
>> Jonghwa.
>>
>>> Get rid of false lockdep alert and recursive call by accessing fuel gauge
>>> temperature through power supply property instead of thermal zone API.
>>>
>>
>>> Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
>>> ---
>>>  drivers/power/charger-manager.c       | 21 +++++++++++----------
>>>  include/linux/power/charger-manager.h |  2 --
>>>  2 files changed, 11 insertions(+), 12 deletions(-)
>>>
>>> diff --git a/drivers/power/charger-manager.c b/drivers/power/charger-manager.c
>>> index c1ed3c99c059..871fb91429c8 100644
>>> --- a/drivers/power/charger-manager.c
>>> +++ b/drivers/power/charger-manager.c
>>> @@ -559,16 +559,18 @@ static int cm_get_battery_temperature(struct charger_manager *cm,
>>>  	if (!cm->desc->measure_battery_temp)
>>>  		return -ENODEV;
>>>  
>>> -#ifdef CONFIG_THERMAL
>>> -	ret = thermal_zone_get_temp(cm->tzd_batt, (unsigned long *)temp);
>>> -	if (!ret)
>>> -		/* Calibrate temperature unit */
>>> -		*temp /= 100;
>>> -#else
>>> -	ret = cm->fuel_gauge->get_property(cm->fuel_gauge,
>>> +	if (IS_ENABLED(CONFIG_THERMAL) && cm->tzd_batt) {
>>> +		ret = thermal_zone_get_temp(cm->tzd_batt, (unsigned long *)temp);
>>> +		if (!ret)
>>> +			/* Calibrate temperature unit */
>>> +			*temp /= 100;
>>> +	} else {
>>> +		/* No external thermometer or no CONFIG_THERMAL */
>>> +		ret = cm->fuel_gauge->get_property(cm->fuel_gauge,
>>>  				POWER_SUPPLY_PROP_TEMP,
>>>  				(union power_supply_propval *)temp);
>>> -#endif
>>> +	}
>>> +
>>>  	return ret;
>>>  }
>>>  
>>> @@ -1501,9 +1503,8 @@ static int cm_init_thermal_data(struct charger_manager *cm)
>>>  		cm->charger_psy.num_properties++;
>>>  		cm->desc->measure_battery_temp = true;
>>>  	}
>>> -#ifdef CONFIG_THERMAL
>>> -	cm->tzd_batt = cm->fuel_gauge->tzd;
>>>  
>>> +#ifdef CONFIG_THERMAL
>>>  	if (ret && desc->thermal_zone) {
>>>  		cm->tzd_batt =
>>>  			thermal_zone_get_zone_by_name(desc->thermal_zone);
>>> diff --git a/include/linux/power/charger-manager.h b/include/linux/power/charger-manager.h
>>> index 07e7945a1ff2..743ed6d472c6 100644
>>> --- a/include/linux/power/charger-manager.h
>>> +++ b/include/linux/power/charger-manager.h
>>> @@ -256,9 +256,7 @@ struct charger_manager {
>>>  	struct power_supply *fuel_gauge;
>>>  	struct power_supply **charger_stat;
>>>  
>>> -#ifdef CONFIG_THERMAL
>>>  	struct thermal_zone_device *tzd_batt;
>>> -#endif
>>>  	bool charger_enabled;
>>>  
>>>  	unsigned long fullbatt_vchk_jiffies_at;
>>
> 
> 


