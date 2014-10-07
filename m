Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753968AbaJGNFl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 09:05:41 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:16570 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753285AbaJGNFh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 09:05:37 -0400
X-AuditID: cbfee691-f79b86d000004a5a-54-5433e519acfd
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 8BIT
Message-id: <5433E518.40300@samsung.com>
Date: Tue, 07 Oct 2014 22:05:28 +0900
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
 <5433BE0D.6000306@samsung.com> <1412686205.15309.1.camel@AMDC1943>
In-reply-to: <1412686205.15309.1.camel@AMDC1943>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrOIsWRmVeSWpSXmKPExsWyRsSkQFfyqXGIwYmNghYHt2paXP/ynNVi
	0pP3zBYTV05mtnj9wtDi8q45bBafe48wWtxuXMFmcXp3iQOnx4T+T4weO2fdZffYvELLY9Oq
	TjaPvi2rGD0+b5ILYIvisklJzcksSy3St0vgyth2cw1bwTapipfHN7I0MJ4Q7WLk5JAQMJHY
	v/kzO4QtJnHh3nq2LkYuDiGBpYwS87ZNYoIpWjDvFCNEYhGjxMpbL5hBErwCghI/Jt9jAbGZ
	BdQlJs1bxAxhi0gcXHufHcLWlli28DUzRPNrRonbyxYBTeIAataQuNzDC1LDIqAq8XX3HbB6
	NgE5ibdN3xhBbFGBMImrE46DzRcRMJQ4uHs7E8gcZoFNTBLrXs4BSwgLhEjsnnkJasFFRolV
	19eygiQ4BQwkppxdAPXCS3aJFa/kIbYJSHybfIgF5AgJAVmJTQeYIUokJQ6uuMEygVF8FpLf
	ZiH5bRaS32Yh+W0BI8sqRtHUguSC4qT0IlO94sTc4tK8dL3k/NxNjMD4Pf3v2cQdjPcPWB9i
	FOBgVOLhXaFlHCLEmlhWXJl7iNEU6KKJzFKiyfnAJJFXEm9obGZkYWpiamxkbmmmJM6rI/0z
	WEggPbEkNTs1tSC1KL6oNCe1+BAjEwenVAMjv+9rh6Wy9X6PTHIWHN25+33y/MuiN5+8uyCg
	KdKWnZvBt8ojRV/upEd9xaZaM9Y1r+59Y9i12i33hcTB55sNFvqyyC/gD3p9itviRF3J/XWP
	34ZvO3YpfuLP4lmytStv/s/ebv79822TTU7Sq2/38pUf4GwSeHT+nlnsIbG7j8IO+Gx7U/5B
	QomlOCPRUIu5qDgRAH6RTEzaAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrBIsWRmVeSWpSXmKPExsVy+t9jAV3Jp8YhBnsXcFoc3Kppcf3Lc1aL
	SU/eM1tMXDmZ2eL1C0OLy7vmsFl87j3CaHG7cQWbxendJQ6cHhP6PzF67Jx1l91j8wotj02r
	Otk8+rasYvT4vEkugC2qgdEmIzUxJbVIITUvOT8lMy/dVsk7ON453tTMwFDX0NLCXEkhLzE3
	1VbJxSdA1y0zB+gkJYWyxJxSoFBAYnGxkr4dpgmhIW66FjCNEbq+IUFwPUYGaCBhDWPGp60n
	WAt+SVZ0/PjB0sDYI9rFyMkhIWAisWDeKUYIW0ziwr31bF2MXBxCAosYJVbeesEMkuAVEJT4
	MfkeSxcjBwezgLzEkUvZIGFmAXWJSfMWMUPUv2aUuL1sESNIDa+AhsTlHl6QGhYBVYmvu++w
	g9hsAnISb5u+ge0SFQiTuDrhOAuILSJgKHFw93YmkDnMApuYJNa9nAOWEBYIkdg98xLUgouM
	Equur2UFSXAKGEhMObuAaQKjwCwk981CuG8WkvsWMDKvYhRNLUguKE5KzzXUK07MLS7NS9dL
	zs/dxAiO9WdSOxhXNlgcYhTgYFTi4V2hZRwixJpYVlyZe4hRgoNZSYT39EWgEG9KYmVValF+
	fFFpTmrxIUZToPcmMkuJJucD01BeSbyhsYmZkaWRuaGFkbG5kjjvgVbrQCGB9MSS1OzU1ILU
	Ipg+Jg5OqQbG7XpSh+e0TC24fyw0Rr3g1vU3obI359jsD1Btvde+I1h3HfOj8Dk3z9xszzRv
	qWhV45qxXGR/19GihZcO3OXb3xt+yerhiXVLld0LuhTYiv8FK/z6qHQjv+5m655DOm7TzNZG
	zFl6SGXrz6ZSPsk2Jc0ZjTNE3ob7GKUIKjEGu4dMyjU19lunxFKckWioxVxUnAgAriVZBgsD	AAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014년 10월 07일 21:50, Krzysztof Kozlowski wrote:

