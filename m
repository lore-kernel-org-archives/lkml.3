Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751428AbaKFSOv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 13:14:51 -0500
Received: from mail-vc0-f177.google.com ([209.85.220.177]:33764 "EHLO
	mail-vc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750970AbaKFSOu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 13:14:50 -0500
MIME-Version: 1.0
In-Reply-To: <ad6085048a3c0a42c03d623a6770e300@www.loen.fr>
References: <1415296639-40203-1-git-send-email-anatol.pomozov@gmail.com>
	<ad6085048a3c0a42c03d623a6770e300@www.loen.fr>
Date: Thu, 6 Nov 2014 10:14:49 -0800
Message-ID: <CAOMFOmWbuaZ4kjPTojfF_h0gF-eh2iEzE44OKEfSQYRwAUrg2A@mail.gmail.com>
Subject: Re: [PATCH] clocksource: arch_timer: Mark ARMv8 system timer as 'always-on'
From: Anatol Pomozov <anatol.pomozov@gmail.com>
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: daniel.lezcano@linaro.org, lorenzo.pieralisi@arm.com, tglx@linutronix.de,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

On Thu, Nov 6, 2014 at 10:09 AM, Marc Zyngier <marc.zyngier@arm.com> wrote:
> Hi Anatol,
>
> On 2014-11-06 17:57, Anatol Pomozov wrote:
>>
>> Quoting ARMv8 Reference Manual section D6.1:
>> "The system counter must be implemented in an always-on power domain."
>
>
> Yes. And the key words here are "system counter". That's the global counter,
> not the per-cpu view of that, and critically nor comparators.
>
> The timers (per-cpu counter+comparator) will happily go down with the CPU,
> and won't be able to wake it up. Exactly like ARMv7, by the way.
>
>> There is no need to keep 'always-on' configurable on ARMv8. We ignore
>> this dts property value and unconditionally set it to true.
>>
>> The issue was discovered while working on ARMv8 board with only one timer
>> (arm arch timer). If 'always-on' is false then it disables high-resolution
>> timer functionality.
>
>
> Yup, and that's by design (see above). The *only* case where it is really
> "always-on" is when a virtual machine is running (if the vcpu is running
> then the physical CPU is, and so is the timer).
>
> If your system really never does any form of PM, then fine, just put the DT
> property in. Removing it is, I'm sorry to say, a bit short sighted.

Thanks for the clarification Marc. I will look if it possible to get
the other (always-on) timer back.

Ignore my patch.
