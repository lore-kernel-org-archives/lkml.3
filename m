Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751508Ab3HBLIQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 07:08:16 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:41491 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750904Ab3HBLIO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 07:08:14 -0400
Message-ID: <51FB92F8.9020801@ti.com>
Date: Fri, 2 Aug 2013 16:37:36 +0530
From: Gururaja Hebbar <gururaja.hebbar@ti.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Mark Rutland <mark.rutland@arm.com>
CC: Sekhar Nori <nsekhar@ti.com>,
        "davinci-linux-open-source@linux.davincidsp.com" 
	<davinci-linux-open-source@linux.davincidsp.com>,
        "tony@atomide.com" <tony@atomide.com>,
        "benoit.cousson@gmail.com" <benoit.cousson@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "vaibhav.bedia@ti.com" <vaibhav.bedia@ti.com>,
        "benoit.cousson@linaro.org" <benoit.cousson@linaro.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [Patch V2 4/4] ARM: dts: AM33XX: update rtc node compatibility
References: <1372841225-18813-1-git-send-email-gururaja.hebbar@ti.com> <1372841225-18813-5-git-send-email-gururaja.hebbar@ti.com> <51F749B0.7020802@ti.com> <20130730145501.GA29859@e106331-lin.cambridge.arm.com> <51F7E7FA.3080702@ti.com> <20130801170537.GF8095@e106331-lin.cambridge.arm.com>
In-Reply-To: <20130801170537.GF8095@e106331-lin.cambridge.arm.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/1/2013 10:35 PM, Mark Rutland wrote:
> On Tue, Jul 30, 2013 at 05:21:14PM +0100, Sekhar Nori wrote:
>> On 7/30/2013 8:25 PM, Mark Rutland wrote:
>>> On Tue, Jul 30, 2013 at 06:05:52AM +0100, Gururaja Hebbar wrote:
>>>> Hi,
>>>>
>>>> On 7/3/2013 2:17 PM, Hebbar Gururaja wrote:
>>>>> Since AM33xx  RTC IP has RTC_IRQWAKEEN to support Alarm Wake-up.
>>>>>
>>>>> Update the rtc compatible property to "ti,am3352-rtc" to enable handling
>>>>> of this feature inside rtc-omap driver.
>>>>
>>>> The other 2 rtc driver related patches have been pulled up. If you have
>>>> no comments, can you please pull this up.
>>>>
>>>> Regards
>>>> Gururaja
>>>>
>>>>>
>>>>> Signed-off-by: Hebbar Gururaja <gururaja.hebbar@ti.com>
>>>>> ---
>>>>> :100644 100644 77aa1b0... dde180a... M	arch/arm/boot/dts/am33xx.dtsi
>>>>>    arch/arm/boot/dts/am33xx.dtsi |    2 +-
>>>>>    1 file changed, 1 insertion(+), 1 deletion(-)
>>>>>
>>>>> diff --git a/arch/arm/boot/dts/am33xx.dtsi b/arch/arm/boot/dts/am33xx.dtsi
>>>>> index 77aa1b0..dde180a 100644
>>>>> --- a/arch/arm/boot/dts/am33xx.dtsi
>>>>> +++ b/arch/arm/boot/dts/am33xx.dtsi
>>>>> @@ -297,7 +297,7 @@
>>>>>    		};
>>>>>
>>>>>    		rtc@44e3e000 {
>>>>> -			compatible = "ti,da830-rtc";
>>>>> +			compatible = "ti,am3352-rtc";
>>>
>>> Given that this is backwards compatible with the old binding, it would
>>> be nicer to have this as:
>>>
>>> 	compatible = "ti,am3352-rtc", "ti,da830-rtc";
>>>
>>> We must get into the habit of changing dts files in a
>>> backwards-compatible fashion.
>>
>> Right, I suggested this when v1 was posted. It turns out the current
>> kernel does not handle the compatilble list correctly and the string
>> selected actually depends on the order in which it appears in match
>> table in driver instead.
>>
>> I saw there were patches being discussed to fix this issue, but until
>> that is fixed, we cannot really use what you (and I before) suggested.
>
> A temporary solution would be to list the "ti,am3352-rtc" first in the
> of_match_table kernel-side.

If above method is followed, then it would cause trouble on davinci 
platform because this rtc-omap driver is also used by Davinci platform.
On davinci Plaform the driver would match with "ti,am3352-rtc" for 
compatible.

Regards
Gururaja

> That way you can keep the old compatible
> string in the dts compatible list, and maintain backwards compatibilty
> with older kernels.
>
> Later if the way Linux matches compatible strings is changed, this
> shouldn't break the probe order, and the of_match_table order could be
> changed.
>
> Have I missed something?
>
> Thanks,
> Mark.
>

