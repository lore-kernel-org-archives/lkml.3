Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753830Ab3GTDgv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 23:36:51 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:58893 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753785Ab3GTDgs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 23:36:48 -0400
Message-ID: <51EA05C0.6050606@ti.com>
Date: Sat, 20 Jul 2013 09:06:32 +0530
From: George Cherian <george.cherian@ti.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
CC: Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        <linux-usb@vger.kernel.org>, <balbi@ti.com>,
        <linux-kernel@vger.kernel.org>, <gregkh@linuxfoundation.org>,
        <linux-omap@vger.kernel.org>, <kishon@ti.com>
Subject: Re: [PATCH v2 3/4] arm: dts: Add USB phy nodes for AM33XX
References: <1374237277-17769-1-git-send-email-george.cherian@ti.com> <1374237277-17769-4-git-send-email-george.cherian@ti.com> <51E94571.8080805@cogentembedded.com> <51E94B30.9070805@linutronix.de> <51E98663.2040308@cogentembedded.com>
In-Reply-To: <51E98663.2040308@cogentembedded.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/20/2013 12:03 AM, Sergei Shtylyov wrote:
> Hello.
>
> On 07/19/2013 06:20 PM, Sebastian Andrzej Siewior wrote:
>
>>>> diff --git a/arch/arm/boot/dts/am33xx.dtsi
>>>> b/arch/arm/boot/dts/am33xx.dtsi
>>>> index 8e1248f..e3890c4 100644
>>>> --- a/arch/arm/boot/dts/am33xx.dtsi
>>>> +++ b/arch/arm/boot/dts/am33xx.dtsi
>>>> @@ -326,21 +326,59 @@
>>>>                status = "disabled";
>>>>            };
>>>>
>>>> -        usb@47400000 {
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
>>>> -            ti,hwmods = "usb_otg_hs";
>>>> +        phy1: am335x-usb0@44e10620 {
>
>>>     Shouldn't the PHYs be *under* the usb0/1 device nodes in the 
>>> hierarchy?
>>> They're not on the same bus as the MUSB controllers for sure.
>
>> I redo the complete thing. I have now:
>
>> usb: usb@47400000 {
>>     compatible = "ti,am33xx-usb";
>>
>>     usb0_phy: phy@47401300 {
>>         compatible = "ti,am335x-usb-phy";
>>     }
>>     usb0: usb@47401000 {
>>         musb0: usb@47401400 {
>>             compatible = "mg,musbmhdrc";
>>         }
>>     }
>>     usb1_phy: phy@47402300 {
>>         compatible = "ti,am335x-usb-phy";
>>     }
>>     usb1: usb@47402000 {
>>         musb1: usb@47402400 {
>>             compatible = "mg,musbmhdrc";
>>         }
>>     }
>> }
>
>> And you want usb0_phy to be child of usb0? In the TRM they are all in
>> the same block.
>
>    Ah, the fact that PHYs didn't have the "reg" property got me 
> muddled, I didn't pay attention to the address part of the node 
> names... BTW, where is the "reg" prop? I see PHYs share the address 
> space with "omap-control-usb@44e10620" device -- what's the point with 
> this?
In control module(CM) each USB has got 2 registers  in which one is a 
shared register( wakeup register)
So all the CM access are done using the control-usb driver 
(phy-omap-control-usb.c). Same reason why phy's dont have a reg property.
>
>> Sebastian
>
> WBR, Sergei
>


-- 
-George

