Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751300AbaKQMQO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 07:16:14 -0500
Received: from mout.kundenserver.de ([212.227.17.24]:57334 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750800AbaKQMQN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 07:16:13 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Kevin Cernekee <cernekee@gmail.com>
Cc: Ralf Baechle <ralf@linux-mips.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jon Fraser <jfraser@broadcom.com>, dtor@chromium.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Jason Cooper <jason@lakedaemon.net>,
        Linux MIPS Mailing List <linux-mips@linux-mips.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH V2 22/22] MIPS: Add multiplatform BMIPS target
Date: Mon, 17 Nov 2014 13:16:03 +0100
Message-ID: <3480616.V2TMJFc7uE@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <CAJiQ=7C-HniwXiVrqQg3cnFNNYGwoxHJf8JP-XYOqM1yWoyXaw@mail.gmail.com>
References: <1416097066-20452-1-git-send-email-cernekee@gmail.com> <50587083.ieLlCR4VrM@wuerfel> <CAJiQ=7C-HniwXiVrqQg3cnFNNYGwoxHJf8JP-XYOqM1yWoyXaw@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:1zUu8sJmmaojI1BpYVpLc50iENuTjv8clbP9JRqGjdA
 iv1qudfGSEKxmLJKQ0lLPHZ2tUNLeoGsHpaHGTUXy20z4Kiwj+
 AmpPHcYCXsWAI9rRX/qTL2CPltnFPnAqcyBfsXyoKhLDe6vfr2
 LlMXyVHrr8mYEQsZQRywiIbALBEoZZLl4ePkzSPr5tOpvsLFaX
 lQFoOS4TCZ50yPtaosZg0/3vmZ85zLRhatZSSKIhGJNlGeUUj4
 vnq1pW9rkubIsBZPD/ifyBcLZL1nLPl5FRCAwymVNXSzJUk+DP
 HWn7BdptyPsdcfZAPAnA+dF6b0VGoSbLB/ffmSFoo4whyrro4C
 uBVdEYnMzF3F++IA/P20=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 16 November 2014 14:12:44 Kevin Cernekee wrote:
> On Sun, Nov 16, 2014 at 1:24 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> > On Saturday 15 November 2014 16:17:46 Kevin Cernekee wrote:
> >> +config BMIPS_MULTIPLATFORM
> >> +       bool "Broadcom BCM33xx/BCM63xx/BCM7xxx multiplatform kernel"
> >> +       select BOOT_RAW
> >> +       select NO_EXCEPT_FILL
> >> +       select USE_OF
> >> +       select BUILTIN_DTB
> >> +       select FW_CFE
> >> +       select CEVT_R4K
> >> +       select CSRC_R4K
> >> +       select SYNC_R4K
> >> +       select COMMON_CLK
> >> +       select BCM7038_L1_IRQ
> >> +       select BCM7120_L2_IRQ
> >> +       select BRCMSTB_L2_IRQ
> >> +       select IRQ_CPU
> >> +       select RAW_IRQ_ACCESSORS
> >> +       select DMA_NONCOHERENT
> >> +       select SYS_SUPPORTS_32BIT_KERNEL
> >> +       select SYS_SUPPORTS_LITTLE_ENDIAN
> >> +       select SYS_SUPPORTS_BIG_ENDIAN
> >> +       select SYS_SUPPORTS_HIGHMEM
> >> +       select SYS_HAS_CPU_BMIPS3300
> >> +       select SYS_HAS_CPU_BMIPS4350
> >> +       select SYS_HAS_CPU_BMIPS4380
> >> +       select SYS_HAS_CPU_BMIPS5000
> >> +       select SWAP_IO_SPACE
> >> +       select USB_EHCI_BIG_ENDIAN_DESC
> >> +       select USB_EHCI_BIG_ENDIAN_MMIO
> >> +       select USB_OHCI_BIG_ENDIAN_DESC
> >> +       select USB_OHCI_BIG_ENDIAN_MMIO
> >
> > You mentioned in another thread that all MMIO is byteswapped based on the
> > jumper setting. Should the USB options have an 'if CPU_BIG_ENDIAN'
> > behind them? I think it will still work in the current way, but when you
> > know that you have little-endian registers, it is more efficient
> > not to set these.
> 
> Right, it works OK this way because the USB_*_BIG_ENDIAN_* options
> just allow the USB drivers to accept the "big-endian" DT property.
> They don't actually force any endian swaps on their own.
> 
> I can add the extra condition if warranted.  On an LE build it saves
> about 19kB = 0.3% in .text:
> 
> $ size vmlinux vmlinux.orig
>    text       data        bss        dec        hex    filename
> 5945044    6227964     263936    12436944     bdc5d0    vmlinux
> 5963924    6227964     263936    12455824     be0f90    vmlinux.orig
> 
> ("data" includes an initramfs so it's huge, but removing it doesn't
> impact the "text" column.)

