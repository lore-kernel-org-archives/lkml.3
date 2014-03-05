Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757402AbaCEEaS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 23:30:18 -0500
Received: from hqemgate14.nvidia.com ([216.228.121.143]:14626 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755460AbaCEEaQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 23:30:16 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Tue, 04 Mar 2014 20:26:00 -0800
Message-ID: <5316A868.7000908@nvidia.com>
Date: Wed, 5 Mar 2014 12:30:32 +0800
From: Wei Ni <wni@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Stephen Warren <swarren@wwwdotorg.org>
CC: Guenter Roeck <linux@roeck-us.net>,
        "khali@linux-fr.org" <khali@linux-fr.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>
Subject: Re: [PATCH v2 3/3] ARM: tegra: dalmore: add thermal zones for nct1008
References: <1393932664-13319-1-git-send-email-wni@nvidia.com> <1393932664-13319-4-git-send-email-wni@nvidia.com> <53164E78.5010708@wwwdotorg.org> <20140304222357.GA6125@roeck-us.net> <53168C5B.6070003@nvidia.com> <531692D2.6040204@wwwdotorg.org> <531694EB.50906@nvidia.com> <531696A9.6060906@wwwdotorg.org> <5316A785.8030504@nvidia.com>
In-Reply-To: <5316A785.8030504@nvidia.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/05/2014 12:26 PM, Wei Ni wrote:
> On 03/05/2014 11:14 AM, Stephen Warren wrote:
>> On 03/04/2014 08:07 PM, Wei Ni wrote:
>>> On 03/05/2014 10:58 AM, Stephen Warren wrote:
>>>> On 03/04/2014 07:30 PM, Wei Ni wrote:
>>>>> On 03/05/2014 06:23 AM, Guenter Roeck wrote:
>>>>>> On Tue, Mar 04, 2014 at 03:06:48PM -0700, Stephen Warren wrote:
>>>>>>> On 03/04/2014 04:31 AM, Wei Ni wrote:
>>>>>>>> Add dt node to describe the thermal zone for the nct1008.
>>>>>>>>
>>>>>>>> Change-Id: I0256836e52d73ec282574e4fd91df52958936e35
>>>>>>>
>>>>>>> ???????
>>>>>>>
>>>>>> I think this is for one of those open-source sites out there
>>>>>> which count open source contributions. Not Ohloh, but similar.
>>>>>> You have to specify that Change-Id to have it associate your
>>>>>> name with the patch.
>>>>>
>>>>> It's so sorry, I'm working for chromiumos, this change-id is generated
>>>>> by gerrit, I should remove it.
>>>>>
>>>>>>
>>>>>> Guenter
>>>>>>
>>>>>>>> diff --git a/arch/arm/boot/dts/tegra114-dalmore.dts b/arch/arm/boot/dts/tegra114-dalmore.dts
>>>>>>>
>>>>>>>> +	thermal-zones {
>>>>>>>> +		nct1008-local {
>>>>>>>> +			polling-delay-passive = <2000>; /* milliseconds */
>>>>>>>
>>>>>>> Nothing can possible make use of this node, since there's no compatible
>>>>>>> value or anything else like that to bind a driver to it.
>>>>>
>>>>> We have special Tskin driver that estimator skin temperature based on
>>>>> nct1008 local and remote sensors.
>>>>
>>>> Where? Anything that gets added to the upstream kernel DT files must be
>>>> supported by a driver and binding in the upstream kernel.
>>>
>>> I didn't submit the Tskin driver yet, but the of-thermal framework can
>>> parse this node, and create thermal zone devices.
>>
>> How is that possible? There's no compatible value for the of-thermal
>> framework to know that it should process this node. It's not correct for
>> the of-thermal framework to do anything like look for a node with a
>> particular name... has the DT binding for this been reviewed by any DT
>> maintainer?
> 
> Eduardo developed the of-thermal framework, and have merged in
> linux-next, it can parse the node thermal-zones, and properties, such as
> polling-delay-passive. Please check the omap.dtsi, it also has this node.

Please check Documentation/devicetree/bindings/thermal/thermal.txt

> 
>>
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-tegra" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

