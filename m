Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757161Ab3LWJZn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Dec 2013 04:25:43 -0500
Received: from mail-pd0-f176.google.com ([209.85.192.176]:50790 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753124Ab3LWJZl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Dec 2013 04:25:41 -0500
MIME-Version: 1.0
In-Reply-To: <2741731.123321387789370147.JavaMail.weblogic@epml01>
References: <2741731.123321387789370147.JavaMail.weblogic@epml01>
From: Barry Song <21cnbao@gmail.com>
Date: Mon, 23 Dec 2013 17:25:21 +0800
Message-ID: <CAGsJ_4yfu+5bHM9bmuS69ALzxvBg2M=1W9edTcByr-AY-tEpMQ@mail.gmail.com>
Subject: Re: Re: [PATCH 1/1] extcon: gpio: Add power resume support
To: MyungJoo Ham <myungjoo.ham@samsung.com>
Cc: =?UTF-8?B?7LWc7LCs7Jqw?= <cw00.choi@samsung.com>,
        rjying <rjying@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
        RongJun Ying <Rongjun.Ying@csr.com>,
        Binghua Duan <Binghua.Duan@csr.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/12/23 MyungJoo Ham <myungjoo.ham@samsung.com>:
>> On 12/23/2013 05:13 PM, Barry Song wrote:
>> > 2013/12/23 Chanwoo Choi <cw00.choi@samsung.com>:
>> >> On 12/23/2013 04:36 PM, Barry Song wrote:
>> >>> 2013/12/23 Chanwoo Choi <cw00.choi@samsung.com>:
>> >>>> On 12/23/2013 03:10 PM, Barry Song wrote:
>> >>>>> 2013/12/23 Chanwoo Choi <cw00.choi@samsung.com>:
>> >>>>>> On 12/20/2013 05:09 PM, rjying wrote:
>> >>>>>>> From: Rongjun Ying <rongjun.ying@csr.com>
>> >>>>>>>
>> >>>>>>> After system resume, need send extcon uevent to userspace
>> >>>>>>
>> >>>>>> Why did extcon send uevent after wakeup from suspend?
>> >>>>>>
>> >>>>>> If extcon cable is attatched or detached on suspend state,
>> >>>>>> Kernel can detect the interrupt about changed state of extcon.
>> >>>>>
>> >>>>> irq controller has lost power in suspend, so there is no pending interrupt.
>> >>>>> and HW will not pend any interrupt when we hotplug cable during sleep.
>> >>>>
>> >>>> No, SoC in suspend state must maintain the minimum power under 1mA
>> >>>> if completed the power-optimization on suspend state.
>> >>>>
>> >>>> If user insert USB cable to target, the external interrupt connected to
>> >>>> USB port is happened. And kernel would be waked up from suspend state
>> >>>> to operate proper interrupt handler of external interrupt.
>> >>>
>> >>> no. not every USB supports that. that depends on the power domain design of SoC.
>> >>
>> >> USB is only example for gpio control in suspend state.
>> >>
>> >>>
>> >>>>
>> >>>> Also,
>> >>>> Input subsystem used gpio-keys driver for power button..
>> >>>> If user press power button in suspend state, target would be waked up from suspend state.
>> >>>> It is same case both extcon gpio and gpio-keys of input subsystem.
>> >>>
>> >>> no. it depends on the SoC design. many SoC only support 1 special key
>> >>> which can work as ON-KEY as wakeup source. and this kind of keys might
>> >>> not be GPIO at all.
>> >>> there is a special power domain which is still open for it.
>> >>
>> >> many SoC?
>> >>
>> >> As I knew, most SoC has supported various wakeup source.
>> >> As you comment, if specific SoC support only one special key
>> >> for wakeup from suspend state, I think it isn't common.
>> >>
>> >> Also,
>> >> This patch isn't necessary on SoCs which support various wakeup source (e.g., external interrupt).
>> >> As you comment, this issue has dependecy on specific SoC. Why did you think this common code?
>> >
>> > i am not thinking this patch must be common codes but i think the
>> > extcon should provide common codes to support all chips. that is what
>> > a framework should consider.
>> >
>> > if there is no this or things similar with this, how could extcon
>> > support the chips which don't support receiving sleep gpio interrupts?
>>
>> Sure, subsystem should support all cases related to this issue.
>>
>> I'd like to send common patch to support all cases as we discussed.
>> If some patch support all case, I would review and apply it.
>>
>> Chanwoo Choi
>
> Dear Barry and Chanwoo,
>
>
> What about having a flag in extcon platform data that describes
> whether this extcon-gpio requires status double checking at resume
> or not?

MyungJoo,

Thanks!
i am ok. what about naming it as "bool lost_sleep_irq"? default, it is
0, for chips that will lose sleeping IRQ, set it to 1?

Chanwoo, how do you think?

>
>
> Cheers,
> MyungJoo
>

-barry
