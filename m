Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752305AbaBSCji (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 21:39:38 -0500
Received: from terminus.zytor.com ([198.137.202.10]:49731 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751694AbaBSCjh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 21:39:37 -0500
User-Agent: K-9 Mail for Android
In-Reply-To: <CAC5e1FpChdyW9xzbwsyVx147hKrV0MxwkCMyKHR4ab5-Q=DyPg@mail.gmail.com>
References: <CAC5e1FoLrHWSa_7BnRt-u451ZJOVqKhSpbyp8O_ExDbgcXtU+g@mail.gmail.com> <alpine.DEB.2.02.1402182101450.4468@ionos.tec.linutronix.de> <CAC5e1FpChdyW9xzbwsyVx147hKrV0MxwkCMyKHR4ab5-Q=DyPg@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain;
 charset=UTF-8
Subject: Re: Does it need to implement irq_set_type method in the ioapic_chip?
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Tue, 18 Feb 2014 18:34:38 -0800
To: carl peng <carlpeng008@gmail.com>, Thomas Gleixner <tglx@linutronix.de>
CC: mingo@redhat.com, x86@kernel.org, pingfank@linux.vnet.ibm.com,
        yoshihiro.yunomae.ez@hitachi.com, linux-kernel@vger.kernel.org
Message-ID: <fe0610e4-0073-42a7-803a-590de82e47ef@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an ACPI device connecting to an internal IOAPIC? If not, how is it connected?

On February 18, 2014 6:32:44 PM PST, carl peng <carlpeng008@gmail.com> wrote:
>Hi Thomas,
>
>Thanks a lot for your help!
>
>But I still have some confusion. Could you please help to give some
>suggestions to me?
>
>1) This device is a ACPI device, the hardware engineer designed it as
>falling edge interrupt trigger
>mode, does it need to re-work the hardware and modify it as rising
>edge trigger mode to suit the
>Linux APIC driver architecture?
>2) Why does APIC driver not implement the irq_set_type method?  if
>implement it, will supply more
>free space for the device driver developer(they can set the interrupt
>trigger mode by calling request_irq).
>
>Thank you!
>Carl
>
>
>On Wed, Feb 19, 2014 at 4:13 AM, Thomas Gleixner <tglx@linutronix.de>
>wrote:
>> On Tue, 18 Feb 2014, carl peng wrote:
>>
>> Carl, sending the same mail twice within an hour does not speed up
>> things. It's quite likely that it gets ignored.
>>
>>> 1. Does it need to implement irq_set_type method in the ioapic_chip
>>> structure?
>>
>> No. The irq type is configured by the type of the interrupt or the
>> BIOS.
>>
>> ISA  interrupts are always polarity zero edge triggered (historic)
>>
>> PCI  interrupts are always polarity one level triggered
>>
>> PCIE interrupts are either legacy PCI or with MSI[X] always edge
>>      triggered
>>
>>> 2. if no need to implement it, how can device driver set the trigger
>mode
>>> of APIC interrupt controller pin?
>>
>> Not at all.
>>
>> The device which is connected to one of the busses must follow the
>> specification of the bus. There is no choice. Any additional
>> requirements of the device to deal with external signals must be
>> handled by the device itself and converted to the appropriate bus
>> requirement.
>>
>> This all is configured by the kernel automatically through bus
>> detection and BIOS tables.
>>
>> Thanks,
>>
>>         tglx

-- 
Sent from my mobile phone.  Please pardon brevity and lack of formatting.
