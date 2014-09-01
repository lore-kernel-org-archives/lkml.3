Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753061AbaIAIeq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 04:34:46 -0400
Received: from mout.kundenserver.de ([212.227.17.24]:63705 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752536AbaIAIeo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 04:34:44 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Andrew Bresticker <abrestic@chromium.org>
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
Subject: Re: [PATCH 04/12] MIPS: GIC: Move MIPS_GIC_IRQ_BASE into platform irq.h
Date: Mon, 01 Sep 2014 10:34:30 +0200
Message-ID: <3341001.1Jsp173xyM@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <CAL1qeaEEo6-LZz3Kex7oPUfz=Z56nvKoDnqu051rGhhi3ZFTDQ@mail.gmail.com>
References: <1409350479-19108-1-git-send-email-abrestic@chromium.org> <6179185.bNbDBEC6tl@wuerfel> <CAL1qeaEEo6-LZz3Kex7oPUfz=Z56nvKoDnqu051rGhhi3ZFTDQ@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:6aLnM3PQFOof7lpxQ+L4q+TOKehFVYSYuMvu2B50cdN
 QKeeQKiM8h/SiCmzSpZHJl6F5cygaNeSQW45IqeD0+FdFBuOLs
 /FuhxiebSjY8wUrz1uTqMXnqxspiGjZWohRnODTo21ZGPF09aq
 BNCToMv5ff+nmSUV+EYFctCXHyEibwaAauJn2ZZ3s6J9qck4tp
 TgL/gAxG06j/AvcvEyNn4joaxAKSu7IsyaQ4dkHFa50X0mKPHS
 GcK5Dm4D9zXcL8K4PYjGIBdGvwjKWWEzy4+0r/LHFBFiWIMALv
 azCRWhcz+kKPZLgCL1dudAQP9mVUKOf8Zsn2zJVkSA8kYcdk8l
 sZ0W9nXahPzp2f2jsEP0=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 31 August 2014 11:54:04 Andrew Bresticker wrote:
> On Sat, Aug 30, 2014 at 12:57 AM, Arnd Bergmann <arnd@arndb.de> wrote:
> > On Friday 29 August 2014 15:14:31 Andrew Bresticker wrote:
> >> Define a generic MIPS_GIC_IRQ_BASE which is suitable for Malta and
> >> the upcoming Danube board in <mach-generic/irq.h>.  Since Sead-3 is
> >> different and uses a MIPS_GIC_IRQ_BASE equal to the CPU IRQ base (0),
> >> define its MIPS_GIC_IRQ_BASE in <mach-sead3/irq.h>.
> >>
> >> Signed-off-by: Andrew Bresticker <abrestic@chromium.org>
> >>
> >
> > Why do you actually have to hardwire an IRQ base? Can't you move
> > to the linear irqdomain code for DT based MIPS systems yet?
> 
> Neither Malta nor SEAD-3 use device-tree for interrupts yet, so they
> still require a hard-coded IRQ base.  For boards using device-tree, I
> stuck with a legacy IRQ domain as it allows most of the existing GIC
> irqchip code to be reused.

I see. Note that we now have irq_domain_add_simple(), which should
do the right think in either case: use a legacy domain when a 
nonzero base is provided for the old boards, but use the simple
domain when probed from DT without an irq base.

This makes the latter case more memory efficient (it avoids
allocating the irq descriptors for every possibly but unused
IRQ number) and helps ensure that you don't accidentally rely
on hardcoded IRQ numbers for the DT based machines, which would
be considered a bug.

	Arnd
