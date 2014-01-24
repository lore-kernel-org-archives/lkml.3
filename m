Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752792AbaAXNq5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jan 2014 08:46:57 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:46721 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752481AbaAXNqz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jan 2014 08:46:55 -0500
X-AuditID: cbfec7f4-b7f796d000005a13-87-52e26ecef2a1
Message-id: <52E26EBE.8080905@samsung.com>
Date: Fri, 24 Jan 2014 14:46:38 +0100
From: Tomasz Figa <t.figa@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.1.1
MIME-version: 1.0
To: Mj Embd <mj.embd@gmail.com>
Cc: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        linaro-kernel <linaro-kernel@lists.linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-samsung-soc@vger.kernel.org
Subject: Re: Arndale Timer Interrupt Question
References: <CAPUj1OM=Zn2nd98aXRCRUJrLknkS0o44V1BfuJhz5i19w+M5Ow@mail.gmail.com>
 <1437466.9hkS4zH5MN@amdc1032> <52D02693.1040003@samsung.com>
 <CAPUj1OOvphUhLRO6jDRD4RRUFbYO_my=BZZ1gMJ6d_G9WUN4_w@mail.gmail.com>
In-reply-to: <CAPUj1OOvphUhLRO6jDRD4RRUFbYO_my=BZZ1gMJ6d_G9WUN4_w@mail.gmail.com>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrILMWRmVeSWpSXmKPExsVy+t/xy7rn8h4FGbzv4LPYOGM9q8X7Q8+Y
	LS7vmsNmMeP8PiaLAz2H2BxYPXbOusvucfvfY2aPvi2rGD0+b5ILYInisklJzcksSy3St0vg
	ylgz9wVrwWPOivPbDjE3ML5h72Lk5JAQMJH4vm0tI4QtJnHh3nq2LkYuDiGBpYwSZ6a+ZYZw
	PjNKvHs7B6yDV0BLYun6yWAdLAKqEo9232UGsdkE1CQ+NzxiA7FFBSIk/s5bzwhRLyjxY/I9
	FhBbREBe4tKXRkaQocwCFxgldq9tA2sWFtCVeP7lGtS2G4wS937/BNvGKRAs8fXqBbAiZgFr
	iZWTtjFC2PISm9e8ZZ7AKDALyZJZSMpmISlbwMi8ilE0tTS5oDgpPddQrzgxt7g0L10vOT93
	EyMkmL/sYFx8zOoQowAHoxIP74zAh0FCrIllxZW5hxglOJiVRHi3BjwKEuJNSaysSi3Kjy8q
	zUktPsTIxMEp1cCYcKX6YMaat//CZ6qeWbw5/Agn88eEKW8u19emvZ1Uvrzsl0DTymhD2zjX
	vC+X7I1KmBf9njRbLZdF/NHmJqcSwzvHK5xEr2eZzjZ92nmpJOTyDO6ZgWJ6pzawT7dgfs5g
	fMhfYtbyRztPTmX8+XP96gv5T45d9D5QmDYpaOZvS/4nobMf8NhtVWIpzkg01GIuKk4EAPmx
	0RlEAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 23.01.2014 07:10, Mj Embd wrote:
> On 1/10/14, Tomasz Figa <t.figa@samsung.com> wrote:
>> Hi,
>>
>> On 09.01.2014 13:52, Bartlomiej Zolnierkiewicz wrote:
>>>
>>> added linux-samsung-soc to cc:,
>>> it is a better suited list for this question
>>>
>>> On Thursday, January 09, 2014 10:30:56 AM Mj Embd wrote:
>>>> I am a bit confused on the interrupt number for CNTVIRQ..CNTHPIRQ. Can
>>>> you please help here.
>>>>
>>>> As per the exynos5 public manual
>>>> What is the difference between  CPU_nCNTHPIRQ[0] and CNTHPIRQ.
>>
>> I'm not sure if this is really what I think it is, but looking at the
>> manual, CPU_nCNTHPIRQ[0] and [1] SPI ports and CNTHPIRQ PPI port seem to
>> be the same signals, with the difference that the first two are shared
>> interrupts connected through the combiner, while the last one is a
>> per-processor interrupt, directly connected to GIC PPI port, allowing
>> each CPU to get its own CNTHPIRQ signal ([0] for CPU 0 and [1] for CPU 1).
>
> So while registering the IRQ which one has to be used Core0:26/33 Core1:26/54 ?

Well, it depends on your driver. If it supports per-CPU interrupts then 
you use CNTHPIRQ PPI port, othwerise nCNTHPIRQ[0] and [1] SPI ports.

Best regards,
Tomasz
