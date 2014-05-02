Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751824AbaEBOH5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2014 10:07:57 -0400
Received: from mail-ob0-f176.google.com ([209.85.214.176]:55596 "EHLO
	mail-ob0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751501AbaEBOH4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2014 10:07:56 -0400
MIME-Version: 1.0
In-Reply-To: <14abe1165b144fe3d1139ad3b631eddd@www.loen.fr>
References: <CAPUj1OMJ8cE1cNTe8CjgBP2GTCXzi__Yg0+OoomME6=TShgqJg@mail.gmail.com>
	<CAPUj1OML_Rag3gxxBzswS6yaqFciuq2hKrV9BthL2OwU+wNj3A@mail.gmail.com>
	<14abe1165b144fe3d1139ad3b631eddd@www.loen.fr>
Date: Fri, 2 May 2014 19:37:55 +0530
Message-ID: <CAPUj1OMks1tY9KyFsBQizVnq1H+nyjgB6OUHagtKyoknYaMiow@mail.gmail.com>
Subject: Re: Linux Interrupt Context maps to ARM CPSR.mode = IRQ
From: Mj Embd <mj.embd@gmail.com>
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: kernelnewbies <kernelnewbies@kernelnewbies.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 2, 2014 at 7:17 PM, Marc Zyngier <marc.zyngier@arm.com> wrote:
> On 2014-05-02 13:34, Mj Embd wrote:
>>
>> Adding Marc to comment
>> Marc Please clarify the doubt
>>
>>
>>
>> On Fri, May 2, 2014 at 5:15 PM, Mj Embd <mj.embd@gmail.com> wrote:
>>>
>>> Hi,
>>>
>>> As per a lot of linux documentation some components work in process
>>> context and some work in interrupt context.
>>>
>>> If we try to map these contexts to ARM processor modes then is it
>>> safely to assume that
>>> Process Context : CPSR.mode = SVC
>>> Interrupt Context : CPSR.mode = IRQ
>>>
>>> If not how to define interrupt context properly. Confusing at times.
>
>
> Well, none of this is completely true.
>
> Process context exists both in USR (process in user mode) and SVC (process
> in kernel mode, executing a syscall for example).
>
> As for interrupts, the processor indeed starts executing the interrupt in
> IRQ mode, but this is a useless complication as far as Linux is concerned,

I didn't understood the term useless here, I hope it is not about the
question itself.

> and we quickly switch to SVC (see the definition of the vector_stub macro in
> arch/arm/kernel/entry-armv.S).
>
So what is the mode of the processor when Linux is executing in the
Academic / Bookish Term "Interrupt Context"
There is a function called in_interrupt which tells if linux is in
interrupt context.
But How to define/quantify Interrupt Context as a whole

Also, Some texts say there are two contexts Hard IRQ Context , Soft IRQ Context.
HardIRQ = interrupts Disabled , (possibly CPSR.I=1, mode=IRQ)
SoftIRQ = interrupts Enabled , (possibly CPSR.I=0, mode=IRQ)

SoftIRQs when executed from Ksoftirqd daemon  (possibly CPSR.I=0, mode=SVC)

We have a client query on this.

> Hope this helps.
>
>         M.
> --
> Fast, cheap, reliable. Pick two.



-- 
-mj
