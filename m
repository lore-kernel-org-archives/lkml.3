Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753230AbaFRVzj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 17:55:39 -0400
Received: from mail-oa0-f53.google.com ([209.85.219.53]:64944 "EHLO
	mail-oa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751106AbaFRVzg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 17:55:36 -0400
Message-ID: <53A20AD5.7080207@ti.com>
Date: Wed, 18 Jun 2014 16:55:33 -0500
From: Nishanth Menon <nm@ti.com>
Reply-To: nm@ti.com
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: balbi@ti.com
CC: devicetree@vger.kernel.org, linux@arm.linux.org.uk,
        Tony Lindgren <tony@atomide.com>, Rajendra Nayak <rnayak@ti.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        r.sricharan@ti.com, robh+dt@kernel.org,
        Benoit Cousson <bcousson@baylibre.com>, galak@codeaurora.org,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v2 1/2] arm: dts: am4372: let boards enable RTC and Watchdog
References: <1403106200-777-1-git-send-email-balbi@ti.com> <1403106200-777-2-git-send-email-balbi@ti.com> <53A1B677.9010909@ti.com> <20140618192553.GB4570@saruman.home> <53A20800.3070301@ti.com> <20140618215143.GA8181@saruman.home>
In-Reply-To: <20140618215143.GA8181@saruman.home>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/18/2014 04:51 PM, Felipe Balbi wrote:
> Hi,
>
> On Wed, Jun 18, 2014 at 04:43:28PM -0500, Nishanth Menon wrote:
>> On 06/18/2014 02:25 PM, Felipe Balbi wrote:
>>> Hi,
>>>
>>> On Wed, Jun 18, 2014 at 10:55:35AM -0500, Nishanth Menon wrote:
>>>> $subject - ARM: dts:
>>>>
>>>> On 06/18/2014 10:43 AM, Felipe Balbi wrote:
>>>>> by providing phandles to rtc and wdt nodes, we can
>>>>> let boards enable rtc and wdt as necessary.
>>>>>
>>>>> Signed-off-by: Felipe Balbi <balbi@ti.com>
>>>>> ---
>>>>>   arch/arm/boot/dts/am4372.dtsi | 4 ++--
>>>>>   1 file changed, 2 insertions(+), 2 deletions(-)
>>>>>
>>>>> diff --git a/arch/arm/boot/dts/am4372.dtsi b/arch/arm/boot/dts/am4372.dtsi
>>>>> index 49fa596..e3830d4 100644
>>>>> --- a/arch/arm/boot/dts/am4372.dtsi
>>>>> +++ b/arch/arm/boot/dts/am4372.dtsi
>>>>> @@ -270,7 +270,7 @@
>>>>>   			ti,hwmods = "counter_32k";
>>>>>   		};
>>>>>
>>>>> -		rtc@44e3e000 {
>>>>> +		rtc: rtc@44e3e000 {
>>>>>   			compatible = "ti,am4372-rtc","ti,da830-rtc";
>>>>>   			reg = <0x44e3e000 0x1000>;
>>>>>   			interrupts = <GIC_SPI 75 IRQ_TYPE_LEVEL_HIGH
>>>>> @@ -279,7 +279,7 @@
>>>>>   			status = "disabled";
>>>>>   		};
>>>>>
>>>>> -		wdt@44e35000 {
>>>>> +		wdt: wdt@44e35000 {
>>>>>   			compatible = "ti,am4372-wdt","ti,omap3-wdt";
>>>>>   			reg = <0x44e35000 0x1000>;
>>>>>   			interrupts = <GIC_SPI 91 IRQ_TYPE_LEVEL_HIGH>;
>>>>>
>>>> we might want to fix up any other similar nodes in dtsi as well, no?
>>>>
>>>> examples:
>>>> cpu@0
>>>
>>> and why would you want boards to mess with the cpu node ?
>>>
>> cpu-supply = <&regulator>;
>>
>> for cpufreq.
>
> good point, but does thqt even work with AM437x devices in mainline?

it will once we are done adding a node. context here being - if you are 
fixing phandles, please fix them all up.. that is a little nice to do.

I wont argue more on this. I will leave it to maintainers.

--
Regards,
Nishanth Menon

