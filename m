Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756004AbaCNJxL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 05:53:11 -0400
Received: from mail-ee0-f47.google.com ([74.125.83.47]:64392 "EHLO
	mail-ee0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755925AbaCNJxI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 05:53:08 -0400
Message-ID: <5322D1A0.9040601@gmail.com>
Date: Fri, 14 Mar 2014 10:53:36 +0100
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
To: =?UTF-8?B?QW50b2luZSBUw6luYXJ0?= 
	<antoine.tenart@free-electrons.com>
CC: alexandre.belloni@free-electrons.com, zmxu@marvell.com,
        jszhang@marvell.com, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/3] ARM: dts: berlin2q: add the Marvell Armada 1500
 pro
References: <1394719607-25018-1-git-send-email-antoine.tenart@free-electrons.com> <1394719607-25018-2-git-send-email-antoine.tenart@free-electrons.com> <5322CC8B.6010905@gmail.com> <5322D089.7010605@free-electrons.com>
In-Reply-To: <5322D089.7010605@free-electrons.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/14/2014 10:48 AM, Antoine Ténart wrote:
> On 14/03/2014 10:31, Sebastian Hesselbarth wrote:
>> On 03/13/2014 03:06 PM, Antoine Ténart wrote:
>>> +    clocks {
>>> +        #address-cells = <0>;
>>> +        #size-cells = <0>;
>>> +
>>> +        smclk: sysmgr-clock {
>>> +            compatible = "fixed-clock";
>>> +            #clock-cells = <0>;
>>> +            clock-frequency = <25000000>;
>>> +        };
>>> +
>>> +        sysclk: system-clock {
>>> +            compatible = "fixed-clock";
>>> +            #clock-cells = <0>;
>>> +            clock-frequency = <400000000>;
>>> +        };
>>> +    };
>>> +
>>> +    soc {
>> [...]
>>> +        local-timer@ad0600 {
>>> +            compatible = "arm,cortex-a9-twd-timer";
>>> +            reg = <0xad0600 0x20>;
>>> +            clocks = <&sysclk>;
>>
>> If I understand Jisheng correctly, this should be cpuclk/3. When
>> removing the clocks {} container above, please also take care of
>> it.
>>
>> You can do
>>
>> cpuclk: cpu-clock {
>>      compatible = "fixed-clock";
>>      #clock-cells = <0>;
>>      clock-frequency = <1200000000>; /* <- put correct freq here */
>> };
>>
>> sysclk: system-clock {
>>      compatible = "fixed-factor-clock";
>>      #clock-cells = <0>;
>>      clocks = <&cpuclk>;
>>      clock-multi = <1>;
>>      clock-div = <3>;
>> };
>>
>> Hopefully, we'll have proper clock drivers soon so we can just replace
>> referenced "fixed-*" clocks.
>
> Sure, this is why I only kept one fixed clock in this patch.
>
> I'll add the cpuclk here then.
>
>>> +            timer0: timer@2c00 {
>>> +                compatible = "snps,dw-apb-timer";
>>> +                reg = <0x2c00 0x14>;
>>> +                interrupts = <8>;
>>> +                clock-freq = <100000000>;
>>> +                status = "okay";
>>> +            };
>>> +
>>> +            timer1: timer@2c14 {
>>> +                compatible = "snps,dw-apb-timer";
>>> +                reg = <0x2c14 0x14>;
>>> +                clock-freq = <100000000>;
>>> +                status = "disabled";
>>> +            };
>>
>> Please also add the remaining 6 apb timers.
>
> I don't have any information about the remaining 6 apb timers. I'll ask
> Jisheng.

He replied to v1 of this patch with

"We still have 8 apb timers"

Sebastian
