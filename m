Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754674Ab3HBK3q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 06:29:46 -0400
Received: from www.linutronix.de ([62.245.132.108]:48261 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753776Ab3HBK3n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 06:29:43 -0400
Message-ID: <51FB8A14.8040008@linutronix.de>
Date: Fri, 02 Aug 2013 12:29:40 +0200
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130630 Icedove/17.0.7
MIME-Version: 1.0
To: George Cherian <george.cherian@ti.com>
CC: linux-usb@vger.kernel.org, balbi@ti.com, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/5] usb: musb: dsps: use proper child nodes
References: <1375215401-19729-1-git-send-email-bigeasy@linutronix.de> <1375215401-19729-6-git-send-email-bigeasy@linutronix.de> <51F9F10A.4000908@ti.com> <51FA3DD9.9080207@linutronix.de> <51FA46C3.9000101@linutronix.de>
In-Reply-To: <51FA46C3.9000101@linutronix.de>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/01/2013 01:30 PM, Sebastian Andrzej Siewior wrote:
> On 08/01/2013 12:52 PM, Sebastian Andrzej Siewior wrote:
>> On 08/01/2013 07:24 AM, George Cherian wrote:
>>>> b/arch/arm/boot/dts/am33xx.dtsi
>>>> index 38b446b..0f756ca 100644
>>>> --- a/arch/arm/boot/dts/am33xx.dtsi
>>>> +++ b/arch/arm/boot/dts/am33xx.dtsi
>>>> @@ -333,21 +337,85 @@
>>>>               status = "disabled";
>>>>           };
>>>>   -        usb@47400000 {
>>>> -            compatible = "ti,musb-am33xx";
>>>> -            reg = <0x47400000 0x1000    /* usbss */
>>>> -                   0x47401000 0x800        /* musb instance 0 */
>>>> -                   0x47401800 0x800>;    /* musb instance 1 */
>>>> -            interrupts = <17        /* usbss */
>>>> -                      18        /* musb instance 0 */
>>>> -                      19>;        /* musb instance 1 */
>>>> -            multipoint = <1>;
>>>> -            num-eps = <16>;
>>>> -            ram-bits = <12>;
>>>> -            port0-mode = <3>;
>>>> -            port1-mode = <3>;
>>>> -            power = <250>;
>>>> +        usb: usb@47400000 {
>>>> +            compatible = "ti,am33xx-usb";
>>>> +            reg = <0x47400000 0x1000>;
>>>> +            ranges;
>>>> +            #address-cells = <1>;
>>>> +            #size-cells = <1>;
>>>>               ti,hwmods = "usb_otg_hs";
>>>> +            status = "disabled";
>>>> +
>>>> +            ctrl_mod: control@44e10000 {
>>>> +                compatible = "ti,am335x-ctrl-module";
>>>> +                reg = <0x44e10000 0x650>;
>>>
>>> Do you really need to map Control Module base to 0x650? If some other
>>> driver does this mapping
>>
>> This is what I cam currently not sure about. Either we minimize the
>> register window and introduce two (the other wakeup) or we keep using
>> the same reset driver for other devices.
> 
> I mean drivers/reset or something like that.

If there are no further comments / preferences on this I'm going to
shrink to registers and make usb only.

> 
Sebastian

