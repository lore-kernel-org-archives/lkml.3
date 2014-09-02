Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752616AbaIBAI1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 20:08:27 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:45050 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752344AbaIBAIZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 20:08:25 -0400
MIME-Version: 1.0
In-Reply-To: <3341001.1Jsp173xyM@wuerfel>
References: <1409350479-19108-1-git-send-email-abrestic@chromium.org>
	<6179185.bNbDBEC6tl@wuerfel>
	<CAL1qeaEEo6-LZz3Kex7oPUfz=Z56nvKoDnqu051rGhhi3ZFTDQ@mail.gmail.com>
	<3341001.1Jsp173xyM@wuerfel>
Date: Mon, 1 Sep 2014 17:08:24 -0700
X-Google-Sender-Auth: DZTy1xrnZZmObEJmvlurMLp9GHA
Message-ID: <CAL1qeaHryi7noBMiHxJPybByuvVts23reuiiQbV9mCQj+Ngqjw@mail.gmail.com>
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

On Mon, Sep 1, 2014 at 1:34 AM, Arnd Bergmann <arnd@arndb.de> wrote:
> On Sunday 31 August 2014 11:54:04 Andrew Bresticker wrote:
>> On Sat, Aug 30, 2014 at 12:57 AM, Arnd Bergmann <arnd@arndb.de> wrote:
>> > On Friday 29 August 2014 15:14:31 Andrew Bresticker wrote:
>> >> Define a generic MIPS_GIC_IRQ_BASE which is suitable for Malta and
>> >> the upcoming Danube board in <mach-generic/irq.h>.  Since Sead-3 is
>> >> different and uses a MIPS_GIC_IRQ_BASE equal to the CPU IRQ base (0),
>> >> define its MIPS_GIC_IRQ_BASE in <mach-sead3/irq.h>.
>> >>
>> >> Signed-off-by: Andrew Bresticker <abrestic@chromium.org>
>> >>
>> >
>> > Why do you actually have to hardwire an IRQ base? Can't you move
>> > to the linear irqdomain code for DT based MIPS systems yet?
>>
>> Neither Malta nor SEAD-3 use device-tree for interrupts yet, so they
>> still require a hard-coded IRQ base.  For boards using device-tree, I
>> stuck with a legacy IRQ domain as it allows most of the existing GIC
>> irqchip code to be reused.
>
> I see. Note that we now have irq_domain_add_simple(), which should
> do the right think in either case: use a legacy domain when a
> nonzero base is provided for the old boards, but use the simple
> domain when probed from DT without an irq base.
>
> This makes the latter case more memory efficient (it avoids
> allocating the irq descriptors for every possibly but unused
> IRQ number) and helps ensure that you don't accidentally rely
> on hardcoded IRQ numbers for the DT based machines, which would
> be considered a bug.

Ah, ok.  It looks like add_simple() is what I want then.
