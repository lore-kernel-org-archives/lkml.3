Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752814Ab3E3LpH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 07:45:07 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:46170 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751848Ab3E3LpB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 07:45:01 -0400
Message-ID: <51A73B97.2020701@ti.com>
Date: Thu, 30 May 2013 13:44:23 +0200
From: Benoit Cousson <b-cousson@ti.com>
Organization: Texas Instruments
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Stephen Warren <swarren@wwwdotorg.org>
CC: "Mohammed, Afzal" <afzal@ti.com>, Jon Hunter <jgchunter@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Grant Likely <grant.likely@linaro.org>,
        Benoit Cousson <benoit.cousson@linaro.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v2 11/14] Documentation: dt: binding: omap: am43x timer
References: <cover.1369658705.git.afzal@ti.com> <223d90dc9eeab13d8496690d336cdf0f7d27cd22.1369658705.git.afzal@ti.com> <51A520B5.8040803@gmail.com> <51A52A16.1040204@wwwdotorg.org> <C8443D0743D26F4388EA172BF4E2A7A93EAFB044@DBDE04.ent.ti.com> <51A5BEB6.6070809@ti.com> <51A61E60.4070708@wwwdotorg.org>
In-Reply-To: <51A61E60.4070708@wwwdotorg.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

On 05/29/2013 05:27 PM, Stephen Warren wrote:
> On 05/29/2013 02:39 AM, Benoit Cousson wrote:
>> Hi Afzal,
>>
>> On 05/29/2013 10:06 AM, Mohammed, Afzal wrote:
>>> Hi Jon,
>>>
>>> On Wed, May 29, 2013 at 03:35:10, Stephen Warren wrote:
>>>> On 05/28/2013 03:25 PM, Jon Hunter wrote:
>>>
>>>>>>  			ti,am335x-timer	(applicable to AM335x devices)
>>>>>>  			ti,am335x-timer-1ms (applicable to AM335x devices)
>>>>>> +			"ti,am4372-timer-1ms", "ti,am335x-timer-1ms" for AM43x 1ms timer
>>>>>> +			"ti,am4372-timer", "ti,am335x-timer" for AM43x timers other than 1ms one
>>>
>>>>> If you are adding more compatibility strings, then this implies that the
>>>>> AM43x timers are not 100% compatible with any other device listed (such
>>>>> as am335x or any omap device). That's fine but you should state that in
>>>>> the changelog. If the AM43x timer registers are 100% compatible with
>>>>> existing devices you should not add these.
>>>>
>>>> I'm not sure that's true; .dts files should always include a compatible
>>>> value that describes the most specific model of the HW, plus any
>>>> baseline compatible value that the HW is compatible with. This allows
>>>> any required quirks/fixes/... to be applied for the specific HW model
>>>> later even if nobody knows right now they'll be needed. Hence, defining
>>>> new compatible values doesn't necessarily mean incompatible HW.
>>>
>>> Stephen took words out of my finger ;)
>>>  
>>> Some explanations,I don;t 
>>>
>>> 1. first compatible should be exact device [A], followed by compatible
>>> model (if one)
>>> 2. Minor effort in getting DT right the first time may help prevent
>>> difficult effort later modifying it (if a necessity comes), considering
>>> the fact that DT sources has  to move out of Kernel at some point of
>>> time. And DT is not supposed to be modified, which may cause difficulty
>>> for the users (I had been a minor victim of this during rebase).
>>>
>>> As we both were in GPMC land earlier, an example,
>>>
>>> If my memory is right, GPMC IP in am335x is rev 6, and IP has 8 chip
>>> select, but one is not pinned out. Now assume that same IP is integrated
>>> in another SoC (probably OMAP4 has rev 6). Here if we use same compatible
>>> for both, driver cannot handle it properly (w/o knowledge about platform).
>>> But if exact compatible is mentioned, without modifying DT (which should
>>> be considered as a firmware) just by modifying Kernel, deciding based on
>>> compatible would help achieve what is required.
>>
>> That's true for the DTS itself, but here your are changing the binding
>> documentation which is supposed to reflect the driver "interface" in the
>> Device Tree model description.
>>
>> Since the driver does not support any new compatible string, you should
>> not update the binding.
> 
> I don't agree here; the DT binding should define all the required and/or
> allowed values that must/should/can be present in the DT - the entire
> legal schema. The set of all compatible values is included in that,
> irrespective of whether a particular value actually (currently) defines
> a different HW interface or not.

Well, I tend to agree on the principle, but so far it was never really
done like that. That's not necessarily a good excuse, but if we start
adding new bindings for the huge number of OMAP|AM variants TI has been
introduced for 10 years, I'd rather use a wildcard than a exhaustive
list of all the devices.
Something like ti,[omap|am]*-timer for example .

Regards,
Benoit

