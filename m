Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753778Ab3HBOtm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 10:49:42 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:51720 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752675Ab3HBOtl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 10:49:41 -0400
Message-ID: <51FBC6F7.7050509@ti.com>
Date: Fri, 2 Aug 2013 20:19:27 +0530
From: George Cherian <george.cherian@ti.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
CC: <linux-usb@vger.kernel.org>, <balbi@ti.com>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 5/5] usb: musb: dsps: use proper child nodes
References: <1375215401-19729-1-git-send-email-bigeasy@linutronix.de> <1375215401-19729-6-git-send-email-bigeasy@linutronix.de> <51F9F10A.4000908@ti.com> <51FA3DD9.9080207@linutronix.de> <51FA46C3.9000101@linutronix.de> <51FB8A14.8040008@linutronix.de>
In-Reply-To: <51FB8A14.8040008@linutronix.de>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/2/2013 3:59 PM, Sebastian Andrzej Siewior wrote:
> On 08/01/2013 01:30 PM, Sebastian Andrzej Siewior wrote:
>> On 08/01/2013 12:52 PM, Sebastian Andrzej Siewior wrote:
>>> On 08/01/2013 07:24 AM, George Cherian wrote:
>>>>> b/arch/arm/boot/dts/am33xx.dtsi
>>>>> index 38b446b..0f756ca 100644
>>>>> --- a/arch/arm/boot/dts/am33xx.dtsi
>>>>> +++ b/arch/arm/boot/dts/am33xx.dtsi
>>>>> @@ -333,21 +337,85 @@
>>>>>                status = "disabled";
>>>>>            };
>>>>>    -        usb@47400000 {
>>>>> -            compatible = "ti,musb-am33xx";
>>>>> -            reg = <0x47400000 0x1000    /* usbss */
>>>>> -                   0x47401000 0x800        /* musb instance 0 */
>>>>> -                   0x47401800 0x800>;    /* musb instance 1 */
>>>>> -            interrupts = <17        /* usbss */
>>>>> -                      18        /* musb instance 0 */
>>>>> -                      19>;        /* musb instance 1 */
>>>>> -            multipoint = <1>;
>>>>> -            num-eps = <16>;
>>>>> -            ram-bits = <12>;
>>>>> -            port0-mode = <3>;
>>>>> -            port1-mode = <3>;
>>>>> -            power = <250>;
>>>>> +        usb: usb@47400000 {
>>>>> +            compatible = "ti,am33xx-usb";
>>>>> +            reg = <0x47400000 0x1000>;
>>>>> +            ranges;
>>>>> +            #address-cells = <1>;
>>>>> +            #size-cells = <1>;
>>>>>                ti,hwmods = "usb_otg_hs";
>>>>> +            status = "disabled";
>>>>> +
>>>>> +            ctrl_mod: control@44e10000 {
>>>>> +                compatible = "ti,am335x-ctrl-module";
>>>>> +                reg = <0x44e10000 0x650>;
>>>> Do you really need to map Control Module base to 0x650? If some other
>>>> driver does this mapping
>>> This is what I cam currently not sure about. Either we minimize the
>>> register window and introduce two (the other wakeup) or we keep using
>>> the same reset driver for other devices.
>> I mean drivers/reset or something like that.
> If there are no further comments / preferences on this I'm going to
> shrink to registers and make usb only.

Yes, USB only makes sense for now.
>
> Sebastian
>


-- 
-George

