Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932433AbaIDAGh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 20:06:37 -0400
Received: from mail-ig0-f181.google.com ([209.85.213.181]:37389 "EHLO
	mail-ig0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750788AbaIDAGe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 20:06:34 -0400
Message-ID: <5407AD06.6070402@gmail.com>
Date: Wed, 03 Sep 2014 17:06:30 -0700
From: David Daney <ddaney.cavm@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Andrew Bresticker <abrestic@chromium.org>
CC: Ralf Baechle <ralf@linux-mips.org>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Jeffrey Deans <jeffrey.deans@imgtec.com>,
        Markos Chandras <markos.chandras@imgtec.com>,
        Paul Burton <paul.burton@imgtec.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Jason Cooper <jason@lakedaemon.net>,
        Linux-MIPS <linux-mips@linux-mips.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 03/12] of: Add binding document for MIPS GIC
References: <1409350479-19108-1-git-send-email-abrestic@chromium.org> <1409350479-19108-4-git-send-email-abrestic@chromium.org> <5405FE07.4030400@gmail.com> <CAL1qeaHcV_4Z9n_THEN_aST3smgaW1vwn81SkmbU0AUJ_rdB1Q@mail.gmail.com> <540665BA.3080702@gmail.com> <CAL1qeaG_vSiBToi9ZU2=+Guj98gWE_AgmrR7=Z6-PxSNfdH9sA@mail.gmail.com>
In-Reply-To: <CAL1qeaG_vSiBToi9ZU2=+Guj98gWE_AgmrR7=Z6-PxSNfdH9sA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/03/2014 04:53 PM, Andrew Bresticker wrote:
> On Tue, Sep 2, 2014 at 5:50 PM, David Daney <ddaney.cavm@gmail.com> wrote:
[...]
>>
>> Your comments don't really make sense to me in the context of my knowledge
>> of the GIC.
>>
>> Of course all the CP0 timer and performance counter interrupts are per-CPU
>> and routed directly to the corresponding CP0_Cause[IP7..IP2] bits.  We are
>> don't need to give them further consideration.
>>
>>
>> Here is the scenario you should consider:
>>
>>    o 16 CPU cores.
>>    o 1 GIC routing interrupts from external sources to the 16 CPUs.
>>    o 2 network controllers each with an interrupt line routed to the GIC.
>>
>> Q: What would the GIC "interrupts" property look like?
>>
>> Note that the GIC doesn't have a single "interrupt-parent", as it can route
>> interrupts to *all* 16 CPUs.
>>
>> I propose that the GIC have neither an "interrupt-parent", nor "interrupts".
>> The fact that it is an "mti,global-interrupt-controller", means that the
>> software drivers for the GIC already know how to route interrupts, and any
>> information the device tree could contain is redundant.
>
> Ok, I misunderstood your opposition to the binding.
>
> My intention for the "interrupt-parent" and "interrupts" property of
> the GIC was to express that GIC interrupts are routed to the CPU
> interrupt vectors and that a certain set of these vectors are
> available for use by the GIC.  I would agree that these are mostly
> redundant (obviously the GIC routes interrupts to CPU interrupt
> vecotrs) and that it is not the most accurate description of the
> GIC-CPU relationship (the CPU interrupt controller are per-CPU, not
> global, and the GIC can route interrupts to any of them), though I'm
> not sure that there's a better way of describing it in DT.
>
> So that leaves us with something like this:
>
> interrupt-controller@1bdc0000 {
>          compatible = "mti,global-interrupt-controller";
>
>          interrupt-controller;
>          #interrupt-cells = <2>;
>
>          available-cpu-vectors = <2>, <3>, ...


Exactly what I had in mind, except for the missing "reg" property.

This gives software the information it needs, but doesn't impose any policy.

I will defer to others on the exact name the "available-cpu-vectors" 
should have.




> };
>
> DT folks, thoughts?
>
>

