Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752283AbaKQSrI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 13:47:08 -0500
Received: from mout.kundenserver.de ([212.227.126.187]:57780 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751283AbaKQSrG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 13:47:06 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Kevin Cernekee <cernekee@gmail.com>
Cc: Ralf Baechle <ralf@linux-mips.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jon Fraser <jfraser@broadcom.com>, dtor@chromium.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Jason Cooper <jason@lakedaemon.net>,
        Linux MIPS Mailing List <linux-mips@linux-mips.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jonas Gorski <jonas.gorski@gmail.com>
Subject: Re: [PATCH V2 22/22] MIPS: Add multiplatform BMIPS target
Date: Mon, 17 Nov 2014 19:46:41 +0100
Message-ID: <2911624.UJRs5QOPN5@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <CAJiQ=7A29-v5mo1ybvE2UodOZx-FoGeBTHYcTZuX-LaqRaF1Lw@mail.gmail.com>
References: <1416097066-20452-1-git-send-email-cernekee@gmail.com> <3480616.V2TMJFc7uE@wuerfel> <CAJiQ=7A29-v5mo1ybvE2UodOZx-FoGeBTHYcTZuX-LaqRaF1Lw@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:vDFKZ7uD70dL/fqJqzejKQ28ogi4rUhy7k9jmrsfM6t
 TIvXKNFXRt+UZPTloSsaf0je7MsU9Vm2ZvCRLSxLSy/JVKX5er
 n8nMJQRYAQQ/aLOny2lzBN3YXWjaqRQ+d8KySY/OZQHvuLK3iQ
 WDsIsA+oDAw7dT4dYlOQRk0gidvdPsbZjRUzMSQC2LKjoNr/pM
 aACmkVC0GWUy4WEYlfQ6wzx1FBE9zkqSFme6nIclxEWQdMQAJ+
 qpJIooIAJZppNJlt/XXJ5/CAzbd0kTct8QnhSrABqCLLf36w0f
 Y8DWo/ZV/K90gUuX7pTUyScuG8FSdkTp6RutJyKKag8dxymqpi
 XC7hTaHHb/RblhYcrwLY=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 17 November 2014 09:01:02 Kevin Cernekee wrote:
> On Mon, Nov 17, 2014 at 4:16 AM, Arnd Bergmann <arnd@arndb.de> wrote:
> Under arch/mips/bcm47xx I see a single mach type, but different builds
> for BMIPS3300 (R1/SSB) versus MIPS 74K (R2/BCMA).

At least in Kconfig, the two are not mutually exclusive, so I assumed
you could enable them both at the same time.
 
> >> Outside of the CPU, the BCM63xx/BCM33xx/BCM7xxx register maps and
> >> peripherals look pretty different, and the arch/mips/bmips code makes
> >> almost zero assumptions about the rest of the chip if a DTB is passed
> >> in from the bootloader.  In this sense you can see the parallels to
> >> CONFIG_ARCH_MULTI_Vx.
> >>
> >> Prior to this work, these product lines have never been able to share
> >> a common kernel image.
> >
> > I still think this is different in the sense that ARM multiplatform
> > support is about combining platforms from separate mach-* directories,
> > while your approach was to rewrite multiple mach-* directories into
> > a single new one that remains separate from the others.
> 
> There is at least one out-of-tree kernel for each of:
> 
> arch/mips/bcm9338x
> arch/mips/bcm963xx (which predates arch/mips/bcm63xx)
> arch/mips/brcmstb
> 
> each of which was implementing and maintaining the same
> CPU/SMP/cache/IRQ support a little bit differently.
> 
> The femtocell chips (BCM61xxx) may or may not have their own tree as
> well - need to check.  Plus, here in mainline, we currently have an
> arch/mips/bcm63xx tree supporting a different (usually older) subset
> of BCM63xx chipsets.
> 
> It would be nice if we could identify the BMIPS chips that are still
> actively used, and support them all with one mach type instead of 4+.
> There might still be a few special cases but I suspect that several of
> the extra mach directories can be eliminated.

Absolutely agreed.

> > While this is
> > a great improvement, it doesn't get you any closer to having a
> > combined BMIPS+RALINK+JZ4740+ATH79 kernel for instance. I don't know
> > if such a kernel is something that anybody wants, or if it's even
> > technically possible.
> 
> Correct, that isn't the goal for now.
> 
> Given the differences between BMIPS and imgtec MIPS, it is possible
> that making such a multiplatform kernel would be the equivalent of
> making a single image that runs on ARMv5 + ARMv7.  We may want to
> assess the tradeoffs at some point.
> 
> It is possible that a multiplatform BMIPS kernel may run fine on
> reasonably simple non-BMIPS hardware, but that other hardware (e.g.
> supporting SMP, system PM states, or more complicated caches) would
> require a dedicated build.

I see.

> > If you wanted to do that however, starting with BMIPS you'd have
> > to make it possible to define a new platform without the
> > arch/mips/include/asm/mach-bmips/ directory (this should be possible
> > already, so the hardest part is done), replace all global function
> > calls (arch_init_irq, prom_init, get_system_type,  ...) with generic
> > platform-independent implementations or wrappers around per-platform
> > callbacks, and move the Kconfig section for CONFIG_BMIPS_MULTIPLATFORM
> > outside of the "System type" choice statement.
> 
> Right.  The other question is how much support for legacy non-DT
> bootloaders really belongs in a true multiplatform kernel, as this
> stuff gets hairy fast.

Yes, that's why I suggested following PowerPC rather than ARM in this
regard.  If you move the boot loader abstraction into the decompressor
instead of the platform code, you can avoid a lot of the problems.

	Arnd
