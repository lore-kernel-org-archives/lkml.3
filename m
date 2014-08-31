Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752039AbaHaSmS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Aug 2014 14:42:18 -0400
Received: from mail-vc0-f171.google.com ([209.85.220.171]:38441 "EHLO
	mail-vc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751617AbaHaSmP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Aug 2014 14:42:15 -0400
MIME-Version: 1.0
In-Reply-To: <15153439.zUXECAnL7k@wuerfel>
References: <1409350479-19108-1-git-send-email-abrestic@chromium.org>
	<1409350479-19108-6-git-send-email-abrestic@chromium.org>
	<15153439.zUXECAnL7k@wuerfel>
Date: Sun, 31 Aug 2014 11:42:14 -0700
X-Google-Sender-Auth: 1uhxDrVvTNDKicdPwdNXftoJHic
Message-ID: <CAL1qeaFFrQJLMyNQtcwWtrYSJ4=_Yf0zuYWPtCPsUu-6OrvKdw@mail.gmail.com>
Subject: Re: [PATCH 05/12] MIPS: GIC: Add device-tree support
From: Andrew Bresticker <abrestic@chromium.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Ralf Baechle <ralf@linux-mips.org>, Rob Herring <robh+dt@kernel.org>,
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
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 30, 2014 at 12:54 AM, Arnd Bergmann <arnd@arndb.de> wrote:
> On Friday 29 August 2014 15:14:32 Andrew Bresticker wrote:
>> Add device-tree support for the MIPS GIC.  With DT, no per-platform
>> static device interrupt mapping is supplied and instead all device
>> interrupts are specified through the DT.  The GIC-to-CPU interrupts
>> must also be specified in the DT.
>>
>> Platforms using DT-based probing of the GIC need only supply the
>> GIC_NUM_INTRS and, if necessary, MIPS_GIC_IRQ_BASE values and
>> call of_irq_init() with an of_device_id table including the GIC.
>>
>> Currenlty only legacy and vecotred interrupt modes are supported.
>>
>> Signed-off-by: Andrew Bresticker <abrestic@chromium.org>
>> ---
>>  arch/mips/include/asm/gic.h |  15 ++++++
>>  arch/mips/kernel/irq-gic.c  | 122 +++++++++++++++++++++++++++++++++++++++++++-
>>
>
>
> Can you move this to drivers/irqchip and use the IRQCHIP_DECLARE()
> macro to define the entry point?

Sure.  I was planning on doing this later, but I don't see why it
couldn't be done now though.
