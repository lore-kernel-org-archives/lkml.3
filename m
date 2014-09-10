Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751959AbaIJIOY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 04:14:24 -0400
Received: from hqemgate14.nvidia.com ([216.228.121.143]:2316 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751044AbaIJIOU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 04:14:20 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Wed, 10 Sep 2014 01:12:58 -0700
Message-ID: <5410084A.9020302@nvidia.com>
Date: Wed, 10 Sep 2014 16:14:02 +0800
From: Wei Ni <wni@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Eduardo Valentin <edubezval@gmail.com>
CC: Jean Delvare <jdelvare@suse.de>, Guenter Roeck <linux@roeck-us.net>,
        Stephen Warren <swarren@wwwdotorg.org>, <lm-sensors@lm-sensors.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 3/4] thermal: add more description for thermal-zones
References: <53FBEE39.2020001@nvidia.com> <20140826121210.GB15219@developer> <53FD484F.7030504@nvidia.com> <20140827133217.GB15875@developer> <53FE8AC9.2070907@nvidia.com> <20140828132135.GA17074@developer> <53FFED7B.6010508@nvidia.com> <CAC-25o-9OQ-wfpCJmgDGB0kqDHwUc15XX7Ay7Pes6UmpJakUkQ@mail.gmail.com> <540449BC.2050807@nvidia.com> <54098538.1000505@nvidia.com> <20140830194318.GA3025@developer>
In-Reply-To: <20140830194318.GA3025@developer>
X-Originating-IP: [10.19.224.131]
X-ClientProxiedBy: HKMAIL104.nvidia.com (10.18.16.13) To
 HKMAIL101.nvidia.com (10.18.16.10)
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/31/2014 03:43 AM, Eduardo Valentin wrote:
> 
> Hello Wei,
> 
> On Fri, Sep 05, 2014 at 05:41:12PM +0800, Wei Ni wrote:
>> Hi, Eduardo
>>
>> On 09/01/2014 06:26 PM, Wei Ni wrote:
>>> On 08/29/2014 07:32 PM, edubezval@gmail.com wrote:
>>>> Hello Wei,
>>>>
>>>> On Thu, Aug 28, 2014 at 11:03 PM, Wei Ni <wni@nvidia.com> wrote:
>>>>> On 08/28/2014 09:21 PM, Eduardo Valentin wrote:
>>>>>> Hello Wei,
>>>>>>
>>>>>> On Thu, Aug 28, 2014 at 09:50:01AM +0800, Wei Ni wrote:
>>>>>>> On 08/27/2014 09:32 PM, Eduardo Valentin wrote:
>>>>>>>> Hello Wei,
>>>>>>>>
>>>>>>>> On Wed, Aug 27, 2014 at 10:54:07AM +0800, Wei Ni wrote:
>>>>>>>>> On 08/26/2014 08:12 PM, Eduardo Valentin wrote:
>>>>>>>>>> On Tue, Aug 26, 2014 at 10:17:29AM +0800, Wei Ni wrote:
>>>>>>>>>>> On 08/25/2014 07:07 PM, Eduardo Valentin wrote:
>>>>>>>>>>>> Hello Wei Ni,
>>>>>>>>>>>>
>>>>>>>>>>>> On Mon, Aug 25, 2014 at 02:29:47PM +0800, Wei Ni wrote:
>>>>>>>>>>>>> Add more description for the "polling-delay" property.
>>>>>>>>>>>>> Set "trips" and "cooling maps" as optional property, because
>>>>>>>>>>>>> if missing these two sub-nodes, the thermal zone device still
>>>>>>>>>>>>> work properly.
>>>>>>>>>>>>>
>>>>>>>>>>>>> Signed-off-by: Wei Ni <wni@nvidia.com>
>>>>>>>>>>>>> ---
>>>>>>>>>>>>>  Documentation/devicetree/bindings/thermal/thermal.txt | 10 ++++++----
>>>>>>>>>>>>>  1 file changed, 6 insertions(+), 4 deletions(-)
>>>>>>>>>>>>>
>>>>>>>>>>>>> diff --git a/Documentation/devicetree/bindings/thermal/thermal.txt b/Documentation/devicetree/bindings/thermal/thermal.txt
>>>>>>>>>>>>> index f5db6b7..e3d3ed9 100644
>>>>>>>>>>>>> --- a/Documentation/devicetree/bindings/thermal/thermal.txt
>>>>>>>>>>>>> +++ b/Documentation/devicetree/bindings/thermal/thermal.txt
>>>>>>>>>>>>> @@ -136,8 +136,8 @@ containing trip nodes and one sub-node containing all the zone cooling maps.
>>>>>>>>>>>>>
>>>>>>>>>>>>>  Required properties:
>>>>>>>>>>>>>  - polling-delay:      The maximum number of milliseconds to wait between polls
>>>>>>>>>>>>> -  Type: unsigned      when checking this thermal zone.
>>>>>>>>>>>>> -  Size: one cell
>>>>>>>>>>>>> +  Type: unsigned      when checking this thermal zone. If this value is 0, the
>>>>>>>>>>>>> +  Size: one cell      driver will not run polling queue, but just cancel it.
>>>>>>>>>>>>>
>>>>>>>>>>>>
>>>>>>>>>>>> The description above is specific to Linux kernel implementation
>>>>>>>>>>>> nomenclature. DT description needs to be OS agnostic.
>>>>>>>>>>>>
>>>>>>>>>>>>>  - polling-delay-passive: The maximum number of milliseconds to wait
>>>>>>>>>>>>>    Type: unsigned      between polls when performing passive cooling.
>>>>>>>>>>>>> @@ -148,14 +148,16 @@ Required properties:
>>>>>>>>>>>>>    phandles + sensor
>>>>>>>>>>>>>    specifier
>>>>>>>>>>>>>
>>>>>>>>>>>>> +Optional property:
>>>>>>>>>>>>>  - trips:              A sub-node which is a container of only trip point nodes
>>>>>>>>>>>>>    Type: sub-node      required to describe the thermal zone.
>>>>>>>>>>>>>
>>>>>>>>>>>>>  - cooling-maps:               A sub-node which is a container of only cooling device
>>>>>>>>>>>>>    Type: sub-node      map nodes, used to describe the relation between trips
>>>>>>>>>>>>> -                      and cooling devices.
>>>>>>>>>>>>> +                      and cooling devices. If missing the "trips" property,
>>>>>>>>>>>>> +                      This sub-node will not be parsed, because no trips can
>>>>>>>>>>>>> +                      be bound to cooling devices.
>>>>>>>>>>>>
>>>>>>>>>>>> Do you mean if the thermal zone misses the "trips" property? Actually,
>>>>>>>>>>>> the binding describes both, cooling-maps and trips, as required
>>>>>>>>>>>> properties. Thus, both needs to be in place to consider the thermal zone
>>>>>>>>>>>> as a proper described zone.
>>>>>>>>>>>
>>>>>>>>>>> I moved the "trips" and "cooling-maps" to optional property, because if
>>>>>>>>>>> missing these two properties, the thermal zone devices still can be
>>>>>>>>>>> registered, and the driver can work properly, it has the basic function,
>>>>>>>>>>> can read temperature from thermal sysfs, although it doesn't have trips
>>>>>>>>>>> and bind with cooling devices.
>>>>>>>>>>
>>>>>>>>>>
>>>>>>>>>> If a thermal zone is used only for monitoring, then I believe it lost
>>>>>>>>>> its purpose. As  Maybe a different framework shall be used, such as hwmon,
>>>>>>>>>> for instance?
>>>>>>>>>
>>>>>>>>> Yes, if we only use it for monitoring, we can use hwmon. But we have
>>>>>>>>> more functions base on these two thermal zone devices. We have a
>>>>>>>>> skin-temperature driver, which used nct1008's remote and local
>>>>>>>>> temperatures to estimator the skin temperature. As you know the thermal
>>>>>>>>> framework is more powerful, the remote/local sensors can be register as
>>>>>>>>> thermal zone, then the skin-temp driver can use thermal_zone_get_temp()
>>>>>>>>> to read their temperatures and then estimator skin's temp. We also will
>>>>>>>>> set trips and cooling devices for this skin-temp.
>>>>>>>>
>>>>>>>> In this case, don't you think it would make sense to create a thermal
>>>>>>>> zone for the skin temperature and add the required sensors (including
>>>>>>>> the nct1008) in it?
>>>>>>>
>>>>>>> Hi, Eduardo
>>>>>>> Yes, we will create a thermal zone for the skin-temp driver and add the
>>>>>>> required sensors in it, but in here we want to register these required
>>>>>>> sensors as thermal zone devices, then the thermal framework can export
>>>>>>> functions to read these sensors temperature. If use hwmon framework, it
>>>>>>> can't export nct1008's internal sensors, such as remote/local sensors,
>>>>>>> and no exported functions to read these temperatures. If we doesn't use
>>>>>>> the thermal/of-thermal framework, we have to develop a new framework to
>>>>>>> parse those sensor nodes, and I think this new one may only have slight
>>>>>>> difference with current thermal framework.
>>>>>>> If we set those two properties as optional property, then we can use it
>>>>>>> in this case simply.
>>>>>>>
>>>>>>> The skin-temp nodes will something like this:
>>>>>>>
>>>>>>> skin_temp: therm-est {
>>>>>>>      compatible = "nvidia,tegra124-therm-est";
>>>>>>>
>>>>>>>      #thermal-sensor-cells = <0>;
>>>>>>>
>>>>>>>      sub-devs {
>>>>>>>              dev@0 {
>>>>>>> /* we need to register nct1008_remote as thermal zone devices, so that
>>>>>>> it's easy to handle it by using thermal framework's exported functions. */
>>>>>>>                      dev = <&nct1008_remote>;
>>>>>>>              };
>>>>>>>              dev@1 {
>>>>>>>                      dev = <&nct1008_local>;
>>>>>>>              };
>>>>>>>      };
>>>>>>> };
>>>>>>>
>>>>>>> thermal-zones {
>>>>>>>      skin-therm {
>>>>>>>              polling-delay-passive = <15000>
>>>>>>>              polling-delay = <0>;
>>>>>>>
>>>>>>>              thermal-sensors = <&skin_temp>;
>>>>>>
>>>>>> The binding allows you to add several sensors in one thermal zone.
>>>>>> Please have a look on the example (c) of the thermal.txt binding
>>>>>> description. It might be that what you want to do is actually:
>>>>>>               thermal-sensors = <&ntc1008_local>,
>>>>>>                               <&ntc1008_remote>;
>>>>>
>>>>>
>>>>> Yes, we have considered it, but in current kernel, it only supports 1
>>>>> sensor per zone. and according to the example (c), it's supposed to only
>>>>> support simple algorithm, such as:
>>>>> /* hotspot = 100 * bandgap - 120 * adc + 484 */
>>>>>  coefficients =          <100    -120    484>;
>>>>>
>>>>> but in our skin-temp driver, we will recored 20 history temperatures for
>>>>> every sensors, and set different coefficients for every history
>>>>> temperatures, our HW team have private mathematical mode to calculate
>>>>> these coeffs for different boards. And I think other users may use
>>>>> different algorithm to calculate thermal zone temperature based on
>>>>> several sensors.
>>>>>
>>>>> So I think it's better to register sensors to thermal zones, not set
>>>>> trips and binding cooling devices, then user's thermal driver can use
>>>>> them freely.
>>>>>
>>>>
>>>> In your system, the used governor is userspace, then?
>>>
>>> No, we developed a new governor named as "pid governor", it manages
>>> thermals based on output values of PID controller.
> 
> Have you tried the patch set from Javi? the power allocator schem 
> includes a PID controller governor. Might be worth having a common
> solution. I think it is easier if I merge his changes into a branch and
> you have try on it. His patch series have already gone through several
> reviews. But you are free to comment too.

Oh, it's great, could you show me link of the patch set, so that I can
try it.

> 
>>>
>>> Indeed, our thermal management includes skin-temp, soc-thermal,
>>> cpu-throttle driver and pid governor. This pach set is prepared for the
>>> skin-temp driver.
>>> As you know the tegra soc-therm is in upstreaming, and we will post
>>> other drivers step by step.
>>
>> Will you take this patch, if so i will post skin-temp driver later.
>> Looking forward your comments :)
>>
> 
> I am afraid moving the maps and trips properties to optional abuses the
> purpose of the thermal DT. The primary goal is to describe hardware, and
> in this specific case, the hardware proper thermal operating conditions.
> 
> DT has to be as agnostic to OS implementation as possible.
> 
> For the above reason, I do not think this patch is a good idea.

Yes, I understand what you are worrying about, but it seems it's
difficult to handle this specific case in current framework or even
develop a new framework. How about to still set trips and maps as
required properties, but just add description something like "If missing
it, the thermal zone only has basic function such as reading temperature"

Thanks.
Wei.

> 
> 
> Cheers,
> 
>> Thanks.
>> Wei.
>>
>>>
>>> Thanks.
>>> Wei.
>>>
>>>>
>>>>> Thanks.
>>>>> Wei.
>>>>>
>>>>>>
>>>>>>
>>>>>>>
>>>>>>>              trips {
>>>>>>>              };
>>>>>>>              cooling-maps {
>>>>>>>              };
>>>>>>>      };
>>>>>>> };
>>>>>>>
>>>>>>> Wei.
>>>>>>>>
>>>>>>>>>
>>>>>>>>> Wei.
>>>>>>>>>
>>>>>>>>>>
>>>>>>>>>> The purpose of a thermal zone is to describe thermal behavior of a
>>>>>>>>>> hardware. As it is mentioned in the thermal.txt file.
>>>>>>>>>>
>>>>>>>>>>
>>>>>>>>>>>
>>>>>>>>>>> Thanks.
>>>>>>>>>>> Wei.
>>>>>>>>>>>
>>>>>>>>>>>>
>>>>>>>>>>>>>
>>>>>>>>>>>>> -Optional property:
>>>>>>>>>>>>>  - coefficients:               An array of integers (one signed cell) containing
>>>>>>>>>>>>>    Type: array         coefficients to compose a linear relation between
>>>>>>>>>>>>>    Elem size: one cell the sensors listed in the thermal-sensors property.
>>>>>>>>>>>>> --
>>>>>>>>>>>>> 1.8.1.5
>>>>>>>>>>>>>
>>>>>>>>>>>
>>>>>>>>>> --
>>>>>>>>>> To unsubscribe from this list: send the line "unsubscribe linux-tegra" in
>>>>>>>>>> the body of a message to majordomo@vger.kernel.org
>>>>>>>>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>>>>>>>>
>>>>>>>>>
>>>>>>>
>>>>>
>>>>
>>>>
>>>>
>>>
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-tegra" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>
>>