I think 19kb is worth it, though I was actually more interested in the
runtime overhead.

> At some point I'd also like to get the of_device_is_big_endian() patch
> merged, and then use it to harmonize the way endian swapping works
> across serial8250, libahci, and maybe USB.  Depending on the
> size/complexity impact and the level of passion surrounding the topic,
> this might also involve getting rid of the compile-time optimizations,
> or at least simplifying them down to a single option instead of 6.

Yes, good idea.

> > It's probably not a wrong description here, but for anybody reading this
> > who also works on ARM, it seems rather confusing because there,
> > "multiplatform" implies that the particular SoC can be built into a
> > generic kernel image that supports SoCs from any vendor whose platform
> > is also marked as "multiplatform", as long as the CPU architecture level
> > (v4/v5, or v6/v7, or v8) is the same.
> 
> The BMIPS multiplatform kernel is intended to support any SoC based on
> a 65nm/40nm/28nm BMIPS CPU.  Strictly speaking, "BMIPS" isn't an
> architecture level defined by imgtec, nor is it something that other
> silicon vendors can currently offer.  But the BMIPS CPUs do have their
> own unique CP0 registers, DSP instruction set, errata, and ways of
> handling SMP / cache maintenance / performance counters.

Ok, I see. It looks like you can have a combined kernel that runs on
BMIPS BCM47xx and MIPS32r2 74K BCM47xx already, right?

So it's not fundamentally incompatible with the other platforms?

> Outside of the CPU, the BCM63xx/BCM33xx/BCM7xxx register maps and
> peripherals look pretty different, and the arch/mips/bmips code makes
> almost zero assumptions about the rest of the chip if a DTB is passed
> in from the bootloader.  In this sense you can see the parallels to
> CONFIG_ARCH_MULTI_Vx.
> 
> Prior to this work, these product lines have never been able to share
> a common kernel image.

I still think this is different in the sense that ARM multiplatform
support is about combining platforms from separate mach-* directories,
while your approach was to rewrite multiple mach-* directories into
a single new one that remains separate from the others. While this is
a great improvement, it doesn't get you any closer to having a
combined BMIPS+RALINK+JZ4740+ATH79 kernel for instance. I don't know
if such a kernel is something that anybody wants, or if it's even
technically possible.

If you wanted to do that however, starting with BMIPS you'd have
to make it possible to define a new platform without the
arch/mips/include/asm/mach-bmips/ directory (this should be possible
already, so the hardest part is done), replace all global function
calls (arch_init_irq, prom_init, get_system_type,  ...) with generic
platform-independent implementations or wrappers around per-platform
callbacks, and move the Kconfig section for CONFIG_BMIPS_MULTIPLATFORM
outside of the "System type" choice statement.
Until you do that, your platform isn't "more multipliplatform" than
the others really, it just abstracts the differences between some
SoCs nicer than most.

	Arnd