> On wto, 2014-10-07 at 19:18 +0900, jonghwa3.lee@samsung.com wrote:
>> On 2014년 10월 07일 16:13, Krzysztof Kozlowski wrote:
>>
>>>
>>> On wto, 2014-10-07 at 11:20 +0900, jonghwa3.lee@samsung.com wrote:
>>>> Hi,
>>>> On 2014년 10월 07일 01:00, Krzysztof Kozlowski wrote:
>>>>
>>>>> The charger manager supports POWER_SUPPLY_PROP_TEMP property and acts
>>>>> as a thermal zone if any of these conditions match:
>>>>> 1. Fuel gauge used by charger manager supports POWER_SUPPLY_PROP_TEMP.
>>>>> 2. 'cm-thermal-zone' property is present in DTS (then it will supersede
>>>>>    the fuel gauge temperature property).
>>>>>
>>>>> However in case 1 (fuel gauge reports temperature and 'cm-thermal-zone'
>>>>> is not set) the charger manager forwards its get_temp calls to fuel
>>>>> gauge thermal zone.
>>>>>
>>>>> This leads to reporting by lockdep a false positive deadlock for thermal
>>>>> zone's mutex because of nested calls to thermal_zone_get_temp(). This is
>>>>> false positive because these are different mutexes: one for charger
>>>>> manager thermal zone and second for fuel gauge thermal zone.
>>>>>
>>>>
>>>>
>>>> Yes, this happens because power_supply_subsystem automatically creates
>>>> thermal_zone when POWER_SUPPLY_PROP_TEMP is available at the time of
>>>> power_supply registering. And as you point out, it makes duplicate thermal_zone
>>>> when some power_supply references other power_supply's. I hope it would become
>>>> to be a selectable option or change the manner of charger-manager itself (if the
>>>> charger-manager is only one who references other power_supply's temperature
>>>> sensing ability).
>>>>
>>>> Anyway, the code looks fine to me.
>>>>
>>>> Acked-by : Jonghwa Lee <jonghwa3.lee@samsung.com>
>>>
>>> Thank you for looking at patch. However later I started to wonder
>>> whether my fix is sufficient. For the case when fuel gauge is used as
>>> source of temperature it is. But for the case when external sensor is
>>> used it is not - still there will be recursive call and false positive
>>> from lockdep.
>>>
>>> Also minor fix is needed in my patch - s/IS_ENABLED/config_enabled/.
>>>
>>> I can send a v2 fixing this but first question - what about second
>>> recursive issue (when external sensor is used instead of fuel gauge)?
>>>
>>
>>
>> Yes, you're right, it still had problem for external temperature sensor case.
>> How about we change the core not to make duplicate thermal zone if it already
>> existed. It's not the common case, but it looks worthy.
>>
>> like as below,
>>
>> static int psy_register_thermal(struct power_supply *psy)
>> {
>> ...
>> +	if (psy->tzd)
>> +		return 0;
>> ...
>>
>> We also needs some modification at charger-manager driver, however we can avoid
>> recursive call problem with this way :)
> 
> Yes, that would remove recursive call but this would also remove thermal
> zone for charger manager's power supply. Does anyone (user space?)
> depend and use charger managers thermal zone?
> 


AFAIK, no,, charger manager's thermal zone means nothing but just replica of
other thermal zone related with battery. It is better to remove it.

Thanks,
Jonghwa.

> Best regards,
> Krzysztof
> 
> 


