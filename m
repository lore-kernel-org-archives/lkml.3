Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752848AbaKQUl3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 15:41:29 -0500
Received: from mout.kundenserver.de ([212.227.126.131]:52259 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751620AbaKQUl2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 15:41:28 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Kevin Cernekee <cernekee@gmail.com>
Cc: Ralf Baechle <ralf@linux-mips.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jon Fraser <jfraser@broadcom.com>, Dmitry Torokhov <dtor@chromium.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Jason Cooper <jason@lakedaemon.net>,
        Linux MIPS Mailing List <linux-mips@linux-mips.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jonas Gorski <jonas.gorski@gmail.com>
Subject: Re: [PATCH V2 22/22] MIPS: Add multiplatform BMIPS target
Date: Mon, 17 Nov 2014 21:40:50 +0100
Message-ID: <3357597.nYlNZ6O0nJ@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <CAJiQ=7BH8K=Q+JcWTKSfn6xAteOF4B6jahMu_qVd-FyZWD3pjA@mail.gmail.com>
References: <1416097066-20452-1-git-send-email-cernekee@gmail.com> <2911624.UJRs5QOPN5@wuerfel> <CAJiQ=7BH8K=Q+JcWTKSfn6xAteOF4B6jahMu_qVd-FyZWD3pjA@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:SmsAtINU2qaB3wgfto3BZGVZ0mWGoaHI3kXMX3aO7xT
 cFTdHLZcxcgTOC7uMimIWkY5CQPOjPWYs7wLDJWmc/07jX+OzL
 AuTfUTwci+vfIAmyP4rexTejvePxGjkNx/UJx5KmYJ2Lk0ioBu
 WaFI/Q8pwcBF5IrUN0V0/JxafXIAMpUJxYlSj2Y+hNF24NrRK3
 i2ykAA6TE+rgAs1S38AcOIaxC2IvLjm06h1OudNf2WoU9V+vg7
 AWTYujCNVm/TkbS1CVn6jsUeCcN6AjZjfG8JdlkXgbL0QKYD2Y
 3bhugQpyvCJhFTqzjfEIZSNjYRstQr1fldzi32kTCHO1t1UV+4
 HOLkUBO6pakJcKhvAraM=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 17 November 2014 11:39:02 Kevin Cernekee wrote:
> On Mon, Nov 17, 2014 at 10:46 AM, Arnd Bergmann <arnd@arndb.de> wrote:
> > On Monday 17 November 2014 09:01:02 Kevin Cernekee wrote:
> >> > If you wanted to do that however, starting with BMIPS you'd have
> >> > to make it possible to define a new platform without the
> >> > arch/mips/include/asm/mach-bmips/ directory (this should be possible
> >> > already, so the hardest part is done), replace all global function
> >> > calls (arch_init_irq, prom_init, get_system_type,  ...) with generic
> >> > platform-independent implementations or wrappers around per-platform
> >> > callbacks, and move the Kconfig section for CONFIG_BMIPS_MULTIPLATFORM
> >> > outside of the "System type" choice statement.
> >>
> >> Right.  The other question is how much support for legacy non-DT
> >> bootloaders really belongs in a true multiplatform kernel, as this
> >> stuff gets hairy fast.
> >
> > Yes, that's why I suggested following PowerPC rather than ARM in this
> > regard.  If you move the boot loader abstraction into the decompressor
> > instead of the platform code, you can avoid a lot of the problems.
> 
> One possible complication: for BCM63xx/BCM7xxx (MIPS) there is no
> decompressor in the kernel.  The firmware loads an ELF image into
> memory and jumps directly to kernel_entry.
> 

Right, that complicates it a bit, but is there a reason why a decompressor
would be hard to do, or would be considered a bad thing?
There is already generic decompressor code in arch/mips/boot/compressed/
that I would assume you could use without firmware changes. Are you
worried about boot time overhead?

	Arnd
