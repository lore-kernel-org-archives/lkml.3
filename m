Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752024AbaHaSyJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Aug 2014 14:54:09 -0400
Received: from mail-vc0-f177.google.com ([209.85.220.177]:43818 "EHLO
	mail-vc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751617AbaHaSyG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Aug 2014 14:54:06 -0400
MIME-Version: 1.0
In-Reply-To: <6179185.bNbDBEC6tl@wuerfel>
References: <1409350479-19108-1-git-send-email-abrestic@chromium.org>
	<1409350479-19108-5-git-send-email-abrestic@chromium.org>
	<6179185.bNbDBEC6tl@wuerfel>
Date: Sun, 31 Aug 2014 11:54:04 -0700
X-Google-Sender-Auth: VHWRbFTWf--u6jwK2nwvGsRy3uk
Message-ID: <CAL1qeaEEo6-LZz3Kex7oPUfz=Z56nvKoDnqu051rGhhi3ZFTDQ@mail.gmail.com>
Subject: Re: [PATCH 04/12] MIPS: GIC: Move MIPS_GIC_IRQ_BASE into platform irq.h
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

On Sat, Aug 30, 2014 at 12:57 AM, Arnd Bergmann <arnd@arndb.de> wrote:
> On Friday 29 August 2014 15:14:31 Andrew Bresticker wrote:
>> Define a generic MIPS_GIC_IRQ_BASE which is suitable for Malta and
>> the upcoming Danube board in <mach-generic/irq.h>.  Since Sead-3 is
>> different and uses a MIPS_GIC_IRQ_BASE equal to the CPU IRQ base (0),
>> define its MIPS_GIC_IRQ_BASE in <mach-sead3/irq.h>.
>>
>> Signed-off-by: Andrew Bresticker <abrestic@chromium.org>
>>
>
> Why do you actually have to hardwire an IRQ base? Can't you move
> to the linear irqdomain code for DT based MIPS systems yet?

Neither Malta nor SEAD-3 use device-tree for interrupts yet, so they
still require a hard-coded IRQ base.  For boards using device-tree, I
stuck with a legacy IRQ domain as it allows most of the existing GIC
irqchip code to be reused.
