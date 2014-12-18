Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751827AbaLRB0a (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Dec 2014 20:26:30 -0500
Received: from mail-wg0-f45.google.com ([74.125.82.45]:43019 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751489AbaLRB03 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2014 20:26:29 -0500
MIME-Version: 1.0
In-Reply-To: <52558289.TJpHJaW3sy@avalon>
References: <20141215050920.533.20169.sendpatchset@w520>
	<52558289.TJpHJaW3sy@avalon>
Date: Thu, 18 Dec 2014 10:26:27 +0900
Message-ID: <CANqRtoS34Jf+ztJYpt1faCkNQk-V0vihgxjWj2Sn61YWKZepJQ@mail.gmail.com>
Subject: Re: [PATCH] irqchip: renesas-intc-irqpin: r8a7779 IRLM setup support
From: Magnus Damm <magnus.damm@gmail.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        SH-Linux <linux-sh@vger.kernel.org>,
        "Simon Horman [Horms]" <horms@verge.net.au>,
        Thomas Gleixner <tglx@linutronix.de>,
        Jason Cooper <jason@lakedaemon.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Laurent,

On Thu, Dec 18, 2014 at 6:41 AM, Laurent Pinchart
<laurent.pinchart@ideasonboard.com> wrote:
> Hi Magnus,
>
> Thank you for the patch.
>
> On Monday 15 December 2014 14:09:20 Magnus Damm wrote:
>> From: Magnus Damm <damm+renesas@opensource.se>
>>
>> Add r8a7779 specific support for IRLM bit configuration
>> in the INTC-IRQPIN driver. Without this code we need
>> special workaround code in arch/arm/mach-shmobile.
>>
>> The IRLM bit for the INTC hardware exists on various
>> older SH-based SoCs and is used to select between two
>> modes for the external interrupt pins IRQ0 to IRQ3:
>>
>> IRLM = 0: (default from reset on r8a7779)
>> In this mode the pins IRQ0 to IRQ3 are used together
>> to give a value between 0 and 15 to the SoC. External
>> logic is required for masking. This mode is not
>> supported by the INTC-IRQPIN driver.
>>
>> IRLM = 1: (needs this patch or configuration elsewhere)
>> In this mode IRQ0 to IRQ3 operate as 4 individual
>> external interrupt pins. In this mode the SMSC ethernet
>> chip can be used via IRQ1 on r8a7779 Marzen. This mode
>> is the only supported mode by the INTC-IRQPIN driver.
>>
>> For this patch to work the r8a7779 DTS needs to pass
>> the ICR0 register as the last register bank.
>>
>> Signed-off-by: Magnus Damm <damm+renesas@opensource.se>
>> ---
>>
>>  Same version as sent on December 3rd.
>>
>>  Written against renesas-devel-20141202-v3.18-rc7 which is
>>  basically v3.18-rc7 plus latest arch/arm/mach-shmobile code.
>>
>>  Documentation/devicetree/bindings/interrupt-controller/renesas,intc-irqpin.
>> txt |    5 +
>>  drivers/irqchip/irq-renesas-intc-irqpi                |   50 ++++++++--
>>  2 files changed, 46 insertions(+), 9 deletions(-)
>>
>> ---
>> 0001/Documentation/devicetree/bindings/interrupt-controller/renesas,intc-ir
>> qpin.txt +++
>> work/Documentation/devicetree/bindings/interrupt-controller/renesas,intc-ir
>> qpin.txt      2014-12-03 20:25:13.000000000 +0900 @@ -9,6 +9,11 @@ Required
>> properties:
>>      - "renesas,intc-irqpin-r8a7778" (R-Car M1A)
>>      - "renesas,intc-irqpin-r8a7779" (R-Car H1)
>>      - "renesas,intc-irqpin-sh73a0" (SH-Mobile AG5)
>> +
>> +- reg: Base address and length of each register bank used by the external
>> +  IRQ pins driven by the interrupt controller hardware module. The base
>> +  addresses, length and number of required register banks varies with
>> soctype.
>
> Ouch. Ouch. Multiple times. Very much :-/
>
> I suppose it's too late to fix the DT bindings ?

I don't think it is ever too late, but the question is just how urgent
it is to get rid of the Marzen C board code. With the code in this
patch queue up we can get rid of the board code. If someone decides to
rework the INTC IRQPIN bits then we will have to live with the Marzen
code for longer. And if we should do it right and describe the actual
hardware, then perhaps we should consider the non-IRQ-pin interrupts
included in INTC for some SoCs. So it rapidly gets more complex...

Cheers,

/ magnus
