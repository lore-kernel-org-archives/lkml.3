Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932363AbaH0CcJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 22:32:09 -0400
Received: from hqemgate14.nvidia.com ([216.228.121.143]:6285 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932294AbaH0CcF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 22:32:05 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Tue, 26 Aug 2014 19:17:50 -0700
Message-ID: <53FD431B.40501@nvidia.com>
Date: Wed, 27 Aug 2014 10:31:55 +0800
From: Wei Ni <wni@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Eduardo Valentin <edubezval@gmail.com>
CC: <khali@linux-fr.org>, <linux@roeck-us.net>, <swarren@wwwdotorg.org>,
        <lm-sensors@lm-sensors.org>, <linux-tegra@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 3/4] thermal: add more description for thermal-zones
References: <1408948188-4181-1-git-send-email-wni@nvidia.com> <1408948188-4181-4-git-send-email-wni@nvidia.com> <20140825110711.GA12349@developer> <53FBF8F9.7070708@nvidia.com> <20140826120855.GA15219@developer>
In-Reply-To: <20140826120855.GA15219@developer>
X-Originating-IP: [10.19.224.131]
X-ClientProxiedBy: HKMAIL101.nvidia.com (10.18.16.10) To
 HKMAIL101.nvidia.com (10.18.16.10)
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/26/2014 08:08 PM, Eduardo Valentin wrote:
> Hi,
> 
> On Tue, Aug 26, 2014 at 11:03:21AM +0800, Wei Ni wrote:
>> On 08/25/2014 07:07 PM, Eduardo Valentin wrote:
>>> Hello Wei Ni,
>>>
>>> On Mon, Aug 25, 2014 at 02:29:47PM +0800, Wei Ni wrote:
>>>> Add more description for the "polling-delay" property.
>>>> Set "trips" and "cooling maps" as optional property, because
>>>> if missing these two sub-nodes, the thermal zone device still
>>>> work properly.
>>>>
>>>> Signed-off-by: Wei Ni <wni@nvidia.com>
>>>> ---
>>>>  Documentation/devicetree/bindings/thermal/thermal.txt | 10 ++++++----
>>>>  1 file changed, 6 insertions(+), 4 deletions(-)
>>>>
>>>> diff --git a/Documentation/devicetree/bindings/thermal/thermal.txt b/Documentation/devicetree/bindings/thermal/thermal.txt
>>>> index f5db6b7..e3d3ed9 100644
>>>> --- a/Documentation/devicetree/bindings/thermal/thermal.txt
>>>> +++ b/Documentation/devicetree/bindings/thermal/thermal.txt
>>>> @@ -136,8 +136,8 @@ containing trip nodes and one sub-node containing all the zone cooling maps.
>>>>  
>>>>  Required properties:
>>>>  - polling-delay:	The maximum number of milliseconds to wait between polls
>>>> -  Type: unsigned	when checking this thermal zone.
>>>> -  Size: one cell
>>>> +  Type: unsigned	when checking this thermal zone. If this value is 0, the
>>>> +  Size: one cell	driver will not run polling queue, but just cancel it.
>>>>  
>>>
>>> The description above is specific to Linux kernel implementation
>>> nomenclature. DT description needs to be OS agnostic.
>>
>> Normally, the user may think a delay of 0 means that software
>> continually polls this zone, but in here it mean no polling. May be it's
>> better to add this description.
>>
> 
> Sure, I am fine adding it. Just please do not use Linux specific
> nomenclature.

Yes, you are right, I will just add "Cancel the polling if the delay is 0".

Wei.

> 
>>>
>>>>  - polling-delay-passive: The maximum number of milliseconds to wait
>>>>    Type: unsigned	between polls when performing passive cooling.
>>>> @@ -148,14 +148,16 @@ Required properties:
>>>>    phandles + sensor
>>>>    specifier
>>>>  
>>>> +Optional property:
>>>>  - trips:		A sub-node which is a container of only trip point nodes
>>>>    Type: sub-node	required to describe the thermal zone.
>>>>  
>>>>  - cooling-maps:		A sub-node which is a container of only cooling device
>>>>    Type: sub-node	map nodes, used to describe the relation between trips
>>>> -			and cooling devices.
>>>> +			and cooling devices. If missing the "trips" property,
>>>> +			This sub-node will not be parsed, because no trips can
>>>> +			be bound to cooling devices.
>>>
>>> Do you mean if the thermal zone misses the "trips" property? Actually,
>>> the binding describes both, cooling-maps and trips, as required
>>> properties. Thus, both needs to be in place to consider the thermal zone
>>> as a proper described zone.
>>>
>>>>  
>>>> -Optional property:
>>>>  - coefficients:		An array of integers (one signed cell) containing
>>>>    Type: array		coefficients to compose a linear relation between
>>>>    Elem size: one cell	the sensors listed in the thermal-sensors property.
>>>> -- 
>>>> 1.8.1.5
>>>>
>>

